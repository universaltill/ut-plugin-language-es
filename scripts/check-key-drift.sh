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
#   - placeholder token mismatch (ut-docs#297, ported from
#     ut-plugin-language-de -- ut-docs#1760; hardened ut-docs#1865): for
#     every key present on both sides, the ORDERED list of printf verbs
#     (%s / %d / %g / ...) extracted from core's value must equal the list
#     extracted from es.json's value, UNLESS both sides use Go's explicit
#     positional verbs (%[1]s, ...) exclusively, in which case they are
#     compared by explicit index instead of writing order -- see
#     verbs_match's own comment for the full reasoning. Template tokens
#     ({{name}}, {0}) are a separate dialect, always compared in order
#     regardless of what the printf side is doing. A dropped or invented
#     token renders a broken string in production; a REORDERED pair
#     without declaring it positionally is just as wrong -- positional
#     formatting feeds arguments in call order, so a swapped %s/%d prints
#     the values in the wrong slots even though both sides have the same
#     token count. Also covers the COUNT of literal %% occurrences
#     (ut-docs#1873): verb_tokens() discards %% as "not a verb" (correctly
#     -- it never consumes an argument), so a translator dropping one of a
#     pair's `%` characters ("50%% off" -> "50% off") shifts what the
#     following real verb parses as to Go's fmt parser without changing
#     the extracted verb-token list at all, and shipped green before this
#     count check existed.
#
# DUPLICATE KEYS (ut-docs#1872): a key defined twice in the same locale
# file is a HARD failure too, checked before anything else in load_json --
# plain json.load silently keeps only the last write, so a file with five
# duplicated keys (the real incident: two lanes each added the same five
# keys at a different point in the file, and git merged both additions
# with no conflict) parsed clean and every check above stayed green. See
# load_json's own comment for the detection mechanism.
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
import re
import sys

core_path, es_path, baseline_path, allowlist_path, mode, core_sha = sys.argv[1:7]

# Ordered format-token extraction (ut-docs#297, hardened ut-docs#1865):
# printf-style verbs (%s, %d, %.2f, %02d, Go's explicit positional
# %[n]verb, ...), template tokens ({{name}}), and positional template
# tokens ({0}). The {{...}} alternative must come before {N} so "{{0}}"
# reads as one template token, not "{0}" inside braces.
#
# Deliberately NOT supported: printf FLAG characters (`-`/`+`/` `/`#`).
# These values are translated prose, not literal Go source, and prose can
# contain "%" immediately followed by a flag-shaped character with no
# fmt.Sprintf behind it at all -- a permissive `[-+ 0#]*` flag class
# false-positived for real on core's own "a 10%-off code" (parsed as flag
# "-" + verb "o"/octal). Every real verb actually used here is a width/
# precision digit run plus a verb letter, never a flag, so requiring a
# digit or verb letter immediately after `%` keeps that shape covered
# while ordinary "N%-word" prose no longer parses as anything. A trailing
# `(?![A-Za-z])` on both verb alternatives closes the sibling gap
# independent review found: without it, "%20den" (Turkish ablative) or
# "10%off" (no hyphen) still parsed as a verb with prose glued on.
TOKEN_RE = re.compile(
    r"%%"
    r"|%\[(\d+)\]\d*(?:\.\d+)?[vTtbcdoOqxXUeEfFgGspw](?![A-Za-z])"
    r"|%\d*(?:\.\d+)?[vTtbcdoOqxXUeEfFgGspw](?![A-Za-z])"
    r"|\{\{[^{}]*\}\}"
    r"|\{\d+\}"
)

def verb_tokens(s):
    # (token_text, explicit_index_or_None, is_template), skipping the %%
    # literal. is_template distinguishes {{..}}/{N} from printf verbs so
    # the two dialects are never compared against each other.
    out = []
    for m in TOKEN_RE.finditer(s):
        tok = m.group(0)
        if tok == "%%":
            continue
        if tok.startswith("{"):
            out.append((tok, None, True))
        else:
            out.append((tok, int(m.group(1)) if m.group(1) else None, False))
    return out

def verb_shape(tok):
    return re.sub(r"^%\[\d+\]", "%", tok)

def printf_tokens(toks):
    return [(t, idx) for t, idx, is_tmpl in toks if not is_tmpl]

def template_tokens(toks):
    return [t for t, _, is_tmpl in toks if is_tmpl]

def mixes_positional_and_implicit(a_pf, b_pf):
    a_pos = any(idx is not None for _, idx in a_pf)
    b_pos = any(idx is not None for _, idx in b_pf)
    def fully_positional(toks):
        return bool(toks) and all(idx is not None for _, idx in toks)
    return (a_pos or b_pos) and not (fully_positional(a_pf) and fully_positional(b_pf))

