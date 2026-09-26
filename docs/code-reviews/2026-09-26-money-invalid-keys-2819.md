# Review: money-input invalid-value keys (ut-docs#2819)

- **Date**: 2026-09-26
- **Change**: translates the two keys core added in universal-till#1418:
  `common.money.invalid` and `common.money.invalid_whole`. Bumps
  `manifest.json` to 1.1.123. `main` had already taken 1.1.122, the
  version this branch was cut with, so the release needs a new number.
- **Reviewer**: the pipeline (lane:cloud-54), checked against core's
  `web/locales/en.json`.

## Checked

- Meaning matches the English: digits, with a dot or a comma before the
  decimals, and the whole-number variant. The example uses the local
  decimal comma first (`3,50`), which is correct for Spanish.
- `scripts/validate.sh` and `scripts/check-key-drift.sh` (against core
  `main`, which now carries both keys) pass. No baseline entry is needed.

## Verdict

Safe to merge. This PR follows the core merge, as `lang-pack-drift`
requires.
