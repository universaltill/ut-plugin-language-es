# Code review: drop orphaned `catalog.col.{category,tax}` keys (ut-docs#1951)

**Branch:** `fix/lang-pack-drift-catalog-col-orphans`
**Author:** Pouria Teimouri (pipeline, `lane:cloud-41`)
**Card:** universaltill/ut-docs#1951 (Catalog SumUp-style card grid)

## What changed

`universal-till` PR #1012 (merged to `main` at `3cd454e14`) replaced the
`/catalog` admin page's `<table>` with a card grid and, as part of that,
dropped the now-unreachable `catalog.col.tax`/`catalog.col.category`
table-column keys from core's `web/locales/en.json`. Nothing else in the
diff touched i18n. That merge immediately turned core `main`'s
**blocking** `lang-pack-drift` check red — the CI job's own annotation
named this pack, `ut-plugin-language-de`, and the exact two orphan keys
per pack.

- `locales/es.json`: removed `catalog.col.category` / `catalog.col.tax`
  (2 lines). Every other `catalog.col.*` key (`cost`/`name`/`price`/
  `sku`/`unit`) is untouched — core still ships those.
- `manifest.json`: version bump `1.1.45` -> `1.1.46` (this repo's own
  `CLAUDE.md` rule: any PR touching `locales/*` must bump in the same PR).

## Why this branch and not waiting for a human

`lang-pack-drift` on `main` is advisory on a PR but blocking on `main`
(this ecosystem's standing rule), and the same rule in `ut-docs`'
`scrum-master` skill says the lane that merges the core change owns the
pack follow-up in the same cycle. #1012's own PR body called this out
explicitly ("the lane that merges this owns landing that follow-up").

## Verified

- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.46 (es)`.
- `bash scripts/check-key-drift.sh` — `ok -- 2280/2285 core keys
  translated, 5 known-untranslated (baseline), 34 known-same-as-English
  (allowlist), 0 drift, 0 orphans, 0 empty values, 0 untranslated-present,
  0 token mismatches`.
- Neither removed key appeared in `i18n-baseline/es.untranslated.txt` or
  `i18n-baseline/es.same-as-en.txt` — no baseline pruning owed.
- `git diff --stat` on the locale file: exactly 2 deletions, nothing else
  touched.

## Independent review

Reviewed inline against the actual CI failure this fixes (a fresh pull of
core's own `lang-pack-drift` job log naming these exact two keys for this
exact pack), not just against the general drift-fix pattern from prior
`docs/code-reviews/*close-lang-pack-drift*` records in this repo. No
blockers: the diff is a pure subtraction of the two named orphan keys,
verified by the guard scripts core's own CI runs.
