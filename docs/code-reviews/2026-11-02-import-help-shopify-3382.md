# Review: import.help names Shopify (ut-docs#3382)

**Date:** 2026-11-02 · **Lane:** lane:cloud-41 · **Author model:** Opus 5.5 · **Reviewer:** Sonnet 5.5 (fresh subagent, different model)

## What shipped
- `locales/es.json` `import.help`: the list of automatically recognised
  exports now reads "Loyverse, Square, SumUp y Shopify", matching core's
  `web/locales/en.json` (and core's tr/fa/ar), which added Shopify in
  universal-till#1583 (ut-docs#3284). Nothing else in the string changed.
- `manifest.json` version 1.1.273 → 1.1.274 (shipped-file change, ut-docs#1940).

## Findings
- None blocking or major. Grammar checked as natural for the locale.
- Nit (accepted, out of scope): pre-existing wording elsewhere in the string.

## Verified
- `scripts/validate.sh` passes; `scripts/check-key-drift.test.sh` passes.
- `scripts/check-key-drift.sh` against core `main` (ab7301f) fails with
  17 **pre-existing** missing keys (agent.*, catalog.missing.*,
  settings.staff_links.*), byte-identical output on unmodified `main` —
  this change adds no drift. Those keys are covered by other lanes' open
  pack PRs (ut-docs#4128, #4129).
- No other file in the pack carries the stale sentence.

**Verdict:** safe to merge.
