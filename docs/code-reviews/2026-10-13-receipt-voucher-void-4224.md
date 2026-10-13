# Review - receipt voucher void notice (ut-docs#4224)

**Shipped:** one new core key translated into this pack: `receipt.vouchers.void` ("VOID - not valid", printed next to a voided gift voucher on the receipt, which then never prints as a scannable barcode), with a version bump. Pairs with the universal-till PR for ut-docs#4224, which adds the key to core's `en.json`.

**Review:** the lane's own check against `reference/translation.md`: Spanish wording "ANULADO - no válido" mirrors the English caps-then-reason shape; no placeholders; consistent with this pack's `receipt.vouchers.issued` term.

**Verdict:** safe to merge after the core PR.
