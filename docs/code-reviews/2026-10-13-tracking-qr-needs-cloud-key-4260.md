# Review — `designer.receipt.tracking_qr_needs_cloud` (ut-docs#4260)

**Shipped:** one new core key translated into this pack, "Disponible cuando el seguimiento de pedidos pase a nuestra nube." for core's "Available once order tracking moves to our cloud." — the note beside the receipt designer's now-disabled Order tracking QR box. Pairs with the universal-till PR for ut-docs#4260. Version bumped to 1.1.214.

**Review:** checked against `reference/translation.md`: no placeholders, wording matches the pack's existing "Bestellverfolgung"/"seguimiento del pedido"/"acompanhamento do pedido" terminology for this feature; `scripts/validate.sh` and `scripts/check-key-drift.sh` run against the core branch.

**Verdict:** safe to merge once the core PR is on `main`.
