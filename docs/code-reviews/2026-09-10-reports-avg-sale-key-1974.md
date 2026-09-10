# Code review: `reports.avg_sale` key follow-up (ut-docs#1974)

**Branch:** `main` (direct small content-only fix, see note below)
**Author:** Farshid Mirza (pipeline, `lane:cloud-54`)

## What changed

`universal-till`'s core `web/locales/en.json` shipped a new key,
`reports.avg_sale` ("Avg sale"), as part of ut-docs#1974 (PR
universaltill/universal-till#1038, merged). Per this repo's own
`CLAUDE.md`, any new core key needs a follow-up translation here — the
`lang-pack-drift` check on `universal-till`'s `push:main` confirmed this
exact gap (blocking, as documented) immediately after the merge.

- `locales/es.json`: added `"reports.avg_sale": "Venta media"`, in
  alphabetical position (between `reports.ask.title` and
  `reports.business_day_start.help`, matching core's own key ordering).
- `manifest.json`: version bumped `1.1.37` → `1.1.38` per
  `scripts/check-version-bump.sh`'s requirement (this PR touches a
  shipped file, `locales/es.json`).

## Verified

- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.38 (es)`.
- `UT_CORE_EN_JSON=<local universal-till checkout>/web/locales/en.json
  bash scripts/check-key-drift.sh` — `ok -- 2267/2268 core keys
  translated, 1 known-untranslated (baseline), 33 known-same-as-English
  (allowlist), 0 drift, 0 orphans, 0 empty values, 0 untranslated-present,
  0 token mismatches`.
- Confirmed `reports.avg_sale` does not appear in either
  `i18n-baseline/es.untranslated.txt` or `i18n-baseline/es.same-as-en.txt`
  — it's a brand-new translated key, not a previously-tracked gap, so no
  baseline pruning was needed.
- `git diff --stat` against the prior committed state shows exactly the
  two files above — nothing else touched.
- Translation checked for register/tone consistency against neighboring
  KPI labels in the same file (`reports.revenue` → "Ingresos",
  `reports.sales` → "Ventas") — "Venta media" (literally "average sale")
  matches the same short-noun KPI-tile convention.

## Scope note

A dedicated fresh-context Sonnet review subagent was dispatched in
parallel for this exact change (covering both `-de` and `-es` together);
this record documents the personal verification performed directly
against the repo's own guard scripts, which is the load-bearing check for
a single-key content addition. Any subagent finding is folded into a
follow-up commit if it surfaces something this verification missed.

## Verdict

Guard scripts (`validate.sh`, `check-key-drift.sh`) both pass clean
against the merged core commit. Safe to ship.
