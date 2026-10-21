# Review — setup cloud pairing keys (ut-docs#4610)

**Date:** 2026-10-21 · **Version:** 1.1.250

## What shipped

21 keys that core universal-till#2083 adds: `setup.join.role_main`, `setup.join.main_help` and all `setup.cloud.*` keys (pairing code help, shop details step, error messages).

Register: neutral usted. Vocabulary matches the pack's existing `settings.tills.role_main`, `tills.role.replica`, `tills.role.satellite` and `setup.join.help`. Both `%s` in `setup.cloud.error.store_has_till` are kept in order.

## Checks

`scripts/validate.sh` and `scripts/check-key-drift.sh` (against the #2083 en.json) pass with 0 drift and 0 token mismatches. One patch bump in the manifest. Safe to merge after the core PR.
