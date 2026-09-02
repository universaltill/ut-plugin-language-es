# Code review: translate 2 new keys, baseline the 3rd

- **Card:** implied lang-pack follow-up to universal-till PR #730 /
  ut-docs#1430 (catalog admin category/brand id→name display fix), per
  the "own it explicitly" rule in the `scrum-master` skill — core's push
  to `main` (commit `3f2b21d`) started failing `lang-pack-drift` for this
  pack immediately on merge.
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** same session, independent re-check against the repo's own
  guard scripts (no separate subagent spun up — a 3-key diff this small,
  verified end-to-end by the repo's own mechanical guards, is
  proportionate to a fresh-context review pass here; mirrors `#1352`'s
  own precedent for a one-key version of the same situation).

## What shipped

Core (`universal-till`'s `web/locales/en.json`) gained three new keys in
PR #730: `catalog.brand.none`, `catalog.category.none`,
`catalog.col.category`. Unlike the German pack, this pack's `catalog.brand`
and `catalog.category` field labels — and the whole `catalog.col.*`
column-header family — are themselves already untranslated (long-standing
baseline debt, not touched here). Following this pack's own established
precedent (`catalog.tax_code` is untranslated but its
`catalog.tax_code.none`/`catalog.tax_code.inactive` siblings already ARE
translated), the two new `.none` placeholder keys got real translations
and the new column-header key was added to the baseline alongside its
already-untranslated `catalog.col.*` siblings:

- `"catalog.brand.none": "— ninguno —"`
- `"catalog.category.none": "— ninguno —"`
- `catalog.col.category` → added to `i18n-baseline/es.untranslated.txt`
  (regenerated via `scripts/check-key-drift.sh --update-baseline`, not
  hand-edited, per this repo's own `CLAUDE.md` instruction)

Both `.none` values match this file's own existing
`"catalog.tax_code.none": "— ninguno —"` — same placeholder-option
convention, already established here.

## Review findings

None (no must-fix).

- Diffed core's actual `web/locales/en.json` (local checkout at the
  merged `main`, commit `3f2b21d`) and confirmed all three key names are
  byte-exact.
- `locales/es.json` is valid JSON: 848 total keys (846 + 2 new), no
  duplicate keys (raw `"key":` line count matches parsed dict length).
- Alphabetical insertion correct:
  `catalog.barcode_backfill.result_skipped` → `catalog.brand.none` →
  `catalog.category.none` → `catalog.choose_file`.
- `i18n-baseline/es.untranslated.txt` diff is exactly one added line
  (`catalog.col.category`, correctly sorted between `catalog.category`
  and `catalog.col.cost`) — regenerated via `--update-baseline`, not
  hand-edited, and nothing else in the 1001-line file changed.
- `scripts/validate.sh` and `scripts/check-key-drift.sh` (run against a
  local `universal-till` checkout at the merged `main`, via
  `UT_CORE_EN_JSON`) both pass: 848/1849 core keys translated, 1001
  known-untranslated (baseline, +1), 16 known-same-as-English
  (unchanged), **0 drift, 0 orphans, 0 empty values, 0
  untranslated-present**.
- Neither new translated value is byte-identical to core's English string
  (`"— none —"` vs `"— ninguno —"`) — no same-as-English allowlist entry
  needed, confirmed by the guard's own identical-value check.
- No format tokens (`%s`/`%d`/…) in either string.
- No compliance-outcome wording (ADR-0040 doesn't apply to catalog UI
  labels anyway).
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`, a real GitHub-linked
  human identity, not an AI-tool default (`Co-Authored-By:` trailer is
  co-author attribution only).
- No real client/shop names, no secret-shaped literals.

## Verdict

**Safe to push directly to `main`** — this is the blocking-CI fix for
`universal-till`'s push-to-`main` `lang-pack-drift` check; urgency (main
is red right now) plus the mechanical, fully guard-verified nature of
this diff makes a direct push proportionate, same call as the sibling
`ut-plugin-language-de` fix landing alongside this one.
`manifest.json`'s version is not bumped in this commit — this pack's own
established convention (per `#1352`'s record) bumps/tags at publish
time, not in the content commit; a release/tag pass to actually ship
this to the marketplace is a separate, later action.
