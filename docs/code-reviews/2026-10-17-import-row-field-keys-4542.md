# Review — 5 import row-field keys (es), ut-docs#4542

This change translates the 5 `en.json` keys that universal-till#2032 added:
- `import.issue.description_invalid`
- `import.issue.net_quantity_invalid`
- `import.system.change.description`
- `import.system.change.age_restricted`
- `import.system.change.net_quantity`

It also bumps `manifest.json`'s patch version.

**Reviewer:** Sonnet 5.5 (independent pass; the author model was Opus 5.5).
- Wording is accurate and consistent with the neighbouring terms
  (`catalog.net_quantity`, `catalog.age_restricted`, the other
  `import.system.change.*` labels and their casing).
- Nit, accepted: the new `import.issue.*` keys sit after
  `vat_out_of_range` instead of in alphabetical order. Key order is not
  checked, and the neighbouring blocks are appended the same way.

**Verified:**
- `scripts/validate.sh`
- `scripts/check-key-drift.sh` against core's merged `en.json`: 0 drift,
  0 untranslated-present

**Verdict:** safe to merge.
