# Review: translate-mode keys (ut-docs#4370)

**Date:** 2026-10-16 · **Author model:** Opus 5.5 (the cycle's own model; no Ollama/LM Studio draft)

## What ships

- 30 `translations.mode.*` keys in `locales/es.json` (Spanish (es)), inserted in core's key order. Core adds them in universaltill/universal-till#2016 (translate mode: point at any text, see its key, open it in Weblate).
- `manifest.json` version bump to 1.1.241.

## Verification

- `scripts/check-key-drift.sh` with `UT_CORE_EN_JSON` = core branch `feat/4370-translate-mode` (`c597962`): ok, 3501/3501 keys, 0 drift, 0 orphans, 0 token mismatches.
- `scripts/validate.sh`, `check-key-drift.test.sh`, `check-version-bump.test.sh`, `check-version-bump.sh`: ok.
- Every value checked against the `max_length` in core's `web/i18n-meta/en.meta.json`; none over. No placeholders in these keys; "Weblate" and "Alt" kept as is.

## Notes

Formal *usted*, caja/tienda, "complemento" for plugin and "integrado" for built-in, matching `translations.source_plugin` and `translations.intro`; kiosk = "quiosco de autoservicio" (the majority form in this pack).

Merge order: core#2016 first. Against core `main` before that merge, these 30 keys are orphans and the pack's drift guard fails, by design (#1576).
