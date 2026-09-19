# 2026-09-19 — 8 new voucher keys, es translation catch-up

Card: [ut-docs#2441](https://github.com/universaltill/ut-docs/issues/2441)
Branch: `fix/2441-voucher-keys-es`

## What shipped

Translated the 8 keys `universal-till#1299` (single-purpose voucher
support) added to core's `en.json` but this pack hadn't caught up on:
`tender.issue_voucher.purpose`/`.purpose_multi`/`.purpose_single`/
`.vat_rate`, `tender.redeem_voucher`, `tender.status.voucher_vat_rate_invalid`,
`pos.toast.voucher_single_purpose_tender`, `pos.toast.voucher_redeemed_single`.
Bumped `manifest.json` 1.1.92 → 1.1.93.

## Why the drift happened

These are brand-new keys with no prior pack-side translation to drift
from — `check-key-drift.sh`'s parity check is correctly red until a
follow-up PR lands them, per `universal-till/CLAUDE.md`'s i18n section
("the pack side cannot land first").

## Verification

- `scripts/validate.sh` — clean (`ok com.universaltill.language-es
  v1.1.93 (es)`).
- `scripts/check-key-drift.sh` — `0 drift, 0 orphans` (was 8 missing keys
  before this change).
- Independent review (fresh-context subagent, per this card's
  `complexity:easy` routing): confirmed the two full-sentence toasts
  (`voucher_single_purpose_tender`, `voucher_redeemed_single`) correctly
  reference the already-translated labels they name (`tender.voucher_check`
  → «Comprobar saldo», the new `tender.redeem_voucher` → «Canjear»,
  `tender.tab.split` → «Dividir»); terminology reuse against existing
  keys (`vat_rate` → "Tipo impositivo", matching `countrysettings.col.tax`;
  redeem verb consistent with existing "canjear"); `%s` placeholder
  preserved; alphabetical key placement; scope. The review's first pass
  caught an in-progress git conflict-marker artifact from local branch
  surgery (mid-resolution when the review agent read the files) — resolved
  before this commit; the translation content itself was approved as-is.
