# Review — release-notes keys for core ut-docs#3091

Date: 2026-09-28 · Lane: cloud-24

## What shipped
The 8 keys core adds in universal-till#1509 (Settings → About and the
after-update chip): `settings.about.{title,installed_version,first_run,
whats_new,english_only,no_notes}`, `status.release_notes_{updated,dismiss}`.
Inserted without reordering the file; manifest version bumped to 1.1.135.

## Checks
- `scripts/validate.sh` ok.
- `UT_CORE_EN_JSON=<core branch en.json> scripts/check-key-drift.sh`: 0 drift,
  0 orphans, 0 token mismatches (`%s` kept in `status.release_notes_updated`).
  Against core `main` the 8 keys are orphans until #1509 merges — this PR
  merges right after it.
- Terminology matches the pack's neighbours (Settings card titles, status-bar
  chips). Translations were checked by an independent reviewer (see PR).

## Verdict
Safe to merge after universal-till#1509.
