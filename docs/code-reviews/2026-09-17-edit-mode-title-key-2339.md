# 2026-09-17 — `buttons.edit_mode.title` follow-up for ut-docs#2339 (core universal-till#1217)

## What shipped

One core key added by the jiggle edit mode (universal-till#1217, merged by
`lane:cloud-54` without its pack follow-up — `lang-pack-drift` was red
on `main` from `284ebac9` onward): `buttons.edit_mode.title`, the
heading shown while the cashier reorders the quick-button grid. Translated
by the local lane with the cycle's own model per ut-docs#2291 (no Ollama),
reusing the pack's existing terms (`designer.title`,
`designer.long_press_hint`). `manifest.json` bumped to `1.1.74`.

## Independent review

Fresh-context Sonnet (easy change): PASS on wording, terminology and
formality; valid JSON, sorted slot; `check-key-drift.sh` 2456/2456, 0
drift; `validate.sh` ok. Verdict: safe to merge.

## Verified

`bash scripts/check-key-drift.sh` and `bash scripts/validate.sh` green
locally against core `main` `10164873`.
