# Code review: translate 2 new replica-write-protection keys

- **Card:** universaltill/ut-docs#1585 — `lang-pack-drift` red on
  `universal-till` main since PR #796 ("fix(sync): refuse
  tables/kitchen-stations writes on a joined till") merged, minutes
  before this fix was started (caught live by the merging cycle itself).
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context Sonnet subagent — did not see
  the implementation reasoning, read the diff cold, ran the repo's own
  guards live rather than trusting a report.

## What shipped

Core (`universal-till`'s `web/locales/en.json`) gained 2 new keys in
PR #796: `tables.error.replica_use_primary` and
`kitchenstations.error.replica_use_primary`. This pack's
`locales/es.json` gets real Spanish translations for both, inserted
next to the existing `tables.error.*` / `kitchenstations.error.*`
blocks, matching this repo's existing style and the exact phrasing
pattern already used for the sibling
`registers.error.replica_use_primary` / `locations.error.replica_use_primary`
keys ("Esta caja sigue a una caja principal — administre \<noun\> en
la caja principal.") — "las estaciones de cocina" for kitchen stations
(matches `kitchenstations.title` → "Estaciones de cocina"), "las
mesas" for tables (matches `tables.col.name` → "Mesa").

Neither string is identical to its English source, so no
same-as-English allowlist entry is needed.

## Review findings

None (no must-fix).

Verified, live, not just read:
- `bash scripts/validate.sh` — exit 0, `ok
  com.universaltill.language-es v1.1.16 (es)`.
- `UT_CORE_EN_JSON=<local universal-till checkout> bash
  scripts/check-key-drift.sh` — exit 0: **1945/1945 core keys
  translated, 0 known-untranslated, 31 known-same-as-English
  (allowlist), 0 drift, 0 orphans, 0 empty values, 0
  untranslated-present.**
- Both key names diffed byte-exact against
  `universal-till/web/locales/en.json` — no typos, no extras, no
  duplicate JSON keys.
- No format/placeholder tokens in the English source for this key
  pair, and none invented on the Spanish side.
- No real client/shop name, no secret-shaped literal.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>` — this repo was
  freshly cloned mid-cycle and the identity was set locally before the
  first commit, per the `scrum-master` skill's mid-cycle repo-attach
  rule.

## Verdict

**Safe to merge** — this is the other half of the blocking-CI fix for
`universal-till`'s push-to-`main` `lang-pack-drift` check (the
`ut-plugin-language-de` PR is its twin); `main` is red right now, and
this diff is small, mechanical, and fully guard-verified.
`manifest.json`'s version is not bumped in this commit — release/tag is
a separate, later action (established precedent, see the 2026-09-05
Bluetooth-keys review record in this same directory).
