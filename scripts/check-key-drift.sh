#!/usr/bin/env bash
#
# Ratcheting key-parity guard against core's base locale (ut-docs#296,
# porting the guard ut-docs#292 built for the German pack).
#
# WHY A RATCHET, NOT EXACT PARITY: this pack only translates a subset of
# core's web/locales/en.json keys today (run the script to see the current
# count -- hardcoding it here would go stale on core's next commit, exactly
# the overclaim ut-docs#292's own review flagged and fixed elsewhere).
# Most of core's keys are legitimately untranslated (ADR-0010: a language
# pack is an asset-only overlay; core's T() falls back es -> en on a
# missing key, so an untranslated key degrades gracefully to English
# rather than breaking the till). Demanding this script fail until every
# one of those gaps is translated would make it useless noise from day
# one, so the check is NOT "es.json == en.json"; it's
# "the untranslated set today is EXACTLY the untranslated set the baseline
# file says we already know about, no more, no less" -- PLUS: every key
# es.json claims to translate must actually carry a real, non-empty,
# actually-Spanish value (see "value checks" below), because a key present
# in es.json is not by itself evidence of a translation.
#
# What actually broke in #292 (the German pack): core shipped 6 new
# pfand.* keys and that pack was never updated, so a German till silently
# rendered English ("Deposit refund" instead of "Pfandrückgabe") --
# ADR-0010's fallback masked the gap instead of surfacing it. This pack had
# translated the identical number of core keys (164, before this fix) as
# the pre-fix German pack, including the same missing pfand.* keys --
# discovered alongside it, ut-docs#296. This script is what should have
# caught both: any NEW gap between core and es.json that isn't already
# accounted for in the baseline is drift, and drift fails CI loudly
# instead of shipping silently.
#
# The baseline (i18n-baseline/es.untranslated.txt) tracks known-accepted
# gaps:
#   - a core key with no es.json translation is fine IFF it's already
#     listed in the baseline (known, accepted debt);
#   - a core key with no es.json translation that is NOT in the baseline
#     is new drift -- FAIL (this is what would have caught #296);
#   - a baseline entry that HAS since been translated is a stale baseline
#     entry -- FAIL (forces pruning, so the baseline can never quietly
#     grow stale and hide a real re-regression later);
#   - a baseline entry core no longer has is also stale -- FAIL, prune it;
#   - an es.json key core doesn't have at all is an orphan -- FAIL always,
#     no baseline exception (a pack has no business inventing base keys).
# This set cannot grow SILENTLY: it can only grow through a deliberate,
# reviewed edit to the baseline file itself, which shows up in the diff.
# That is not the same claim as "only shrinks" -- adding a key on purpose
# is the documented escape hatch, not a violation of the guard.
#
# VALUE CHECKS (the part key-set comparison alone misses): a key can be
# *present* in es.json and still not be a real translation --
#   - empty / whitespace-only value -- FAIL always. Core's T() returns
#     whatever es.json has unconditionally, so an empty value renders
#     blank UI in production, which is worse than the English fallback a
#     missing key would have produced.
#   - value byte-identical to core's English value -- FAIL, UNLESS the key
#     is listed in the same-as-English allowlist
#     (i18n-baseline/es.same-as-en.txt) for strings that are legitimately
#     identical in both languages (brand names, "Online", "GitHub", ...).
#     This is the literal ut-docs#292 bug, applied to this pack: a key
#     present with the verbatim, never-translated English string
#     ("pfand.action": "Deposit refund") would pass a key-set-only check.
#   - the allowlist has the same staleness rule as the baseline: an entry
#     that is no longer byte-identical (translated since, or core's string
#     changed) or whose key no longer exists must FAIL so it gets pruned.
#
# A missing/unreachable core source is a HARD failure, never a skip: a
# guard that quietly exits 0 when it can't fetch its own input is the
# exact silent-gap failure mode this script exists to close.
#
# Usage:
#   scripts/check-key-drift.sh                 # run the check (default)
#   scripts/check-key-drift.sh --update-baseline    # rewrite the baseline
#   scripts/check-key-drift.sh --update-allowlist   # rewrite the allowlist
# Both --update-* flags resolve core's base locale exactly like the check
# does (UT_CORE_EN_JSON / UT_CORE_EN_URL / CORE_EN_URL below), so there is
# one single source of truth for "how do I find core's en.json" -- no
# hand-rolled comm/jq pipeline to keep in sync separately.
#
# NOTE on duplication: this script is currently a per-repo copy of the one
# ut-plugin-language-de carries (ut-docs#292) -- see this repo's
# docs/code-reviews/2026-08-06-es-pfand-keys-and-drift-guard.md and
# ut-docs#312 for why a shared cross-repo implementation was deliberately
# deferred to its own card rather than folded into this change.
set -euo pipefail

