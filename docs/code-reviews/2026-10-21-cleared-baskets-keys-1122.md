# Review — Z-report cleared-baskets keys (ut-docs#1122)

**Date:** 2026-10-21 · **Lane:** lane:cloud-41 · **Version:** 1.1.249

## What shipped

Two keys that core universal-till#2073 adds:
- `reports.zpaper.cleared_title`, the heading of the Z-report section for baskets cleared with New sale before payment;
- `reports.zpaper.cleared_baskets`, a row label in a 20-character column.

The es values are: CESTAS VACIADAS SIN COBRAR / Vaciadas (%d).

## Review

Fable 5.1 reviewed it independently. It checked:
- the length limits (heading ≤42, row ≤20 with a 2-digit count);
- exactly one `%d` in the row label;
- consistency with the pack's `basket.title`, `tender.title` and `reports.zpaper.voided` vocabulary;
- for de, a byte match with the core help heading in `web/help/de/reports.md`.

`scripts/validate.sh` passes. The manifest has one patch bump. No findings. Safe to merge after the core PR.
