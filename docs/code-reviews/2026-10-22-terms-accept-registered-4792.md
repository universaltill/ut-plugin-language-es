# Code review — six keys for a registered till's later terms acceptance (ut-docs#4792)

Date: 2026-10-22 · Branch: `i18n/4792-terms-accept-registered` · Core:
universal-till#2107. Translations drafted and reviewed in the same lane
(lane:cloud-41) against the core English and this pack's existing
`settings.enrol.terms.*` wording, so the vocabulary is consistent.

## What shipped

- Six new keys: `elevation.summary.enrol_terms` and
  `settings.enrol.terms.{accept_btn,send_btn,unsent,send_failed,accept_required}`.
- Version bump to 1.1.254.

## Findings

None. No placeholders in the new keys; the terminology matches the existing
terms keys in this pack.

## Verified

`scripts/validate.sh` passes, and `UT_CORE_EN_JSON=<universal-till#2107 en.json> scripts/check-key-drift.sh`
reports 0 drift, 0 untranslated and 0 token mismatches.

## Verdict

Safe to merge after universal-till#2107.
