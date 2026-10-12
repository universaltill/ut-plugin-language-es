# Review: catalog.variants.generate_too_many (es) — ut-docs#4163

Core universal-till#1867 (merged) added one key: the till's variants panel
says how many variants generating would make when it would exceed the
100-per-item cap. This adds its es translation and bumps the manifest
version so the change ships.

- Independent review (Sonnet; the translation was written by Opus 5.5):
  meaning, both `%d` placeholders in order (total, then cap), and
  terminology and register checked against the neighbouring
  `catalog.variants.*` and `catalog.option_sets.*` strings. Verdict: OK.
  The German phrasing was smoothed on the reviewer's suggestion.
- `scripts/validate.sh` and `scripts/check-key-drift.sh` against core
  main's en.json: ok, 0 drift, 0 untranslated.

Safe to merge.
