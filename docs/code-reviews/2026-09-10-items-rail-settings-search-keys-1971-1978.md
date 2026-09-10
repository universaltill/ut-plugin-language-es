# 2026-09-10 — items.rail.label + settings.nav/search keys (ut-docs#1971, ut-docs#1978)

## What shipped

`lang-pack-drift` was failing on `universal-till` main (confirmed via the
live push-triggered run on merge commit `6d7eddaa`, and confirmed still
red on the immediately preceding main commit too — not caused by that
push, pre-existing since universal-till#1007/#1009 merged): 6 core keys
never translated here.

- `items.rail.label` → "Secciones de artículos"
- `settings.nav.back` → "Volver a las secciones"
- `settings.nav.label` → "Secciones de ajustes"
- `settings.search.label` → "Buscar en los ajustes"
- `settings.search.none` → "No hay coincidencias. Pruebe con una palabra
  más corta o elija una sección de la lista."
- `settings.search.placeholder` → "Buscar ajustes…"

The `settings.search.*` wording mirrors this file's own existing
`help.search.*` keys (same manual-search UI pattern, already translated),
rather than inventing new phrasing. `manifest.json` bumped 1.1.32 → 1.1.33
— this repo has no `check-version-bump.sh` guard yet (ut-docs#1948 tracks
rolling it out from the sibling `ut-plugin-language-de` repo), but
`auto-tag-release.yml` still keys off the version field to decide whether
to cut a release, so the bump is needed regardless of whether CI enforces
it.

## Verified

- `scripts/validate.sh` — ok, JSON valid, no empty values.
- `UT_CORE_EN_JSON=<local universal-till checkout>/web/locales/en.json
  bash scripts/check-key-drift.sh` — `2252/2252 core keys translated, 0
  known-untranslated, 0 drift, 0 orphans, 0 empty values, 0
  untranslated-present, 0 token mismatches`. Neither key was in
  `i18n-baseline/es.untranslated.txt` beforehand, so no baseline pruning
  was needed.
- Insertion position for each new key matches this file's own local
  ordering (confirmed neighboring keys before editing, not assumed).

## Not independently re-reviewed by a second model

Same reasoning as the sibling `ut-plugin-language-de` PR's own record
(#229 there) — a small, mechanical data-only change verified directly
against this repo's own drift-detection tooling, landing while
`universal-till` main is actively red on this exact check.

## Verdict

Safe to merge — restores `lang-pack-drift` to green for this pack.
