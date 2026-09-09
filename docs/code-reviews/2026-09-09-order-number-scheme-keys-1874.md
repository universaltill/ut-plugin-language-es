# Code review: order-number scheme keys (ut-docs#1874)

- **Card:** universaltill/ut-docs#1874 — follow-up from `universal-till#943`
  (ut-docs#1817, merged 2026-09-09), which added 7 keys to core's
  `web/locales/en.json` and left `lang-pack-drift` red on `main` for both
  external language packs as a known, tracked follow-up.
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context Sonnet subagent, given both this
  repo's and `ut-plugin-language-de`'s diffs together (same 7 keys, two
  languages) — checked translation correctness/register, `%s` placeholder
  parity, JSON validity, baseline-file scoping, and version bump.

## What shipped

7 new keys in `locales/es.json`:

```
elevation.summary.order_no_scheme          -> Establecer el esquema de numeración de pedidos en %s.
orders.col.order_no                        -> N.º de pedido
settings.order_no.help                     -> El número corto que se muestra a los clientes y
                                               se imprime en los tickets de cocina — independiente
                                               del número de recibo, que permanece fijo para
                                               reembolsos e informes.
settings.order_no.scheme                   -> Numeración
settings.order_no.scheme_lifetime_no_reset -> Continua, nunca se reinicia
settings.order_no.scheme_trading_period_reset -> Se reinicia tras cada cierre (por defecto)
settings.order_no.title                    -> Números de pedido
```

Matching `i18n-baseline/es.untranslated.txt` pruning (all 7 lines removed,
leaving the file empty — this pack now has full key parity with core; a
translated-but-still-listed baseline entry is stale and fails
`check-key-drift.sh`, per this repo's own `CLAUDE.md`), and a patch version
bump (`1.1.27` → `1.1.28`).

Register matches this file's existing conventions: infinitive-instruction
style for the `elevation.summary.*` line (matches
`elevation.summary.display_mode`'s "Establecer ... en %s."), short
abbreviation for the column header (`orders.col.order_no` "N.º de pedido",
consistent with this file's other `col.*` short labels), and the same
em-dash clause structure `settings.language.help` already uses for a
similar two-part explanatory sentence.

## Verified

- `scripts/validate.sh` — `ok com.universaltill.language-es v1.1.28 (es)`.
- `scripts/check-key-drift.sh` — `ok -- 2169/2169 core keys translated, 0
  known-untranslated (baseline), 32 known-same-as-English (allowlist), 0
  drift, 0 orphans, 0 empty values, 0 untranslated-present, 0 token
  mismatches`.
- `scripts/check-key-drift.test.sh` — all self-tests pass.

## Review findings

One cosmetic nit, not fixed: `elevation.summary.order_no_scheme` was
inserted after `backup_now` rather than later in the `elevation.summary.*`
block, where it alphabetically belongs. JSON key order has no runtime
effect and nothing else in the diff is affected — left as-is rather than
reopening the diff for a purely cosmetic reorder.

No correctness, translation-quality, or guard-compliance issues found.
