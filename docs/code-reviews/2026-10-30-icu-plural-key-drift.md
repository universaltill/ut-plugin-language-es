# Review — key-drift token parity compares ICU messages by argument (ut-docs#5160)

**Date:** 2026-10-30 · **Branch:** `fix/5160-icu-plural-drift` · **Card:** universaltill/ut-docs#5160

## What shipped

`scripts/check-key-drift.sh` now treats a key whose core `en.json` value is an
ICU MessageFormat message the way core `guard-i18n.sh` check 8 does
(ut-docs#4480). It skips the verb regex and compares by argument name and
type, and the value must parse (CLDR categories or `=N`, no duplicate
branch, `other` present). `icu_args`/`icu_mismatch` and helpers are a
verbatim port of core's code, kept in sync by hand per ut-docs#312. Mismatches
are reported under their own "ICU message mismatch" heading. Before this
change, a translation with a different branch set and a digit-only (`two {2}`)
or argument-only (`one {{count}}`) body false-failed. A renamed argument, a
plural turned into a select, a missing `other` branch, or broken braces all
passed silently.

## Tests

The self-test file gains eight cases. Six cover the card's acceptance pair plus
five failures (renamed argument, type change, no `other`, unknown category,
unbalanced braces). Two were added after review: a plain-text translation of
an ICU key fails, and a verb key next to an ICU key is still verb-checked
while the ICU key is not reported. The six original cases were run against the
pre-change script: the acceptance case failed and the five bad values passed.
After the change they pass. The live pack was checked against current core
`en.json`: ok, 0 ICU mismatches.

## Independent review (different model from the author)

- Ported block is byte-identical to core's. The integration matches core's
  "ICU → icu_mismatch, never verbs_match". The de/es/pt diffs differ only in
  locale variable names.
- `--update-baseline`/`--update-allowlist` paths are untouched. The
  `<<'PY'` heredoc is quoted, so the ported code is inert to the shell.
- No version bump: `scripts/check-key-drift*.sh` is not in
  `check-version-bump.sh`'s shipped patterns.
- Findings: minor, no plain-text-translation case (**fixed**). Minor, no
  mixed ICU + verb-key case (**fixed**). Nit, sync with core is by hand
  (accepted; same as the existing ut-docs#312 convention).

**Verdict:** safe to merge.
