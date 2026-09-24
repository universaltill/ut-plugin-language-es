# Review — icon library keys (ut-docs#2506)

Adds the 77 `catalog.builtin_icon.*` keys core's icon library introduced
(universal-till#1347): 68 icon labels, 8 section headings, the search
placeholder and the no-match line. Manifest version bumped.

- Translations reviewed for till context (short labels, "/" pairs kept).
- Keys identical to English on purpose (brand/loan words such as Pizza, Bar)
  added to `i18n-baseline/es.same-as-en.txt` through
  `check-key-drift.sh --update-allowlist`; the diff was reviewed line by line.
- `scripts/validate.sh` and `check-key-drift.sh` (against the core
  branch's en.json) pass: 0 drift, 0 orphans, 0 untranslated-present.

Merge after universal-till#1347 (the keys don't exist on core main before it).
