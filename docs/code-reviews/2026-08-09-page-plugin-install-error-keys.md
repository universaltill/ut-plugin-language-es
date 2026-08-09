# Code review — translate 3 new `plugins.install.error.*` keys (ut-docs#411)

**Date:** 2026-08-09
**Card:** universaltill/ut-docs#411 (p3, `complexity:medium`)
**Branch:** `fix/411-page-plugin-install-error-keys`
**Dev:** inline, Sonnet (session model — the card's original "42+ keys"
estimate was stale; two prior pipeline cycles, #494 and #441, had already
closed almost all of that drift before this cycle picked the card up. What
remained when this cycle actually ran `check-key-drift.sh` against core's
current `main` was exactly 3 keys, well inside "easy/medium inline"
territory, not the "hard" scope the original estimate implied.)
**Reviewer:** independent subagent, Opus (medium-tier review model, fresh
context)

## What shipped

`plugins.install.error.page_conflict`, `plugins.install.error.page_route_conflict`
(added by `universaltill/universal-till#267`, "reject cross-plugin
page-entry route collisions at install time") and
`plugins.install.error.version_mismatch` (added by
`universaltill/universal-till#270`, "preserve prior good version on a
pinned upgrade mismatch") were never propagated to this pack, so
`bash scripts/ci/check-lang-pack-drift.sh` (run from `universal-till`) had
been red on `main` for both language packs.

- `locales/es.json`: 3 new keys translated for real, grouped next to the
  existing `plugins.install.error.payment_conflict` sibling whose Spanish
  phrasing they follow ("entra en conflicto con una ya existente. Elija
  otra… e inténtelo de nuevo."). Coverage: 241 → 244/1186.
- `manifest.json`: `1.0.4` → `1.0.5` (patch — content addition).
- No baseline/allowlist file touched — these are genuinely new keys, not a
  rename or a previously-baselined key coming into scope, so
  `i18n-baseline/es.untranslated.txt`/`es.same-as-en.txt` are unaffected.

Companion fix in the sibling `ut-plugin-language-de` repo (same card,
separate branch/review — see that repo's own
`docs/code-reviews/2026-08-09-page-plugin-install-error-keys.md`) closes
the other half of the CI failure; `de` was at 1183/1186 before this change
and reaches full 1186/1186 parity after it.

## Translations

| key | Spanish | rationale |
|---|---|---|
| `plugins.install.error.page_conflict` | "La clave de página de este plugin entra en conflicto con una ya existente. Elija otra clave e inténtelo de nuevo." | Direct translation, mirrors `payment_conflict`'s established phrasing for a same-shape install-time conflict error. |
| `plugins.install.error.page_route_conflict` | "La ruta de página de este plugin entra en conflicto con una ya existente. Elija otra ruta e inténtelo de nuevo." | Same pattern, `route` → `ruta` (the term this pack already uses for URL routes). |
| `plugins.install.error.version_mismatch` | "El marketplace no devolvió la versión solicitada del plugin. La instalación falló." | Direct translation; "La instalación falló" matches the existing `retryable` key's register. Adjective placement (`la versión solicitada del plugin`, not `la versión del plugin solicitada`) fixed in review — see below. |

## Independent review (Opus, fresh context) — 0 blockers, 2 style nits, both fixed

Re-ran the full gate from scratch against this branch, independently (not
trusting a pre-written claim of results):
`scripts/validate.sh` (clean), `scripts/check-key-drift.sh` against a real
local `universal-till` checkout's `web/locales/en.json`
(**244/1186 translated, 942 baseline, 6 allowlist, 0 drift, 0 orphans, 0
empty values, 0 untranslated-present**), `scripts/check-key-drift.test.sh`
(14/14), `scripts/package.sh` — confirmed the produced tarball contains
exactly `manifest.json`, `locales/es.json`, `README.md`, `LICENSE`, no
`i18n-baseline/`. Confirmed diff hygiene: only `locales/es.json` (3 new
lines, no existing key altered) and `manifest.json` (version bump)
touched; 0 duplicate keys; 0 non-string/empty values; none of the 3 new
keys present in either baseline/allowlist file (correctly not baselined —
they're new, not previously-known debt).

Hand-verified all 3 new strings against the English source and the pack's
existing corpus: formal *usted* register maintained throughout (`Elija`,
`inténtelo` — no tú/vosotros leakage), gender agreement correct (`clave`
and `ruta` both feminine, `el marketplace` matching existing usage in
`plugins.install.error.configuration`), no placeholder tokens in any of
the three (this pack's `check-key-drift.sh` copy has no automated
token-parity check yet — ut-docs#312's known tracked gap — but none of
these three keys are token-bearing, so nothing for that gap to miss here).

**NIT, fixed — `version_mismatch` adjective placement.** Original
("`la versión del plugin solicitada`") is grammatical (`solicitada`
agrees unambiguously with feminine `versión`) but separates the adjective
from its noun awkwardly. Fixed to "`la versión solicitada del plugin`".

**Confirmed correct by the reviewer, no changes needed:** version-bump
size (patch, for a translation-content-only addition — real git history
shows two comparable prior "translate N new keys" commits,
`d1eeb55`/`55431cd`, that also bumped patch and carried a review doc; two
smaller drift-closing commits since, `56ceee6`/`8ed7ece`, shipped without
either — this diff follows the better-documented, and correct, precedent:
a content change needs a new version for the marketplace to actually
serve it).

**Out-of-scope finding, not fixed here, worth its own card:** the pack
has pre-existing tú-register leakage unrelated to this diff —
`plugins.manage.empty` = "No hay plugins instalados. **Consíguelos** en
la tienda de plugins." (`consíguelos` is tú; every other imperative in
the pack, including all 3 new keys here, is *usted* — the correct form
would be `Consígalos`). Flagging so it isn't mistaken for something this
change introduced; not touched, out of this card's scope.

## Verified beyond the automated suite

- Confirmed both new core keys' English source text directly from
  `universal-till/web/locales/en.json` on `main` (not from the issue's
  possibly-stale quoted text) before translating.
- Confirmed the pre-existing `payment_conflict` sibling's phrasing was the
  right style precedent by reading it in context, not assuming.
- Confirmed `check-lang-pack-drift.sh`'s exact current failure (3 keys,
  identical for both packs) by running the pack-side `check-key-drift.sh`
  locally against a real core checkout before writing any translation —
  not guessed from the (stale) issue text.
- Independent reviewer re-verified gate output, translation grammar, and
  version-bump precedent from real git history rather than trusting the
  Dev-authored draft of this doc.

## Safe-to-merge verdict

Yes.
