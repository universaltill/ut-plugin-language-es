# Review: photo cutout keys (ut-docs#3127)

- **What:** the 13 `catalog.image.*` keys core adds for the "Remove background"
  offer in the item, category and variant photo pickers
  (universaltill/universal-till#1855), translated into es; `catalog.image.original`
  is spelled as in English and added to `i18n-baseline/es.same-as-en.txt`;
  version 1.1.202.
- **Author:** Opus 5.5 (Dev subagent). **Reviewer:** Fable (independent subagent)
  checked key presence and values in all three packs against core's en.json;
  the orchestrator spot-read the translations.
- **Verified:** `scripts/validate.sh`; `scripts/check-key-drift.sh` against the
  core branch's en.json (0 drift); `scripts/check-key-drift.test.sh`. Rendered in
  the core e2e screenshots (German at 1024×600 and 360 px: wraps cleanly).
- **Order:** merges right after the core PR (a brand-new key — core first, then
  the packs in the same cycle).
- **Verdict:** safe to merge.
