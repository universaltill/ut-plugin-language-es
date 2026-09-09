# Review: check-key-drift %% literal-count parity check (ut-docs#1873)

**Date**: 2026-09-09
**Card**: universaltill/ut-docs#1873 — "i18n verb-parity guard doesn't catch
an unbalanced %% (real false negative, found in #1865 review)"
**Complexity**: easy
**Reviewer model**: fresh-context Sonnet subagent (per this card's
`complexity:easy` tier — see `scrum-master` skill's model routing)

## Problem

Same gap as `universal-till/scripts/ci/guard-i18n.sh`'s check 8
(ut-docs#1865): `verbs_match()` compares extracted printf/template verb
lists but discards `%%` as "not a verb". A translator dropping one `%`
from a `%%` pair (`"50%% off, %d left"` -> `"50% off, %d left"`) leaves
the extracted verb list identical on both sides (`['%d']`), so it passed
this check even though the value is corrupted for Go's `fmt` parser. Full
writeup: `universal-till`'s own review record for this card,
`docs/code-reviews/2026-09-09-i18n-percent-literal-count-guard-1873.md`
(this fix mirrors that repo's fix hand-for-hand per ut-docs#312 — no
shared implementation between core and the packs).

## What shipped

`scripts/check-key-drift.sh`: added `percent_literal_count(s)`, reusing
the existing `TOKEN_RE`; `verbs_match()` now compares it first. Mismatch
reported with a dedicated "(differing count of literal %% occurrences: N
vs M)" note. New regression test (case 24 in
`scripts/check-key-drift.test.sh`) reproduces the exact example.

## Verified

- Full existing `check-key-drift.test.sh` suite passes, new case included.
- Ran against the real `locales/es.json`/`i18n-baseline/`: still fails,
  but only on pre-existing, unrelated drift (untranslated voucher keys
  from ut-docs#1832, two orphan `elevation.summary.*` keys) — confirmed no
  `"placeholder token"`/`"%%"` mismatch appears in that output. Not this
  card's scope.
- Independent fresh-context Sonnet review (full detail in the
  `universal-till` record above, which reviewed all three repos' diffs
  together): reverted just this fix, confirmed the new test fails without
  it and passes with it, restored the working tree, confirmed no
  correctness/consistency issues. One cosmetic finding (test case
  mislabelled "case 21", colliding with an existing case 21) fixed before
  commit.

**Verdict: PASS.**

## Branch / PR

`fix/1873-i18n-percent-literal-count-guard`
