# Review: translate plugin.view.unavailable (ut-docs#3160)

Date: 2026-10-08 · Lane: lane:cloud-54 · Follow-up to universal-till#1748 (merged; review record `docs/code-reviews/2026-10-08-plugin-view-documents-3160.md` there)

- Core added one `en.json` key, `plugin.view.unavailable`. It is the notice shown when a plugin's view document can't be drawn. This pack adds its translation, so `check-key-drift.sh` and core's `lang-pack-drift` stay green.
- **Independent review** (different model from the author): the reviewer checked the wording against the pack's own terms for the till, for "plugin", for the form of address and for "try again". It asked for formal *usted* ("Inténtelo") and an em dash, to match the pack and its neighbouring key; both are applied.
- **Verified:** `scripts/validate.sh` passes, and `check-key-drift.sh` against core `main` (which now carries the key) reports `ok` with 0 drift and 0 orphans.
- `manifest.json` version is bumped to 1.1.183.
- **Verdict:** safe to merge.
