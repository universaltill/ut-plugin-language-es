#!/usr/bin/env bash
# Tests for scripts/check-key-drift.sh (ut-docs#296).
#
# Each case builds a throwaway fixture (a fake core en.json + a temp copy of
# this repo's layout) and runs the real script against it via
# UT_CORE_EN_JSON (or, for the network-failure case, UT_CORE_EN_URL), then
# asserts BOTH the exit code AND that the failure output actually names the
# right category heading AND the right key -- a script that exits non-zero
# for the wrong reason (e.g. a bash syntax error, or the right exit code but
# a mis-categorised report) must not be mistaken for a passing test of the
# real check.
set -euo pipefail
cd "$(dirname "$0")/.."

REAL_SCRIPT="$(pwd)/scripts/check-key-drift.sh"
FAILS=0

work_dir=""
cleanup() {
    [ -n "$work_dir" ] && rm -rf "$work_dir"
}
trap cleanup EXIT

# fresh_case NAME
# Builds a throwaway "repo" ($case_dir) that is a temp working copy of just
# enough of this repo's layout for the script under test to operate on: its
# own scripts/check-key-drift.sh (copied verbatim -- the script does
# `cd "$(dirname "$0")/.."`, which resolves relative to ITS OWN path, so it
# must be invoked from inside the fixture, not the real repo, or it would
# silently check the real repo's files instead of the fixture's) plus
# locales/ and i18n-baseline/ dirs the caller fills in. $core_json is a fake
# core en.json path. Removes the PREVIOUS case's work_dir first -- each call
# used to leak its own mktemp dir (5 fresh_case calls, 1 cleanup at exit);
# the final trap still catches the very last one.
fresh_case() {
    [ -n "$work_dir" ] && rm -rf "$work_dir"
    work_dir="$(mktemp -d)"
    case_dir="${work_dir}/repo"
    mkdir -p "${case_dir}/locales" "${case_dir}/scripts" "${case_dir}/i18n-baseline"
    cp "$REAL_SCRIPT" "${case_dir}/scripts/check-key-drift.sh"
    chmod +x "${case_dir}/scripts/check-key-drift.sh"
    core_json="${work_dir}/core-en.json"
    # Every case gets an empty allowlist by default; cases that care about
    # the allowlist overwrite it.
    : > "${case_dir}/i18n-baseline/es.same-as-en.txt"
}

run_check() {
    # runs from inside case_dir, exactly like the real script expects
    (cd "$case_dir" && UT_CORE_EN_JSON="$core_json" bash "scripts/check-key-drift.sh")
}

run_check_network() {
    # like run_check, but does NOT set UT_CORE_EN_JSON, so the script must
    # actually hit the network (CORE_EN_URL / UT_CORE_EN_URL) -- used for
    # the unreachable-host case.
    (cd "$case_dir" && UT_CORE_EN_URL="$1" bash "scripts/check-key-drift.sh")
}

assert_pass() {
    local name="$1"
    shift
    local out rc
    set +e
    out="$("$@" 2>&1)"
    rc=$?
    set -e
    if [ "$rc" -ne 0 ]; then
        echo "FAIL [$name]: expected exit 0, got $rc. Output:"
        echo "$out"
        FAILS=$((FAILS + 1))
        return
    fi
    echo "ok   [$name]"
}

# assert_fail_containing NAME NEEDLE [NEEDLE...]
# Asserts non-zero exit AND that the output contains every needle given --
# always both the category heading text (e.g. "NOT in the baseline", "are
# stale", "orphan key(s)") AND the specific key name, so a report that names
# the right key under the WRONG heading (mis-categorised) still fails the
# test.
assert_fail_containing() {
    local name="$1"
    shift
    local out rc
    set +e
    out="$(run_check 2>&1)"
    rc=$?
    set -e
    if [ "$rc" -eq 0 ]; then
        echo "FAIL [$name]: expected non-zero exit, got 0. Output:"
        echo "$out"
        FAILS=$((FAILS + 1))
        return
    fi
    local needle
    for needle in "$@"; do
        if ! grep -qF -- "$needle" <<<"$out"; then
            echo "FAIL [$name]: exited non-zero (good) but output did not mention expected reason ('$needle'). Output:"
            echo "$out"
            FAILS=$((FAILS + 1))
            return
        fi
    done
    echo "ok   [$name] (exit $rc, mentions: $*)"
}

# assert_fail_containing_network NAME URL NEEDLE [NEEDLE...]
assert_fail_containing_network() {
    local name="$1" url="$2"
    shift 2
    local out rc
    set +e
    out="$(run_check_network "$url" 2>&1)"
    rc=$?
    set -e
    if [ "$rc" -eq 0 ]; then
        echo "FAIL [$name]: expected non-zero exit, got 0. Output:"
        echo "$out"
        FAILS=$((FAILS + 1))
        return
    fi
    local needle
    for needle in "$@"; do
        if ! grep -qF -- "$needle" <<<"$out"; then
            echo "FAIL [$name]: exited non-zero (good) but output did not mention expected reason ('$needle'). Output:"
            echo "$out"
            FAILS=$((FAILS + 1))
            return
        fi
    done
    echo "ok   [$name] (exit $rc, mentions: $*)"
}

