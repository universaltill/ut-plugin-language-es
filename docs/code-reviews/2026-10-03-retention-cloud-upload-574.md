# Review — report retention cloud upload keys (ut-docs#574)

- **Date:** 2026-10-03 · **Lane:** lane:cloud-54 · **Version:** 1.1.169
- **Change:** adds the 8 new core keys from universal-till#1664:
  - `settings.retention.{err_invalid_mode, err_needs_subscription, err_use_retention_card, mode_needs_subscription, pending_uploads, upload_refused}`
  - `status.report_archive.{hint, refused}`

  It also drops the removed `settings.retention.mode_coming_soon`, and bumps the version.
- **Review:** an independent check by a different model (Sonnet; the translations were written by Opus). It found all 8 keys correct in meaning, formal register, terminology consistency and `%d` preservation, and that the German help text quotes the de strings. No corrections.
- **Checks:** `scripts/check-key-drift.sh` against the PR's core `en.json` passes (3080/3080, 0 drift, 0 orphans, 0 token mismatches). `scripts/validate.sh` passes.
- **Runtime:** the Tester's driven run of #1664 loaded the de overlay and rendered these strings on the Retention card and the status chip.
- **Order:** merge after universal-till#1664 (brand-new keys; reviewer step 4).
- **Verdict:** safe to merge.
