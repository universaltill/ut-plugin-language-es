# Review: Settings category keys (ut-docs#3090)

**Date:** 2026-09-28 · Built by Opus 5.5 · Reviewed by Fable (independent)

Adds the 11 keys core added in universaltill/universal-till#1513: the Settings landing grid's nine category tiles (label + one-line description), the grid's accessible name, and "Back to categories". Bumps the manifest version so the pack ships.

Review found the rename to `settings.home.back`, and asked for this pack's own terms for the sections the tiles open. Spanish: "fichas" for menu tiles, "Copias de seguridad", and the formal/impersonal register this pack uses. All fixed. `validate.sh` and `check-key-drift.sh` pass (0 drift). Core review record: universal-till `docs/code-reviews/2026-09-28-settings-categories-3090.md`.
