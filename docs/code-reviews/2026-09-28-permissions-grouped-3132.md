# Review: Permissions page keys (ut-docs#3132)

**Date:** 2026-09-28 · Built by Opus 5.5 · Reviewed by Fable (independent)

Adds the 33 keys core added in universaltill/universal-till#1504: the Permissions page's group headings, a one-line description of each action, and the "Unlocks: %s" line with its separator. The manifest version is bumped so the pack ships.

The review found no blockers. It flagged terms that didn't match the rest of the pack, and all of them are fixed. Spanish: "PIN del responsable" and "tickets" (the pack's existing terms), and "la Trastienda" for back office. Keys that are the same as English on purpose are added to the `same-as-en` allowlist, including the `", "` separator. `validate.sh`, `check-key-drift.sh` (0 drift) and `check-key-drift.test.sh` pass. Core review record: universal-till `docs/code-reviews/2026-09-28-permissions-grouped-3132.md`.
