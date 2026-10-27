# Review: tracking QR label names the Shop plan (ut-docs#5107)

**Change.** Value-only update of `designer.receipt.show_tracking_qr`:
"(planes de pago)" → "(plan Shop o superior)". Local Plus is now a paid plan but order tracking
starts at Shop (universal-till `CapOrderTracking: PlanShop`), so the old
label promised the QR to Local Plus shops. Same key, no placeholders; core
changes its en/tr/fa/ar values in universal-till PR for #5107. Version
bumped to 1.1.262.

**Review.** Independent different-model reviewer: no findings — wording
matches the pack's existing plan-tier terminology, plan name kept in
English like every `subscription.plan.*` value.

**Verified.** `scripts/validate.sh` ok; `scripts/check-key-drift.sh`
against core `main`: 0 drift, 0 untranslated-present.
