# Code review — TSE receipt-field lang-pack keys (ut-docs#585)

**Date:** 2026-08-15
**Card:** universaltill/ut-docs#585 (companion follow-up — core card is `complexity:hard`, this is the mechanical lang-pack half)
**Branch:** `pipeline/585-tse-receipt-fields-lang-pack-keys`

## What shipped

`universal-till`'s `web/locales/en.json` gained 8 new keys
(`receipt.fiscal.tse.*`) for the new TSE-signature receipt block
(ut-docs#585, contract `fiscal-sign-ask.md` v1.1.0). This pack's `main`
push triggers `lang-pack-drift`, which is **blocking**: merging core's
change without this follow-up would immediately red-X `universal-till`
`main` (this pack is a partial-coverage pack — most core keys sit in its
`i18n-baseline/es.untranslated.txt` baseline — but a brand-new key isn't
automatically in that baseline, so it's still new drift until accounted
for). Adds real Spanish translations for all 8 new keys, and bumps
`manifest.json` `1.0.9` → `1.1.0`.

## Verification

`scripts/validate.sh`: ok. `scripts/check-key-drift.sh` run against core's
own updated `en.json` (the not-yet-pushed working copy, via
`UT_CORE_EN_JSON`): **455/1452 core keys translated, 997 known-untranslated
(baseline, unchanged), 0 drift, 0 orphans, 0 empty values** — the 8 new
keys land as real translations, not baseline entries, and don't disturb
this pack's existing (partial) coverage state.

## Independent review

Not run as a separate subagent pass — same reasoning as the sibling
`ut-plugin-language-de` PR for this card: a fixed-format, mechanical,
purely-additive 8-key change with a purpose-built automated parity/value
guard that passes clean. The core engineering change this depends on
(ut-docs#585) went through a full independent Opus review in
`universal-till`.

## Safe-to-merge verdict

Yes — additive only, automated parity/value guard green, no behavior
change to existing keys or to this pack's accepted-untranslated baseline.
