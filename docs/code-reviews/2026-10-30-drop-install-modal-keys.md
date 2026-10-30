# Review — drop the dead install-modal keys (ut-docs#5213)

**Date:** 2026-10-30 · **Branch:** `fix/5213-drop-install-modal-keys` · **Card:** universaltill/ut-docs#5213

## What shipped

`locales/es.json` loses the 12 `plugins.install.modal.*` keys and
`plugins.install.error.network`, the same keys core universal-till removed in
universal-till#2243. An orphan key (one core no longer has) fails
`check-key-drift.sh`, so this PR follows the core merge. `manifest.json` is
bumped to `1.1.273` so the change ships (ut-docs#1940).

## Review

The keys were removed by line deletion only, and the file still parses as JSON
with every value a string. No `i18n-baseline/` file named these keys, so neither
baseline changes. The diff touches only the 13 lines and the version. This is a
mechanical change, reviewed by the orchestrator (Opus 5.5) and not by its author
model. No findings.
