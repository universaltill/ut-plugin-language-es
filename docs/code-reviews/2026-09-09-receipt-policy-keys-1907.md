# Code review: receipt-policy keys (ut-docs#1907 pack follow-up)

- **Card:** universaltill/ut-docs#1907 — `universal-till` PR #980 (merged)
  added 8 keys to core's `web/locales/en.json` for the new three-way
  receipt-policy setting (ADR-0089) and removed the now-orphaned
  `settings.printer.auto`, landing `lang-pack-drift` red on `main`
  (blocking, per this repo's own `CLAUDE.md`) as a tracked follow-up —
  this pipeline's own standing rule is that the lane that merges the core
  change owns the pack follow-up in the same cycle.
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** fresh-context Sonnet subagent, given both this repo's and
  `ut-plugin-language-de`'s diffs together.

## What shipped

8 new keys in `locales/es.json`:

```
receipt.ask.none                              -> Sin recibo
receipt.ask.paper                             -> Imprimir recibo
receipt.ask.title                             -> ¿Desea un recibo?
settings.printer.receipt_policy.always        -> Imprimir siempre
settings.printer.receipt_policy.ask           -> Preguntar al cliente
settings.printer.receipt_policy.locked_de     -> Fijado en «Imprimir siempre» por ahora
                                                  para tiendas en Alemania: la caja
                                                  imprime un recibo en cada venta
                                                  mientras se confirman las normas de
                                                  recibos para tiendas alemanas.
settings.printer.receipt_policy.never         -> No imprimir automáticamente
settings.printer.receipt_policy.title         -> Recibo tras cada venta
```

Plus removal of the orphaned `settings.printer.auto` key (core no longer
has it) and a patch version bump (`1.1.28` → `1.1.29`).

Register matches this file's existing conventions: formal **usted**
throughout, infinitive/imperative style for option labels, correct
inverted `¿` and Spanish guillemets `«…»` matching neighboring entries.
`locked_de` is a neutral factual statement about current behaviour, not a
compliance-outcome claim (ADR-0040).

**Note:** this follow-up covers only the 8 receipt-policy keys this
lane's own merge introduced. `lang-pack-drift` on `main` remains red for
22 unrelated `categories.*` keys from a different, still-in-flight card
(`lane:cloud-54`, ut-docs#1898) — not this follow-up's to fix, per the
lane-ownership rule (each lane owns only the pack follow-up for its own
merge).

## Verified

- `scripts/validate.sh` — `ok com.universaltill.language-es v1.1.29 (es)`.
- `scripts/check-key-drift.sh` — the 8 receipt-policy keys and the
  `settings.printer.auto` orphan no longer appear in the drift/orphan
  output; only the pre-existing, unrelated 22 `categories.*` keys remain
  (confirmed not introduced by this change).
- `scripts/check-key-drift.test.sh` — all self-tests pass.

No correctness, translation-quality, or guard-compliance issues found.
