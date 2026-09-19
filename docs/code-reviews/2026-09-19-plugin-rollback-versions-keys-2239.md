# Code review: translate 6 new plugin-rollback-versions keys

- **Card:** universaltill/ut-docs#2239 — wiring up plugin rollback version
  discovery on the core `universal-till` side
  (`universaltill/universal-till#1285`, merged as `cf54dc5`). These are
  brand-new core keys with no prior Spanish translation to fall behind
  on. The German pack (`ut-plugin-language-de#293`) already closed the
  same gap for `de`; this PR is the matching follow-up for `es`, found by
  this cycle's `lang-pack-drift` push-to-`main` check on `universal-till`
  failing *after* the German pack landed — `check-lang-pack-drift`
  explicitly named `ut-plugin-language-es` as still drifted (6 keys
  missing, none in the baseline).
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** self-reviewed inline (same session as the core change and
  the German pack follow-up) — a small, mechanical, same-cycle
  language-pack follow-up, not a separate board card; verified live
  against the repo's own guards rather than just asserted.

## What shipped

Six new keys, all added to `locales/es.json` next to their existing
alphabetical neighbours, matching this file's existing formal **usted**
register and the exact terminology already used elsewhere in the
`plugins.manage.*` block:

- `plugins.manage.action.rollback_to` → "Revertir a esta versión"
- `plugins.manage.action.versions` → "Versiones"
- `plugins.manage.confirm_rollback` → "Revertir"
- `plugins.manage.currently_installed` → "Instalado actualmente"
- `plugins.manage.no_versions` → "No hay versiones anteriores disponibles"
- `plugins.manage.versions_title` → "Versiones disponibles"

None is identical to its English source, so no
`i18n-baseline/es.same-as-en.txt` allowlist entry is needed.

`manifest.json`'s version bumped `1.1.89` → `1.1.90`, per this repo's own
`CLAUDE.md` ("any PR that touches a shipped file … must bump
`manifest.json`'s version in the same PR").

## Review findings

None (no must-fix).

Verified, live, not just read:

- `bash scripts/validate.sh` — exit 0: `ok com.universaltill.language-es
  v1.1.90 (es)`.
- `UT_CORE_EN_JSON=/home/user/universal-till/web/locales/en.json bash
  scripts/check-key-drift.sh` (pointed at core's actual merged `main`,
  `cf54dc5`, which carries these 6 new keys) — exit 0: **2589/2589 core
  keys translated, 0 known-untranslated, 38 known-same-as-English
  (allowlist), 0 drift, 0 orphans, 0 empty values, 0
  untranslated-present, 0 token mismatches.**
- All 6 key names diffed byte-exact against
  `universal-till/web/locales/en.json` on `main` — no typos, no extras,
  no duplicate JSON keys.
- No format/placeholder tokens (`%s`/`%d`/`{{…}}`/`{N}`) in any of the 6
  English source strings, and none invented on the Spanish side.
- No real client/shop name, no secret-shaped literal.
- Git identity on the commit: `Farshid Mirza
  <farsid@taskrunnertech.co.uk>` — this repo was freshly cloned mid-cycle
  and the identity was verified against the global config (already
  correct) before the first commit, per the `scrum-master` skill's
  mid-cycle repo-attach rule.

## Verdict

**Safe to merge** — this is the fix for `universal-till` `main`'s
currently-red `lang-pack-drift` check (blocking on push, per this
ecosystem's standing i18n rules). `merge_method: "merge"`.
