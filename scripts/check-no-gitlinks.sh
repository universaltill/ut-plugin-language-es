#!/usr/bin/env bash
#
# Fails when the index holds a gitlink (mode 160000) that no tracked
# .gitmodules declares (ut-docs#5289).
#
# WHY THIS EXISTS: an agent worktree committed by accident (.worktrees/ai-4129,
# ut-docs#5127) is recorded as a gitlink. With no .gitmodules, every
# `actions/checkout` of the repo dies with "fatal: No url found for submodule
# path ... in .gitmodules", which broke universal-till's locale-render-audit.
# Packs have no submodules, so any gitlink here is a mistake.
set -euo pipefail
cd "$(dirname "$0")/.."

# Paths .gitmodules declares (only when it is tracked: checkout sees only
# tracked files). A gitlink missing from it fails checkout just the same.
declared=""
if git ls-files --error-unmatch -- .gitmodules >/dev/null 2>&1; then
    declared="$(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' | cut -d' ' -f2- || true)"
fi

stray=""
while IFS= read -r p; do
    [ -n "$p" ] || continue
    if ! grep -qxF -- "$p" <<<"$declared"; then
        stray="${stray}${p}"$'\n'
    fi
done < <(git ls-files -s | awk '$1 == "160000" { sub(/^[^\t]*\t/, ""); print }')

if [ -n "$stray" ]; then
    echo "FAIL: gitlink (mode 160000) entries not declared in a tracked .gitmodules:" >&2
    while IFS= read -r p; do
        [ -n "$p" ] && echo "  $p" >&2
    done <<<"$stray"
    echo "Remove each with: git rm --cached <path> (ut-docs#5289)" >&2
    exit 1
fi
echo "ok: no stray gitlinks"