MODE="check"
case "${1:-}" in
    --update-baseline) MODE="update-baseline" ;;
    --update-allowlist) MODE="update-allowlist" ;;
    "") ;;
    *)
        echo "check-key-drift: unknown argument: $1" >&2
        echo "usage: $0 [--update-baseline|--update-allowlist]" >&2
        exit 1
        ;;
esac

# Resolve UT_CORE_EN_JSON against the CALLER's cwd before we cd -- a
# relative path here is meant to be relative to wherever the caller ran
# this from, not to the repo root we cd into next.
if [ -n "${UT_CORE_EN_JSON:-}" ]; then
    case "$UT_CORE_EN_JSON" in
        /*) ;; # already absolute
        *) UT_CORE_EN_JSON="$(pwd)/${UT_CORE_EN_JSON}" ;;
    esac
fi

cd "$(dirname "$0")/.."

CORE_EN_URL="${UT_CORE_EN_URL:-https://raw.githubusercontent.com/universaltill/universal-till/main/web/locales/en.json}"
BASELINE="i18n-baseline/es.untranslated.txt"
ALLOWLIST="i18n-baseline/es.same-as-en.txt"
ES_LOCALE="locales/es.json"

CORE_EN_JSON=""
CORE_TMP=""
cleanup() {
    # NB: must not end on a false test -- "[ -n "$x" ] && rm ..." evaluates
    # to the test's (false) status when $x is empty, and that becomes the
    # trap's exit status, which becomes the whole script's exit status,
    # silently turning a real success into a false failure.
    if [ -n "$CORE_TMP" ]; then
        rm -f "$CORE_TMP"
    fi
}
trap cleanup EXIT INT TERM

# Resolve core's base locale JSON to a local file, one way or the other.
# UT_CORE_EN_JSON lets this run offline / in tests without hitting network.
if [ -n "${UT_CORE_EN_JSON:-}" ]; then
    CORE_EN_JSON="${UT_CORE_EN_JSON}"
    if [ ! -f "$CORE_EN_JSON" ]; then
        echo "check-key-drift: UT_CORE_EN_JSON=${CORE_EN_JSON} does not exist" >&2
        exit 1
    fi
else
    CORE_TMP="$(mktemp)"
    CORE_EN_JSON="$CORE_TMP"
    CORE_SHA="unknown"
    if command -v gh >/dev/null 2>&1; then
        CORE_SHA="$(gh api repos/universaltill/universal-till/commits/main --jq .sha 2>/dev/null || echo unknown)"
    fi
    if ! curl -fsSL "$CORE_EN_URL" -o "$CORE_EN_JSON"; then
        echo "check-key-drift: FAILED to fetch core base locale from ${CORE_EN_URL}" >&2
        echo "check-key-drift: cannot verify key parity -- refusing to pass silently." >&2
        echo "check-key-drift: set UT_CORE_EN_JSON=<path> to check against a local checkout instead." >&2
        echo "check-key-drift: resolved core commit: ${CORE_SHA}" >&2
        exit 1
    fi
fi

python3 - "$CORE_EN_JSON" "$ES_LOCALE" "$BASELINE" "$ALLOWLIST" "$MODE" "${CORE_SHA:-unknown}" <<'PY'
import json
import sys

core_path, es_path, baseline_path, allowlist_path, mode, core_sha = sys.argv[1:7]

def load_json(path, label):
    try:
        return json.load(open(path))
    except Exception as e:
        print(f"check-key-drift: FAILED to parse {label} {path}: {e}", file=sys.stderr)
        sys.exit(1)

def load_keylist(path, label):
    try:
        lines = open(path).read().splitlines()
    except Exception as e:
        print(f"check-key-drift: FAILED to read {label} {path}: {e}", file=sys.stderr)
        sys.exit(1)
    body = [ln.strip() for ln in lines if ln.strip() and not ln.strip().startswith("#")]
    if body != sorted(set(body)):
        print(
            f"check-key-drift: {path} is not sorted/deduplicated -- it must be "
            "one key per line, sorted, unique. Regenerate it instead of hand-editing.",
            file=sys.stderr,
        )
        sys.exit(1)
    return set(body)

def leading_header(path):
    """The leading run of blank/comment lines in a keylist file -- preserved
    verbatim when the body is regenerated, so --update-* never clobbers the
    file's own documentation."""
    with open(path) as f:
        all_lines = f.read().splitlines(keepends=True)
    hdr = []
    for line in all_lines:
        if line.lstrip().startswith("#") or line.strip() == "":
            hdr.append(line)
        else:
            break
    return hdr

def rewrite_body(path, keys):
    hdr = leading_header(path)
    with open(path, "w") as f:
        f.writelines(hdr)
        for k in keys:
            f.write(k + "\n")

core = load_json(core_path, "core base locale")
es = load_json(es_path, "es locale")

core_keys = set(core.keys())
es_keys = set(es.keys())

if mode == "update-baseline":
    missing = sorted(core_keys - es_keys)
    rewrite_body(baseline_path, missing)
    print(f"check-key-drift: wrote {len(missing)} entries to {baseline_path}")
    sys.exit(0)

if mode == "update-allowlist":
    identical_now = sorted(k for k in (core_keys & es_keys) if es[k] == core[k])
    rewrite_body(allowlist_path, identical_now)
    print(f"check-key-drift: wrote {len(identical_now)} entries to {allowlist_path}")
    sys.exit(0)

baseline = load_keylist(baseline_path, "baseline")
allowlist = load_keylist(allowlist_path, "same-as-English allowlist")

missing = core_keys - es_keys       # core has it, es.json doesn't
orphans = es_keys - core_keys       # es.json has it, core doesn't

new_drift = sorted(missing - baseline)          # untranslated, not in baseline
stale_translated = sorted(baseline - missing)    # in baseline, but not actually missing anymore

# Value checks: a key can be present and still not be a real translation.
empty_keys = {k for k in es_keys if es[k].strip() == ""}
empty_values = sorted(empty_keys)

identical_to_en = {k for k in (core_keys & es_keys) if k not in empty_keys and es[k] == core[k]}
untranslated_present = sorted(identical_to_en - allowlist)
stale_allowlist = sorted(k for k in allowlist if k not in identical_to_en)

fail = False

if new_drift:
    fail = True
    print(f"check-key-drift: {len(new_drift)} core key(s) missing from {es_path} and NOT in the baseline (new drift):")
    for k in new_drift:
        print(f"  - {k}")

if stale_translated:
    fail = True
    print(f"check-key-drift: {len(stale_translated)} baseline entr(y/ies) in {baseline_path} are stale (translated, or core dropped them) -- prune them:")
    for k in stale_translated:
        print(f"  - {k}")

if orphans:
    fail = True
    print(f"check-key-drift: {len(orphans)} orphan key(s) in {es_path} that core no longer has:")
    for k in sorted(orphans):
        print(f"  - {k}")

if empty_values:
    fail = True
    print(f"check-key-drift: {len(empty_values)} key(s) in {es_path} have an empty or whitespace-only value:")
    for k in empty_values:
        print(f"  - {k}")

if untranslated_present:
    fail = True
    print(f"check-key-drift: {len(untranslated_present)} key(s) in {es_path} are byte-identical to core's English value and NOT in the allowlist (untranslated-but-present):")
    for k in untranslated_present:
        print(f"  - {k}")

if stale_allowlist:
    fail = True
    print(f"check-key-drift: {len(stale_allowlist)} allowlist entr(y/ies) in {allowlist_path} are stale (no longer identical to core, or key missing) -- prune them:")
    for k in stale_allowlist:
        print(f"  - {k}")

print(f"check-key-drift: core commit: {core_sha}")

if fail:
    sys.exit(1)

translated = len(core_keys) - len(missing)
print(f"check-key-drift: ok -- {translated}/{len(core_keys)} core keys translated, "
      f"{len(missing)} known-untranslated (baseline), {len(allowlist)} known-same-as-English (allowlist), "
      f"0 drift, 0 orphans, 0 empty values, 0 untranslated-present")
PY
