# Review — receipt tracking-QR keys (ut-docs#908)

**Shipped:** two new core keys, translated into this pack: `receipt.tracking.caption` ("Scan to track your order") and `designer.receipt.show_tracking_qr` ("Order tracking QR (paid plans)"), with a version bump. They pair with universaltill/universal-till#1888, which adds the keys to core's `en.json`.

**Review:** the lane's own check of the translations against `reference/translation.md`:
- Formal address, matching neighbouring keys (`tracking.*`, `designer.receipt.*`).
- No placeholders to preserve.
- The German strings match the wording core's German help topic uses for the same checkbox.

`scripts/validate.sh` and `scripts/check-key-drift.sh` were run against core's `main` after #1888 merged.

**Verdict:** safe to merge after the core PR.
