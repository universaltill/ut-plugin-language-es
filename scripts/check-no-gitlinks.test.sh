#!/usr/bin/env bash
# Tests for scripts/check-no-gitlinks.sh (ut-docs#5289).
#
# Each case builds a throwaway git repo in a mktemp dir (never the real
# tree), copies the real guard into it and runs it there, then asserts BOTH
# the exit code AND the output -- a guard that exits non-zero for the wrong
# reason (e.g. a syntax error) must not pass as a test of the real check.
set -euo pipefail
cd "$(dirname "$0")/.."

REAL_SCRIPT="$(pwd)/scripts/check-no-gitlinks.sh"
FAKE_SHA="1111111111111111111111111111111111111111"
FAILS=0

work_dir=""
cleanup() {
    [ -n "$work_dir" ] && rm -rf "$work_dir"
}
trap cleanup EXIT

# fresh_case: a new throwaway repo with one tracked file and the guard copied
# in (the guard cd's relative to its own path, so it must run from inside).
fresh_case() {
    [ -n "$work_dir" ] && rm -rf "$work_dir"
    work_dir="$(mktemp -d)"
    case_dir="${work_dir}/repo"
    mkdir -p "${case_dir}/scripts"
    cp "$REAL_SCRIPT" "${case_dir}/scripts/check-no-gitlinks.sh"
    chmod +x "${case_dir}/scripts/check-no-gitlinks.sh"
    git -C "$case_dir" init -q
    echo hello > "${case_dir}/file.txt"
    git -C "$case_dir" add file.txt
}

add_gitlink() {
    git -C "$case_dir" update-index --add --cacheinfo "160000,${FAKE_SHA},$1"
}

# run_guard: sets $out and $rc.
run_guard() {
    set +e
    out="$("${case_dir}/scripts/check-no-gitlinks.sh" 2>&1)"
    rc=$?
    set -e
}

expect() { # NAME WANT_RC [SUBSTRING...]
    local name="$1" want="$2"
    shift 2
    if [ "$rc" -ne "$want" ]; then
        echo "FAIL [$name]: exit $rc, want $want. Output:"
        echo "$out"
        FAILS=$((FAILS + 1))
        return
    fi
    local s
    for s in "$@"; do
        if ! grep -qF -- "$s" <<<"$out"; then
            echo "FAIL [$name]: output does not contain '$s'. Output:"
            echo "$out"
            FAILS=$((FAILS + 1))
            return
        fi
    done
    echo "ok   [$name]"
}

fresh_case
run_guard
expect "clean repo passes" 0 "ok: no stray gitlinks"

fresh_case
add_gitlink ".worktrees/ai-4129"
run_guard
expect "gitlink without .gitmodules fails and names the path" 1 ".worktrees/ai-4129"

fresh_case
add_gitlink ".worktrees/one"
add_gitlink "other/two"
run_guard
expect "every gitlink is named" 1 ".worktrees/one" "other/two"

fresh_case
add_gitlink "vendor/sub"
printf '[submodule "vendor/sub"]\n\tpath = vendor/sub\n\turl = https://example.invalid/sub.git\n' > "${case_dir}/.gitmodules"
git -C "$case_dir" add .gitmodules
run_guard
expect "gitlink declared in tracked .gitmodules passes" 0 "ok: no stray gitlinks"

# A tracked .gitmodules that does not declare the path still breaks checkout.
fresh_case
add_gitlink ".worktrees/x"
printf '[submodule "other"]\n\tpath = other\n\turl = https://example.invalid/o.git\n' > "${case_dir}/.gitmodules"
git -C "$case_dir" add .gitmodules
run_guard
expect "gitlink missing from tracked .gitmodules fails" 1 ".worktrees/x"

# An untracked .gitmodules does not count: checkout only sees tracked files.
fresh_case
add_gitlink "vendor/sub"
echo '[submodule "x"]' > "${case_dir}/.gitmodules"
run_guard
expect "untracked .gitmodules does not excuse a gitlink" 1 "vendor/sub"

if [ "$FAILS" -ne 0 ]; then
    echo "$FAILS case(s) failed"
    exit 1
fi
echo "all check-no-gitlinks cases passed"
