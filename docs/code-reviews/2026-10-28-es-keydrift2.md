# Review: language-es key-drift catch-up, second pass (part of ut-docs#5098)

**Date:** 2026-10-28.

## What

Brought `locales/es.json` back to parity with core's base locale (universal-till
main at fc3ae5e2e), and bumped `manifest.json` 1.1.262 -> 1.1.263 (the only file that pins the version).

- Keys added: 2, exactly the set `scripts/check-key-drift.sh` reported:
  `setup.cloud.syncing_title`, `setup.cloud.syncing_body`, placed after `setup.cloud.syncing` as in core's key order.
- Keys dropped (orphans): none.

## Checks run

- No placeholders in the two English strings; none introduced.
- Terminology reused from neighbouring keys (till, shop, sale screen).
- `scripts/check-key-drift.sh`: ok, all core keys translated, 0 drift, 0 orphans, 0 empty values, 0 token mismatches. `scripts/validate.sh` ok.
- Diff limited to `locales/es.json`, `manifest.json` and this record.

## Note

Model-written translation, worth a native read.

## Verdict

Safe to merge.
