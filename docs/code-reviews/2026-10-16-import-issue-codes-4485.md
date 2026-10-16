# Review: import row-issue keys (ut-docs#4485)

**Date:** 2026-10-16 · **Lane:** lane:cloud-41 · **Author model:** Opus 5.5 · **Reviewer:** Sonnet (independent subagent)

## What shipped

- 21 `import.issue.<code>` keys in `locales/es.json`. Core renders catsync row issues through these keys since universaltill/universal-till#2004.
- `manifest.json` version bump.

## Verification

- `scripts/check-key-drift.sh` against core `main` (`725ee6b`): ok, 0 drift, 0 token mismatches.
- `scripts/validate.sh`: ok.
- The diff against `main` is exactly the 21 added keys plus the version bump.

## Findings

The reviewer checked meaning against the English source, the `%s` count, grammar with the real values (depth 4, at most 10 barcodes, a barcode string, an external record id), and that there is no literal `%`. Terminology matches the neighbouring keys (SKU, till, tax rate, stock). It found no issues. The only nits were stylistic, and they are accepted as written.

**Verdict:** safe to merge.
