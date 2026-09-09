# Code review: voucher issue/redeem cashier UI strings (ut-docs#1832)

- **Card:** universaltill/ut-docs#1832 — `universal-till` PR #937 (branch
  `fix/1832-voucher-ui`) adds 19 new keys to core's `web/locales/en.json`
  for the new "Sell a voucher" / redeem-a-voucher cashier UI, landing this
  pack's translation *before* #937 merges to `main` (to avoid the
  `lang-pack-drift` push-to-`main` gate going red the moment it lands, per
  this pipeline's "the lane that merges the core change owns the implied
  pack follow-up" rule).
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** same session, immediately after writing the translations —
  ran the repo's own guards live against a local checkout of core's
  `fix/1832-voucher-ui` branch (which already carries the 19 new keys)
  rather than the published `main` (which doesn't have them yet).

## What shipped

19 new keys in `locales/es.json`, each inserted immediately after its
nearest existing sibling already in the file:

```
receipt.vouchers.issued              -> Vales emitidos
tender.issue_voucher.add             -> Añadir vale
tender.issue_voucher.amount          -> Importe del vale
tender.issue_voucher.auto_code       -> Código generado al finalizar la venta
tender.issue_voucher.code            -> Código
tender.issue_voucher.code_placeholder-> Vacío = se genera al finalizar la venta
tender.issue_voucher.hint            -> El valor del vale se añade a lo que debe el cliente.
tender.issue_voucher.holder_label    -> Para (opcional)
tender.issue_voucher.no_pending      -> Aún no hay vales para vender.
tender.issue_voucher.title           -> Vender un vale
tender.status.voucher_added          -> Vale de %s añadido a esta venta.
tender.status.voucher_balance        -> Saldo del vale: %s.
tender.status.voucher_check_unavailable -> No se pudo comprobar el saldo del vale en este momento — puede añadir el pago igualmente.
tender.status.voucher_id_required    -> Introduzca el código del vale.
tender.status.voucher_removed        -> Vale pendiente eliminado.
tender.voucher_check                 -> Comprobar saldo
tender.voucher_id                    -> Código del vale
tender.voucher_id_placeholder        -> Código de la tarjeta
pos.toast.voucher_code_exists        -> Ese código de vale ya está en uso — compruebe el código de la tarjeta e inténtelo de nuevo
```

Terminology/register matches this file's own established conventions for
the same feature area: "vale" for voucher (already used throughout
`pos.toast.voucher_*`/`sync.quarantine_reason.*_voucher_*`/
`tender.pay_voucher`), the same infinitive/imperative button and
status-line style as sibling `tender.*` keys (`tender.add_payment`
"Añadir pago", `tender.status.removed` "Pago eliminado.",
`tender.status.added` "Pago de %s añadido por %s."), formal **usted**
imperative for the one longer status/toast line (matches
`pos.toast.voucher_overtender`'s existing "introduzca el importe restante
en su lugar" pattern).

`tender.issue_voucher.code` = `"Código"` is NOT byte-identical to core's
English `"Code"` (unlike the German pack, where the loanword is
identical) — confirmed no `i18n-baseline/es.same-as-en.txt` entry is
needed for this or any of the other 18 keys.

`manifest.json` version left unchanged (`v1.1.22`) — release/tag is a
separate, later action, matching `ut-plugin-language-de`'s own
established precedent for a translation-only PR.

## Verified, live, not just read

- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.22 (es)`, exit 0.
- `UT_CORE_EN_JSON=<local universal-till checkout, branch
  fix/1832-voucher-ui> bash scripts/check-key-drift.sh` — 0 new drift, 0
  empty values, 0 untranslated-present, 0 token mismatches on any of the
  19 new keys. The only remaining findings are 6 **pre-existing,
  unrelated** orphan keys (`elevation.summary.allow_negative_inventory_
  {off,on}`, `import.status.stock_not_tracked`,
  `settings.stock_tracking.{hint,label,title}`) — not touched by this
  change, not caused by it (this local core checkout's `en.json` doesn't
  currently carry those keys; `main` has moved independently since).
  Left alone, out of scope for this PR.
- `bash scripts/check-key-drift.test.sh` — all fixture cases pass.
- Placeholder-token parity checked explicitly by the guard for every key
  sharing a `%s` (`tender.status.voucher_added`,
  `tender.status.voucher_balance`) — no dropped/reordered token.
- No real client/shop name, no secret-shaped literal.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`.

## Verdict

**Safe to merge.** Small, mechanical, fully guard-verified against the
exact core branch these keys are landing alongside. Should land before (or
together with) `universal-till` PR #937 merging to `main`, so
`lang-pack-drift` doesn't go red on push.
