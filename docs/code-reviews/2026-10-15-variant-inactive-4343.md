# Review — variant-inactive barcode keys (es, ut-docs#4343)

**What:** the two keys core added in universal-till#1933 —
`catalog.barcode.variant_inactive` (attach refused on a switched-off variant: tick Active, save,
then add the barcode) and `catalog.barcode.variant_inactive_hint` (the short in-row hint) —
translated, plus the manifest version bump so the change ships.

**Checked:** wording reuses this pack's own terms for variant and the Active checkbox
(`catalog.variants`, `catalog.active`); `scripts/validate.sh` and `scripts/check-key-drift.sh`
against live core `main` pass (0 drift, 0 orphans); version bump present. The core change's
independent review is universal-till `docs/code-reviews/2026-10-14-variant-barcode-inactive-4343.md`.

**Verdict:** safe to merge.
