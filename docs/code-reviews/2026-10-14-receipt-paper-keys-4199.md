# Review: receipt.paper.* keys (ut-docs#4199)

**Date:** 2026-10-14 · **Lane:** lane:cloud-41

Core (universal-till#1928) moved the printed sale receipt's labels to the shop's locale and added 20 `receipt.paper.*` printf keys. This pack translates all 20 and bumps the version.

- **Format verbs:** 15 keys carry exactly one `%s`. `refund`, `total`, `mixed`, `line_dine_in` and `line_takeaway` carry none. This matches core.
- **Terminology:** the wording reuses this pack's existing `basket.order_type.*`, `receipt.fiscal.tse.*`, `invoice.vat_no` and `refund.title` terms.
- **Encoding:** every value encodes in cp858, the code page a EUR/GBP shop in this language prints in.
- **Guards:** `scripts/check-key-drift.sh` (run with `UT_CORE_EN_JSON` pointing at the core branch) and `scripts/validate.sh` both pass.
- **Allowlist (es/pt only):** `receipt.paper.total` = "TOTAL" is identical to English, so it is added to `same-as-en`.

The independent review of the change is in core's record, `docs/code-reviews/2026-10-14-printed-receipt-labels-locale-4199.md`.

Verdict: safe to merge once core has merged.
