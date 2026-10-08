# Review: drop the 15 inventory override/return keys core removed (ut-docs#3631)

Date: 2026-10-08 · Lane: lane:cloud-41 · Reviewed as part of the universal-till #3631 review (`docs/code-reviews/2026-10-08-inventory-every-item-3631.md` there)

- Core removed the "+" button, the manager negative-stock override panel and the "Process a return" panel from the till's Inventory page (ut-docs#3631). With them, 15 `inventory.*` keys left `web/locales/en.json`: `add_stock`, `authorize_override`, `current_qty`, `requested_qty`, `manager_pin`, `manager_pin_placeholder`, `override_title`, `override_reason_placeholder`, `original_receipt`, `process_return`, `return_col_qty`, `return_no_lines`, `return_note`, `return_reason_placeholder`, `return_title`.
- This pack drops the same 15 lines. Otherwise `check-key-drift.sh` would fail them as orphans once core merges.
- No baseline or allowlist entry named any of them.
- Verified: `scripts/validate.sh` passes. `check-key-drift.sh` against the core branch's `en.json` reports `ok` with 0 orphans and 0 drift.
- `manifest.json` version bumped to 1.1.182.
- Verdict: safe to merge once core's change is on `main`.