# --- case 1: clean state -> exit 0 -----------------------------------------
fresh_case "clean"
cat > "$core_json" <<'JSON'
{
  "a.one": "One",
  "a.two": "Two",
  "b.three": "Three"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
# baseline
a.two
b.three
TXT
assert_pass "clean state" run_check

# --- case 2: new core key missing from es.json AND baseline -> fail --------
fresh_case "new-drift"
cat > "$core_json" <<'JSON'
{
  "a.one": "One",
  "pfand.action": "Deposit refund"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
# baseline (deliberately does not list pfand.action)
TXT
assert_fail_containing "new drift (uncataloged missing key)" "NOT in the baseline" "pfand.action"

# --- case 3: baseline entry already translated (stale) -> fail ------------
fresh_case "stale-baseline"
cat > "$core_json" <<'JSON'
{
  "a.one": "One",
  "a.two": "Two"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno",
  "a.two": "Dos"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
a.two
TXT
assert_fail_containing "stale baseline entry (now translated)" "are stale" "a.two"

# --- case 4: es.json key core no longer has (orphan) -> fail --------------
fresh_case "orphan"
cat > "$core_json" <<'JSON'
{
  "a.one": "One"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno",
  "a.ghost": "Fantasma"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
assert_fail_containing "orphan key" "orphan key(s)" "a.ghost"

# --- case 5: missing/unreadable UT_CORE_EN_JSON path -> fail, no silent pass
fresh_case "unreadable-core"
# deliberately do NOT create $core_json
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
assert_fail_containing "unreadable core en.json" "does not exist"

# --- case 6: unreachable fetch (real network path, bad host) -> fail ------
fresh_case "unreachable-network"
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
assert_fail_containing_network "unreachable core URL" \
    "https://this-host-does-not-resolve.invalid/en.json" \
    "FAILED to fetch"

# --- case 7: core en.json is invalid JSON -> hard fail, never a skip ------
fresh_case "core-invalid-json"
printf '{ not valid json' > "$core_json"
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
assert_fail_containing "core en.json invalid JSON" "FAILED to parse" "core base locale"

# --- case 8: es.json is invalid JSON -> hard fail, never a skip -----------
fresh_case "es-invalid-json"
cat > "$core_json" <<'JSON'
{
  "a.one": "One"
}
JSON
printf '{ not valid json' > "${case_dir}/locales/es.json"
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
assert_fail_containing "es.json invalid JSON" "FAILED to parse" "es locale"

# --- case 9: baseline file missing -> hard fail, never a skip -------------
fresh_case "baseline-missing"
cat > "$core_json" <<'JSON'
{
  "a.one": "One"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno"
}
JSON
# deliberately do NOT create the baseline file
assert_fail_containing "baseline file missing" "FAILED to read" "baseline"

# --- case 10: empty / whitespace-only value -> fail (item 1) --------------
fresh_case "empty-value"
cat > "$core_json" <<'JSON'
{
  "a.one": "One",
  "pfand.action": "Deposit refund"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno",
  "pfand.action": "   "
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
assert_fail_containing "empty/whitespace value" "empty or whitespace-only value" "pfand.action"

# --- case 11: value present but byte-identical to core's English, not
#              allowlisted -> fail (the same-shaped bug ut-docs#292 found in the German pack: "Deposit
#              refund" verbatim, present, non-empty, so a key-set-only check
#              would have missed it) ---------------------------------------
fresh_case "untranslated-present"
cat > "$core_json" <<'JSON'
{
  "a.one": "One",
  "pfand.action": "Deposit refund"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno",
  "pfand.action": "Deposit refund"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
assert_fail_containing "untranslated-but-present (not allowlisted)" "untranslated-but-present" "pfand.action"

# --- case 12: same as case 11, but the key IS allowlisted -> pass ---------
fresh_case "allowlisted-identical"
cat > "$core_json" <<'JSON'
{
  "a.one": "One",
  "app.name": "Universal Till"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno",
  "app.name": "Universal Till"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
cat > "${case_dir}/i18n-baseline/es.same-as-en.txt" <<'TXT'
app.name
TXT
assert_pass "allowlisted identical value passes" run_check

# --- case 13: stale allowlist entry (no longer identical, or key gone) ---
fresh_case "stale-allowlist"
cat > "$core_json" <<'JSON'
{
  "a.one": "One",
  "app.name": "Universal Till"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno",
  "app.name": "Universal Till GmbH"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
TXT
cat > "${case_dir}/i18n-baseline/es.same-as-en.txt" <<'TXT'
app.name
TXT
assert_fail_containing "stale allowlist entry (translated since)" "are stale" "app.name"

# --- case 14: baseline not sorted/deduplicated -> fail (item 9) -----------
fresh_case "baseline-unsorted"
cat > "$core_json" <<'JSON'
{
  "a.one": "One",
  "a.two": "Two",
  "a.three": "Three"
}
JSON
cat > "${case_dir}/locales/es.json" <<'JSON'
{
  "a.one": "Uno"
}
JSON
cat > "${case_dir}/i18n-baseline/es.untranslated.txt" <<'TXT'
a.two
a.three
a.two
TXT
assert_fail_containing "unsorted/duplicated baseline" "not sorted/deduplicated"

echo
if [ "$FAILS" -ne 0 ]; then
    echo "check-key-drift.test.sh: ${FAILS} test(s) FAILED"
    exit 1
fi
echo "check-key-drift.test.sh: all tests passed"
