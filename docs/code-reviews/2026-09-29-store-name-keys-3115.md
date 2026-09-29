# 2026-09-29 — Shop name card keys (ut-docs#3115)

Adds the six keys core introduces in universaltill/universal-till#1526:
`settings.store_name.{title,help,error_required,error_too_long,error_invalid_chars}`
and `elevation.summary.store_name`. Manifest "version": "1.1.142".

- Terminology matches the core help topic (`web/help/es/display.md` step 9, where one
  exists) and the pack's existing `settings.shop_type.*` / `elevation.summary.*` wording.
- `%s` placeholder kept in the elevation summary (token check passes).
- The strings were reviewed together with the core change (Fable review, record
  `universal-till/docs/code-reviews/2026-09-29-shop-name-settings-3115.md`).
- `scripts/validate.sh` passes. `scripts/check-key-drift.sh` against the core branch's
  en.json reports all core keys translated, 0 drift, 0 token mismatches.

Merge after universal-till#1526. Safe to merge.
