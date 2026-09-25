# Review: reports date-range chip keys + two catch-up keys (ut-docs#1976)

Date: 2026-09-25 · Lane: `lane:cloud-24`
Author: Opus 5.5 (pipeline) · Independent reviewer: Fable

## What shipped
- Translations for universal-till's new `/reports` chip row
  (universal-till PR #1351): `reports.preset.{label,today,yesterday,this_week,this_month}`
  and `reports.period.rolling`.
- Two keys this pack had fallen behind on since ut-docs#2614:
  `designer.hidden.unhide_all`, `elevation.summary.buttons_unhide_all`.
- `manifest.json` version bumped so the change ships.

## Review
Reviewer checked terminology against neighbouring keys ("sell screen",
the existing Custom/`reports.period.custom` wording, `backoffice.week`),
`%d` placeholders and key placement: approved. One optional de nit
(button verb "einblenden" to match `designer.hidden.unhide` "Einblenden")
was applied.

## Verified
`UT_CORE_EN_JSON=<core branch en.json> scripts/check-key-drift.sh` → 0 drift,
0 orphans, 0 untranslated-present; `scripts/validate.sh` ok. Merged after
the core PR so the new keys aren't orphans against core `main`.
