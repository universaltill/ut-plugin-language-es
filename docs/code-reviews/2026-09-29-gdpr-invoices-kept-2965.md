# 2026-09-29 — GDPR erase: invoices keep the buyer details (ut-docs#2965)

Adds the key core introduces in universaltill/universal-till#1528:
`settings.data.gdpr_invoices_kept` (shown under Settings → Data → Erase a customer
and appended to the erase PIN prompt). Manifest "version": "1.1.143".

- Terminology matches the pack's existing `invoice.customer_vat_no` label and the
  neighbouring `settings.data.gdpr_help` wording. No placeholders.
- The wording says the invoices keep the buyer's details *as issued* because tax law
  requires keeping invoices (it never claims they are cleared later), per the Fable
  review of the core change (record
  `universal-till/docs/code-reviews/2026-09-29-erasure-keeps-invoice-buyer-2965.md`).
- `scripts/validate.sh` and `scripts/check-key-drift.sh` against the core branch's
  en.json: see the PR checks.

Merge after universal-till#1528. Safe to merge.
