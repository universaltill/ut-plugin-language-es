# Code review: fix malformed shellcheck directive in `check-version-bump.sh` (ut-docs#1948)

**Date:** 2026-09-10
**Branch:** `fix/1948-shellcheck-directive-parse-error`
**Implementer:** Sonnet (inline, cloud lane `lane:cloud-54`)
**Reviewer:** Opus (fresh-context subagent, independent of the implementation)

## What changed

`scripts/check-version-bump.sh:77-79` carried:

```sh
# shellcheck disable=SC2053 -- intentional unquoted glob match
if [[ "$f" == $pat ]]; then
```

Trailing prose on the same line as a `shellcheck disable=` directive breaks
shellcheck's own parser (`SC1072`/`SC1073` — "Expected '=' after directive
key" / "Couldn't parse this shellcheck directive") instead of successfully
suppressing `SC2053` — the exact failure shape `universal-till/CLAUDE.md`
documents ("a shellcheck directive comment must carry only `key=value`
pairs — trailing prose on the same line fails to parse, SC1072/SC1073").

Fixed to:

```sh
# Intentional unquoted glob match ($pat is a pattern, not a literal).
# shellcheck disable=SC2053
if [[ "$f" == $pat ]]; then
```

This script is a per-repo copy of `ut-plugin-language-de`'s (per this
repo's own `CLAUDE.md`), inheriting the bug from there as part of the
ut-docs#1948 version-bump-guard rollout. The same bug was found and fixed
independently in three sibling repos in the same rollout
(`ut-plugin-theme-midnight`, `ut-plugin-theme-screen-top`,
`ut-plugin-theme-buttons-left` — "F1" in each of their reviews) but was
never ported back to the two repos (`ut-plugin-language-de`/`-es`) it
originated from. This PR is that port; the matching `-de` PR lands
alongside it.

## Why this matters beyond style

Confirmed by the reviewer: in the broken form, shellcheck's parse **aborts
entirely** at the malformed directive — the rest of the file (160+ lines)
was never analysed at all, not just the one suppressed line. This script
was getting effectively zero shellcheck coverage before this fix.

## Verified beyond automated tests

- `shellcheck scripts/check-version-bump.sh`: reproduces `SC1072`/`SC1073`
  on `main`'s current form; clean (exit 0, no output) after the fix.
- Confirmed the directive is load-bearing, not decorative: removing just
  the `# shellcheck disable=SC2053` line (keeping the explanatory comment)
  makes shellcheck correctly re-surface `SC2053` at the `if` line — so the
  fixed directive is attached to the right statement and genuinely
  suppresses a real finding.
- `bash scripts/check-version-bump.test.sh`: 11/11 cases pass, unchanged.
- `bash scripts/validate.sh`: clean (`v1.1.35`).
- `bash scripts/check-key-drift.sh`: clean (`2258/2259 core keys
  translated … 0 drift`), unaffected by this diff (no locale file
  touched).
- `BASE_SHA=$(git rev-parse main) bash scripts/check-version-bump.sh`
  itself: confirms no shipped file is touched by this diff (`scripts/*` is
  not in `SHIPPED_PATTERNS`), so no `manifest.json` version bump is
  required for this PR.
- Commit author/committer: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>` — re-verified against
  `.github/workflows/commit-attribution.yml`'s own `BANNED_RE` logic
  locally; passes.

## Independent review findings

None blocking. One informational note, pre-existing and unrelated to this
diff: neither this repo nor `-de` runs `shellcheck` in CI — this fix
restores real static-analysis coverage for local runs but has no
CI-visible effect here (unlike `universal-till`, which gates on it).

**Verdict: SAFE TO MERGE.**
