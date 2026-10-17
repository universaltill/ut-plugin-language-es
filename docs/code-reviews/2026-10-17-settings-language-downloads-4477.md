# 2026-10-17 — Settings → Language download keys (ut-docs#4477)

Follow-up to universal-till's Settings → Language install-on-select
(ut-docs#4477, ADR-0160 §6). That change adds five core keys:
`settings.language.download_group`, `downloads_on_select`,
`install_unavailable`, `installing` and `switching`. This PR translates
all five into es and bumps the version to 1.1.245.

## Review
- The three chip strings keep their single `%s` placeholder, which is the
  language's own name.
- Wording matches the pack's existing Settings terms: Sprache / Kasse,
  idioma / caja, idioma / caixa.
- `scripts/check-key-drift.sh` passes against core's `en.json` from the
  universal-till branch: 0 drift, 0 orphans, 0 token mismatches.
- `scripts/validate.sh` passes.
- Reviewed together with the core change. Its record is
  universal-till `docs/code-reviews/2026-10-17-settings-language-install-4477.md`.

Safe to merge once the core keys are on universal-till `main`.
