# Review: translate the dine-in/takeaway Off mode keys (ut-docs#3632)

Date: 2026-10-08 · Lane: lane:cloud-41 · Follow-up to universal-till#1753 (merged; review record `docs/code-reviews/2026-10-08-order-type-off-3632.md` there)

- Core added two `en.json` keys for the new Off mode (shops that don't sell food or drink to eat in): `settings.order_type_prompt.mode_off` and `pos.error.order_type_off`. This pack adds their translations, so `check-key-drift.sh` and core's `lang-pack-drift` stay green.
- Independent review (Fable, different model from the author): the colon became the pack's em-dash; vocabulary matches the existing "para llevar" / "en el local" / "Desactivado" keys.
- **Verified:** `scripts/validate.sh` passes, and `check-key-drift.sh` against core `main` (which now carries both keys) reports `ok` with 0 drift and 0 orphans.
- `manifest.json` version bumped to 1.1.184.
- **Verdict:** safe to merge.
