# 2026-09-19 — `selforder.table_busy` es copy correction

Card: [ut-docs#2436](https://github.com/universaltill/ut-docs/issues/2436)
Branch: `fix/2436-table-busy-copy`

## What shipped

Corrected `selforder.table_busy.hint`/`.title` in `locales/es.json` to
match core's fixed en/ar/fa/tr meaning (per the ut-docs#2261 review's
finding F2): someone else at the **same table** ordering from **their own
phone**, not the old cross-table/single-device claim this pack still
carried. Bumped `manifest.json` 1.1.92 → 1.1.93 (this repo's own
shipped-file convention).

## Why the drift happened

The B2 fix that corrected core's copy touched only core's own
`web/locales/{en,ar,fa,tr}.json` — `de`/`es` are external packs, out of
scope for that commit. `check-key-drift.sh` is key-parity only (an
existing key's stale *value* is invisible to it), so nothing signaled the
drift; a Spanish guest would have kept seeing the factually wrong text
indefinitely.

## Verification

- `scripts/validate.sh` — clean (`ok com.universaltill.language-es
  v1.1.93 (es)`).
- `scripts/check-key-drift.sh` — no new drift from this change (the 8
  unrelated voucher keys it reports are pre-existing drift from a separate,
  already-merged card, tracked separately as ut-docs#2441).
- Independent review (fresh-context subagent, different from the
  implementing context, per this card's `complexity:easy` routing):
  translation accuracy against the corrected `en.json` meaning, register/
  word-choice consistency against neighboring `selforder.*` keys (usted-
  imperative forms, "móvil" for the customer's own phone — matches
  `selforder.confirm.qr_caption`'s existing usage), JSON validity, and
  scope (diff touches only the two key values + version bump). Verdict:
  LGTM, no issues found.
- Neither changed key appears in `i18n-baseline/es.untranslated.txt` or
  `es.same-as-en.txt`, so no baseline update was needed.
