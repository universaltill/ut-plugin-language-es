# Review: `setup.base_plugins.pending` says "looking for", not "installing" (ut-docs#4011)

**Date:** 2026-10-28.

## What

Core changed the value of the existing key `setup.base_plugins.pending` to
"Looking for a free %s language pack — if the plugin catalog has one, the
till installs it in the background." (ut-docs#3194): an offline till queues
a language spec for its country's locale whether or not a pack is
published, so "installing…" was a promise the till can't know it can keep.
`check-lang-pack-drift.sh` compares keys, not values, so this pack still
said "Instalando su paquete de idioma %s gratuito en segundo plano — …".

- `locales/es.json`: value-only change, now "Buscando un paquete de idioma %s gratuito — si el catálogo de plugins tiene uno, la caja lo instala en segundo plano."
- `manifest.json`: 1.1.263 -> 1.1.264.
- No keys added or removed.

## Review (independent, different model from the author)

- Meaning: conditional, no promise of an install. Terminology and register
  match the neighbouring `setup.base_plugins.not_published_tax` key.
- `%s` is filled with `.LocaleUpper` (`internal/pages/setup_base_plugins.go`,
  e.g. "FR"); the sentence reads correctly with an upper-case code.
- Exactly one `%s`, JSON valid, only this line and the version changed.
- No other copy of the old wording in this repo (README, docs).
- Not changed: `setup.base_plugins.pending_tax` still says "installing" in
  core too; tax plugins have their own `not_published_tax` path, so that
  is intentional and outside this card.

## Checks run

- `scripts/validate.sh`: ok.
- `scripts/check-key-drift.sh` (core en.json at universal-till main): ok, all core keys translated, 0 drift, 0 orphans, 0 token mismatches.

## Note

Model-written translation, worth a native read.

## Verdict

Safe to merge.
