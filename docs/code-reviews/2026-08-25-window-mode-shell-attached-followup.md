# i18n follow-up: settings.display.window_mode_shell_attached (ut-docs#1086)

**Date:** 2026-08-25
**Card:** ut-docs#1086 (follow-up from ut-docs#1040)
**Complexity:** easy
**Author (dev):** scrum-master pipeline cycle, inline (Sonnet)
**Reviewer:** independent fresh-context Sonnet subagent

## What shipped

`web/locales/en.json`'s `settings.display.window_mode_shell_attached` key
was extended (universal-till#536) with a sentence explaining desktop-
overlay behavior on a Raspberry Pi with a desktop OS. Updated this pack's
Spanish translation of the same key to carry the new sentence, matching
the file's existing "Pantalla completa"/"quiosco" terminology and quote
conventions.

## What the independent review found

PASS. Translation verified faithful to the English meaning, consistent
terminology, JSON valid, `scripts/validate.sh` and
`scripts/check-key-drift.sh` both clean (0 drift/orphans/empty values;
the 978 known-untranslated baseline entries are pre-existing and
unrelated to this change).

## What was verified beyond automated tests

- `python3 -c "import json; json.load(open('locales/es.json'))"` — valid.
- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.7 (es)`.
- `bash scripts/check-key-drift.sh` — 0 drift, 0 orphans, 0 empty values,
  0 untranslated-present.
