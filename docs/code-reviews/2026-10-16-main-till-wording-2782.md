# Review: Tills card role keys + "main till" wording (es) — ut-docs#2782

Date: 2026-10-16 · lane:cloud-41 · Author: Opus 5.5 · Reviewer: Sonnet (independent, read-only)

## What shipped
Follow-up to universaltill/universal-till#2009 (core), which:
- adds `settings.tills.role_label`, `settings.tills.role_main` and `settings.tills.main_till_addr` (%s);
- relabels `settings.tills.register_label` "Cash register for payouts", with `registers.strand_warning` quoting the new label;
- replaces "primary till" with "main till" in core.

This pack translates the three new keys and the new register label, and makes `strand_warning` quote that label exactly. `register_label` reads "Caja para salidas de efectivo" (cash paid out, not taken in), and `tills.the_primary` now says "la caja principal". The manifest version is bumped.

## Findings
- Low: "Caja para pagos en efectivo" read like cash taken in. Fixed to "Caja para salidas de efectivo", and `strand_warning` was updated to match.
- Low: `tills.the_primary` "la principal" was changed to "la caja principal", to match core's "the main till". Fixed.

## Verified
`scripts/validate.sh` OK. `check-key-drift.sh` against core's branch en.json: 3451/3451, 0 drift, 0 orphans, 0 token mismatches. The %s placeholder is kept.

## Verdict
Safe to merge after core #2009 merges (new keys, #1576).
