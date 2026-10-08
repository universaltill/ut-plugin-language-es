# Code review — "Update now" keys (ut-docs#2945)

- **Date:** 2026-10-08
- **Lane:** `lane:cloud-54`

## What shipped

- Translations of the 5 new core keys from universaltill/universal-till#1761:
  - `tills.update.manual`
  - `tills.update_now.btn`
  - `tills.update_now.confirm`
  - `tills.update_now.dev_build`
  - `tills.update_now.not_linked`
- A manifest version bump.

## Review

- An independent Sonnet review checked each string against the English, the `%s` order, and the file's existing `tills.*` terminology and register.
- Findings, all fixed before commit:
  - de: `manual` was ungrammatical. "this till" was used where the English means "that till".
  - pt: "ligada à corrente" (plugged in) was wrong for "switched on". The subject of the confirm text was unclear.
  - es: no findings.

## Verified

- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` passes against the PR's `en.json`: 0 drift, 0 token mismatches.
- `scripts/check-version-bump.sh` passes.

## Verdict

Safe to merge after universal-till#1761.
