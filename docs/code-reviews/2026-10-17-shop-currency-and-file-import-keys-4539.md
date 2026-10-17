# Review — es: shop-currency chip keys + importer-plugin keys (ut-docs#4539)

- **Date:** 2026-10-17 · **Lane:** lane:cloud-54 · **Translated by:** Opus 5.5 · **Reviewed by:** Sonnet 5.5 (independent subagent)
- **Scope:** 6 new core keys in `locales/es.json`, `manifest.json` → `1.1.243`.
  - `status.shop_currency_mismatch.label` / `.hint`: the main till's status chip when its currency differs from the shop's on my. (universal-till#2019, ut-docs#4539).
  - `import.file_plugin.detected` / `too_large` / `upload_again` / `use_standard`: added to core by universal-till#2017 (ut-docs#4526) with no pack PR open yet; carried here so this pack (and core's `lang-pack-drift` on `main`) are green.

## Verified
- `scripts/validate.sh` ok; `scripts/check-key-drift.sh` ok against core `main`'s `en.json` (no new drift, no stale baseline entries).
- Reviewer checked placeholders (`%[1]s`, `%[2]s`, `%s`) intact and ordered, `my.` untouched, nothing dropped (32 MB limit, nothing saved until Import, selling carries on), `max_length` limits (label ≤ 40, button ≤ 60), and the pack's existing terms (Settings, Preview, Import).

## Findings
| # | Finding | Outcome |
|---|---|---|
| 1 | de: label said "Shop", hint "Ihr Geschäft"; the pack uses "Shop" for shop data | Fixed in de: "Ihr Shop" |
| 2 | pt: `use_standard` "Usar antes o importador padrão" could be more neutral | Kept: acceptable pt-PT, optional |

**Verdict:** safe to merge.
