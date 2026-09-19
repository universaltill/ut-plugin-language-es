# Code review: translate 6 new plugin-rollback-versions keys

- **Card:** universaltill/ut-docs#2239 — wiring up plugin rollback version
  discovery on the core `universal-till` side
  (`universaltill/universal-till#1285`, merged). These are brand-new core
  keys; `lang-pack-drift`'s push-to-`main` run on core went red after that
  merge specifically because this pack (`ut-plugin-language-es`) hadn't
  caught up yet — `ut-plugin-language-de` was fixed first and is not the
  only pack this workflow checks; this PR closes the remaining gap.
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** self-reviewed inline (same session as the core change and
  the sibling `ut-plugin-language-de` fix) — a small, mechanical,
  same-cycle language-pack follow-up, not a separate board card.

## What shipped

Six new keys, all added to `locales/es.json` next to their existing
alphabetical neighbours, matching this file's existing register and the
exact terminology already used elsewhere in the `plugins.manage.*` block:

- `plugins.manage.action.rollback_to` → "Revertir a esta versión"
- `plugins.manage.action.versions` → "Versiones"
- `plugins.manage.confirm_rollback` → "Revertir"
- `plugins.manage.currently_installed` → "Instalada actualmente"
- `plugins.manage.no_versions` → "No hay versiones anteriores disponibles"
- `plugins.manage.versions_title` → "Versiones disponibles"

None is identical to its English source, so no
`i18n-baseline/es.same-as-en.txt` allowlist entry is needed; none of the
six appeared in `i18n-baseline/es.untranslated.txt` either, so no baseline
pruning was required.

`manifest.json`'s version bumped `1.1.89` → `1.1.90`, per this repo's own
`CLAUDE.md`.

## Review findings

None (no must-fix).

Verified, live, not just read:

- `bash scripts/validate.sh` — exit 0: `ok com.universaltill.language-es
  v1.1.90 (es)`.
- `UT_CORE_EN_JSON=/home/user/universal-till/web/locales/en.json bash
  scripts/check-key-drift.sh` (core's actual post-merge `main`) — exit 0:
  **2589/2589 core keys translated, 0 known-untranslated, 38
  known-same-as-English (allowlist), 0 drift, 0 orphans, 0 empty values,
  0 untranslated-present, 0 token mismatches.**
- All 6 key names diffed byte-exact against
  `universal-till/web/locales/en.json` — no typos, no extras, no
  duplicate JSON keys.
- No format/placeholder tokens in any of the 6 English source strings,
  and none invented on the Spanish side.
- No real client/shop name, no secret-shaped literal.
- Git identity on the commit: `Farshid Mirza
  <farsid@taskrunnertech.co.uk>` — this repo was freshly cloned mid-cycle
  and the identity was set locally before the first commit, per the
  `scrum-master` skill's mid-cycle repo-attach rule.

## Verdict

**Safe to merge** — this is the other half of the fix for
`universal-till` main's `lang-pack-drift` (the `ut-plugin-language-de`
half already merged in `ut-plugin-language-de#293`). `merge_method:
"merge"`.
