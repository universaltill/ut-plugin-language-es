# Review: AI permission consent descriptions (ut-docs#2837)

- **Date**: 2026-10-12 · **Author**: Opus 5.5 · **Reviewer**: Fable (independent)
- **Change**: the ten `plugins.permissions.desc.ai_*` keys added to core
  `en.json` by universal-till's ut-docs#2837 change (ADR-0153), translated;
  manifest version bumped as this repo's CLAUDE.md requires for a locale change.
- **Findings**: none for this pack. The reviewer checked that meaning matches
  English, there are no placeholders, the sentence style matches neighbouring
  `desc.*` lines, and terms are consistent with this locale's UI (audit trail term).
- **Verified**: `validate.sh` and `check-key-drift.sh` against the core
  branch's `en.json` show no drift and no orphans.
- **Verdict**: safe to merge right after the core PR merges (new keys: core first).
