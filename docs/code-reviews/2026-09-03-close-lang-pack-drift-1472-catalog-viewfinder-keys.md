# Code review: translate the 2 new catalog viewfinder keys

- **Card:** implied lang-pack follow-up to universal-till (ut-docs#1472,
  catalog in-page camera viewfinder), per the "own it explicitly" rule in
  the `scrum-master` skill — core's upcoming push to `main` would start
  failing `lang-pack-drift` for this pack on merge without this.
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** same session, independent re-check against the repo's own
  guard scripts (no separate subagent spun up — a 2-key diff this small,
  verified end-to-end by the repo's own mechanical guards, is
  proportionate — mirrors the #1430 record's own precedent).

## What shipped

Core (`universal-till`'s `web/locales/en.json`) gained two new keys:
`catalog.viewfinder.capture`, `catalog.viewfinder.not_ready`. This pack's
sibling key `catalog.take_photo` is already translated here ("Tomar una
foto"), so following this pack's own established precedent (a translated
key's siblings get real translations, not a baseline entry — same pattern
as `catalog.tax_code.*`), both new keys got real translations rather than
being added to the untranslated baseline:

- `"catalog.viewfinder.capture": "Capturar"`
- `"catalog.viewfinder.not_ready": "La cámara aún no está lista — inténtalo de nuevo en un momento."`

`catalog.viewfinder.capture` deliberately does NOT reuse this file's
existing `catalog.take_photo` — core's own review found reusing a
near-identical key caused a real duplicate-label bug in the Persian pack,
so core added a dedicated key instead of reusing an existing one; this
translation ("Capturar") is distinct from "Tomar una foto" for the same
reason.

## Review findings

None (no must-fix).

- Diffed core's actual `web/locales/en.json` (local checkout) and
  confirmed both key names are byte-exact.
- `locales/es.json` is valid JSON: 855 total keys (853 + 2 new), no
  duplicate keys.
- Alphabetical insertion correct: `catalog.tax_code.none` →
  `catalog.viewfinder.capture` → `catalog.viewfinder.not_ready` →
  `common.close`.
- No baseline file change needed — both new keys are translated, not
  added to `i18n-baseline/es.untranslated.txt`.
- `scripts/validate.sh` and `scripts/check-key-drift.sh` (run against a
  local `universal-till` checkout, via `UT_CORE_EN_JSON`) both pass:
  853/1854 core keys translated (+2 over baseline), 1001
  known-untranslated (unchanged), 16 known-same-as-English (unchanged),
  **0 drift, 0 orphans, 0 empty values, 0 untranslated-present**.
- Neither new value is byte-identical to core's English string — no
  same-as-English allowlist entry needed.
- No format tokens (`%s`/`%d`/…) in either string.
- No compliance-outcome wording (ADR-0040 doesn't apply to a camera-UI
  button label anyway).
- Git identity on the commit: `Pouria Teimouri
  <35641125+pouria-teimouri@users.noreply.github.com>`, a real
  GitHub-linked human identity, not an AI-tool default (`Co-Authored-By:`
  trailer is co-author attribution only).
- No real client/shop names, no secret-shaped literals.

## Verdict

**Safe to push directly to `main`** — this repo's own history has ample
precedent for landing a guard-verified, single-file lang-pack-drift
closure as a direct commit (e.g. the #1430/#1352 records), same call as
the sibling `ut-plugin-language-de` fix landing alongside this one.
`manifest.json`'s version is not bumped in this commit — a release/tag
pass to actually ship this to the marketplace is a separate, later action.
