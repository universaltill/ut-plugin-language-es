# Code review — "automatic updates are off on the main till" key (ut-docs#4031)

- **Date:** 2026-10-10
- **Lane:** `lane:cloud-54`

## What shipped

- Translation of the new core key from universaltill/universal-till#1835:
  - `settings.update.follows_main_off`
- Manifest version bump to 1.1.196.

## Review

- An independent Sonnet review checked the string against the English, the file's "main till" term (`follows_main`, `follows_main_unknown`) and the formal register.
- es: no findings.

## Verified

- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against the core branch's `en.json` (`UT_CORE_EN_JSON`): 0 drift.

## Verdict

Safe to merge after universal-till#1835.