def percent_literal_count(s):
    # Count of literal %% occurrences (ut-docs#1873). verb_tokens() already
    # extracts these via the same regex but discards them ("not a verb");
    # counting them separately catches a dropped/invented %% that leaves
    # the real verb-token list unchanged but still corrupts the string for
    # Go's fmt parser (see the check description above for the concrete
    # case).
    return sum(1 for m in TOKEN_RE.finditer(s) if m.group(0) == "%%")

def verbs_match(a, b):
    # ORDER MATTERS unless BOTH sides use Go's explicit positional verbs
    # (%[1]s, ...) exclusively -- see guard-i18n.sh's check 8 (ut-docs#1865)
    # for the full reasoning; kept in sync here by hand per ut-docs#312
    # (no shared implementation between core and the packs). Template
    # tokens ({{name}}/{N}) are a SEPARATE dialect and are always compared
    # as their own ordered list regardless of the printf side -- pooling
    # them made a verb required at a template token's argument index,
    # which no translation could ever satisfy (ut-docs#1865 review).
    a_toks, b_toks = verb_tokens(a), verb_tokens(b)
    if percent_literal_count(a) != percent_literal_count(b):
        return False
    if template_tokens(a_toks) != template_tokens(b_toks):
        return False
    a_pf, b_pf = printf_tokens(a_toks), printf_tokens(b_toks)
    a_pos = any(idx is not None for _, idx in a_pf)
    b_pos = any(idx is not None for _, idx in b_pf)
    if not a_pos and not b_pos:
        return [t for t, _ in a_pf] == [t for t, _ in b_pf]
    if mixes_positional_and_implicit(a_pf, b_pf):
        return False
    a_map = {idx: verb_shape(t) for t, idx in a_pf}
    b_map = {idx: verb_shape(t) for t, idx in b_pf}
    return a_map == b_map

def load_json(path, label):
    # Duplicate-key detection (ut-docs#1872): plain json.load silently keeps
    # only the LAST of a duplicated top-level key, so a file with the same
    # key written twice parses "successfully" into a dict that looks no
    # different from a clean one -- every check below is blind to it. Real
    # precedent: two lanes each independently added the same five keys to
    # this pack's locale file at a different point in the file, git merged
    # both additions with no conflict, and this check reported a clean pass
    # against a file that actually had five keys defined twice. Reading the
    # raw key/value PAIR list via object_pairs_hook, instead of letting the
    # dict constructor silently collapse it, is what makes the duplicate
    # visible before anything discards it. Treated as the same class of hard
    # failure as invalid JSON -- a file that can't be trusted to mean what
    # its parsed form says isn't safe input for any check that follows.
    dupes = []

    def hook(pairs):
        seen = set()
        for k, _ in pairs:
            if k in seen:
                dupes.append(k)
            seen.add(k)
        return dict(pairs)

    try:
        with open(path) as f:
            data = json.load(f, object_pairs_hook=hook)
    except Exception as e:
        print(f"check-key-drift: FAILED to parse {label} {path}: {e}", file=sys.stderr)
        sys.exit(1)
    if dupes:
        print(
            f"check-key-drift: {path} has duplicate key(s) (last write silently wins): "
            + ", ".join(sorted(set(dupes))),
            file=sys.stderr,
        )
        sys.exit(1)
    return data

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

# Token parity (ut-docs#297, hardened ut-docs#1865): same verbs, same
# order, on every shared key -- except a key where BOTH sides use Go's
# explicit positional verbs exclusively, which may legitimately reorder
# (compared by explicit index instead of writing order; see verbs_match).
token_mismatches = [
    (
        k,
        [t for t, _, _ in verb_tokens(core[k])],
        [t for t, _, _ in verb_tokens(es[k])],
        mixes_positional_and_implicit(printf_tokens(verb_tokens(core[k])), printf_tokens(verb_tokens(es[k]))),
        percent_literal_count(core[k]),
        percent_literal_count(es[k]),
    )
    for k in sorted(core_keys & es_keys)
    if not verbs_match(core[k], es[k])
]

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

if token_mismatches:
    fail = True
    print(f"check-key-drift: {len(token_mismatches)} key(s) in {es_path} have a placeholder token mismatch against core (dropped, invented, or reordered %s/{{...}}/{{N}} tokens):")
    for k, ct, dt, mixed, core_pct, es_pct in token_mismatches:
        if core_pct != es_pct:
            note = f" (differing count of literal %% occurrences: {core_pct} vs {es_pct})"
        elif mixed:
            note = " (mixes positional and implicit verbs; use one style consistently on both sides)"
        else:
            note = ""
        print(f"  - {k}: core={ct} es={dt}{note}")

print(f"check-key-drift: core commit: {core_sha}")

if fail:
    sys.exit(1)

translated = len(core_keys) - len(missing)
print(f"check-key-drift: ok -- {translated}/{len(core_keys)} core keys translated, "
      f"{len(missing)} known-untranslated (baseline), {len(allowlist)} known-same-as-English (allowlist), "
      f"0 drift, 0 orphans, 0 empty values, 0 untranslated-present, 0 token mismatches")
PY
