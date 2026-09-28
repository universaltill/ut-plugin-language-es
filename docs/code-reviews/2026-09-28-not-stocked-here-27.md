# Review: inventory.not_stocked_here key (ut-docs#27)

**Date:** 2026-09-28 · Built by Opus 5.5 · Reviewed by Fable (independent review of the core change)

Adds the key core added in universaltill/universal-till#1518. The key is the "not stocked here" hint on a location's reorder list, shown for an item that is stocked only at other locations. The manifest version is bumped so the pack ships.

Review: the meaning matches the English and the neighbouring inventory terms. The JSON is valid, and `validate.sh` and `check-key-drift.sh` (against core's en.json with the key) pass with 0 drift and 0 orphans. Core review record: universal-till `docs/code-reviews/2026-09-28-low-stock-not-stocked-here-27.md`.
