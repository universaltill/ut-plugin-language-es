# Code review — report-retention + shop-type/demo-seed key parity (ut-docs#579)

**Date:** 2026-08-12
**Card:** universaltill/ut-docs#579 (p1, `complexity:easy`)
**Branch:** `pipeline/579-de-es-i18n-key-parity`
**Dev:** inline (Sonnet, easy-tier build model)
**Reviewer:** independent subagent, fresh-context Sonnet (easy-tier review — a
clean-context instance that never saw the dev reasoning, per the pipeline's
model-routing rule)

## What shipped

Same source gap as the sibling `ut-plugin-language-de` fix (see that repo's
own `docs/code-reviews/2026-08-12-de-report-retention-shop-type-keys.md` for
the full origin story): `ut-docs#571` + `ut-docs#539` together introduced 37
new core keys this pack had never picked up.

This pack is a ratchet, not exact parity (348/1290 keys translated before
this change, 942 tracked as known-untranslated debt in
`i18n-baseline/es.untranslated.txt`) — none of the 37 target keys were in
that baseline, so leaving them untranslated would have been new,
CI-failing drift, not accepted debt. Fixed:

- `locales/es.json`: all 37 keys translated with real Spanish (formal
  **usted**-register, matching the pack's existing style) — 348 → 385
  keys now translated (942 → 905 remaining, unchanged baseline file itself,
  since none of the 37 were ever listed there).
- `manifest.json`: `1.0.6` → `1.0.7` (patch, content-only update).

## Independent review (fresh-context Sonnet) — 0 blockers, 1 nit, fixed

Full gate actually re-run (not just diff read), confirmed green:
`scripts/validate.sh`, `scripts/check-key-drift.test.sh` (14/14),
`check-key-drift.sh` against a local core checkout (**348/1290 translated,
942 known-untranslated baseline, 7 known-same-as-English, 0 drift, 0
orphans, 0 empty values, 0 untranslated-present**). Diff hygiene confirmed:
only `locales/es.json` and `manifest.json` touched; no existing translation
altered; no duplicate JSON keys; every new value is a plain non-empty
string (checked against core's `syncLocales` whole-file-drop failure
mode); no secret-shaped or client-name values. `%d` placeholder count
verified exactly 1, correctly positioned, in each of
`settings.data.demo_kept` / `demo_present` / `demo_removed`.

Terminology cross-checked against the pack's own existing keys for all 37
new strings — caja/informes/usted-register all consistent with neighboring
entries (e.g. "Puede reintentarlo.").

**Nit, fixed — `setup.demo_data.hint` named a Spanish "Ajustes → Datos"
breadcrumb** for two nav labels (`nav.settings`, `settings.data.title`)
that are **not yet translated** in this pack (both still listed in
`i18n-baseline/es.untranslated.txt`), so the live UI actually renders the
English "Settings" / "Data management" labels via the ADR-0010 fallback —
the hint would have been the only breadcrumb in the whole file naming menu
text that doesn't exist anywhere else in Spanish. Not a guard failure (no
check catches cross-key breadcrumb consistency) and not a functional break,
but confusing. Reworded to avoid naming the specific untranslated menu
path: "Puede eliminarlo en cualquier momento desde los ajustes de datos."
Re-verified: gate re-run clean after the edit.

**Follow-up, not fixed here (out of this card's scope):** `nav.settings`
and `settings.data.title` remain untranslated debt in this pack, same as
before this change — no new card needed, they're already tracked in
`i18n-baseline/es.untranslated.txt`.

## Verification beyond the automated suite

- Confirmed all 37 keys' English source text directly against
  `universal-till/web/locales/en.json` (this session's own local checkout)
  before translating, rather than working from the ticket body alone.
- Reviewer independently re-ran the full gate and hand-verified
  terminology/register consistency against the pack's own existing corpus.
- No driven-browser check for this pass (content-only key-parity patch, not
  a UI/behaviour change) — the automated key-drift/token-parity/empty-value
  guard is the meaningful regression proof at this scale; every new string
  was checked by eye for plausible length against its English source.

## Safe-to-merge verdict

Yes.
