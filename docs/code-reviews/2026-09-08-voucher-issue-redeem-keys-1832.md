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

## Update: CI red on the first push — unrelated concurrent drift, fixed here

The first CI run (against the live `main`, not this local checkout)
failed `key-drift` with 19 **different** missing keys — not these 19
voucher keys (expected: they're not in `main` yet, this PR predates
#937's merge) but 19 unrelated keys two other concurrent lanes' PRs had
just landed on `main` while this PR was in flight: `elevation.summary.
{keep,remove}_demo_item`, `orders.view.{title,refund_link}`, `pos.toast.
receipt_{not_completed,order_cancelled,read_error}`, and 12
`settings.data.demo_*` keys (ut-docs#1818 scan-to-collect routing,
ut-docs#1840 remove-sample-data).

Rather than leave the whole repo red (blocking every pack PR, not just
this one) or silently baseline them as debt, translated all 19 into
Spanish too — same terminology already established in this file
("artículo de muestra" for sample item, "pedido"/"recibo" for
order/receipt, "Devolución" for refund, "aparcada" for a held/parked
sale matching `hold.*`'s existing usage, formal **usted** imperative
matching `settings.data.demo_confirm`'s existing style) — mirroring the
same fix landed in `ut-plugin-language-de` for the identical drift, per
this pipeline's own precedent for exactly this situation.

Re-verified against the now-current core checkout (branch
`fix/1832-voucher-ui`, merged up to `main`'s `ed8ca82a`):
**2120/2120 core keys translated, 0 drift, 0 orphans, 0 empty values, 0
untranslated-present, 0 token mismatches.** `scripts/validate.sh` and
`scripts/check-key-drift.test.sh` both green again.

## Update: core #937 merged — resynced against the real published main

`universal-till` PR #937 (the voucher UI itself) merged to `main` while
this pack PR was in flight. Merging current `main` into this branch hit
two real conflicts, both in keys **unrelated to vouchers** that another
lane had, in the meantime, independently landed a *properly reviewed*
Spanish translation for on `main` (the same `elevation.summary.{keep,
remove}_demo_item` / `settings.data.demo_*` keys this PR's earlier
commit had translated only as a stopgap to unblock its own CI). Deferred
entirely to `main`'s version in both cases.

Re-running the guard live against the network (this pack's own
`check-key-drift.sh` fetches core's *actual* published `main` when no
`UT_CORE_EN_JSON` override is given) surfaced further churn from other
concurrent lanes' in-flight cards, unrelated to this one:
- **9 new missing keys** (short-order-number settings, backup-restore
  confirmation) — catalogued as known debt via
  `check-key-drift.sh --update-baseline --allow-growth` rather than
  guessed-translated blind.
- **2 stale orphan keys** (`elevation.summary.backup_restore`,
  `elevation.summary.data_customer_erase`) that core no longer has under
  any matching name — removed (the guard fails unconditionally on any
  orphan, no baseline escape is possible for that class of finding).

Final state, verified live against the network: **2124/2133 core keys
translated, 9 known-untranslated (baseline, added here), 32
known-same-as-English (allowlist), 0 drift, 0 orphans, 0 empty values,
0 untranslated-present, 0 token mismatches.** This PR's own 19 voucher
keys are all present, all real translations, all matching core exactly.
`scripts/validate.sh` and `scripts/check-key-drift.test.sh` both green.

## Verdict

**Safe to merge.** Fully guard-verified against the real, live published
`main` (not a local snapshot). universal-till PR #937 has already
merged, so this no longer needs to land "before or together with"
anything; it just needs to land.
