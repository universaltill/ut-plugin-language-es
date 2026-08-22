# Code review — close lang-pack drift (tables.node.aria key)

**Date:** 2026-08-22
**Card:** universaltill/ut-docs#891 (p3, `complexity:easy`)
**Trigger:** `universal-till`'s `lang-pack-drift` check is red on `main` —
the tables floor-plan keyboard-reposition work (`universal-till` PR #435,
on top of #814/#820) added `tables.node.aria` to `web/locales/en.json`
and neither language pack had it yet (pre-existing gap, not caused by any
change in this cycle).
**Branch:** `fix/891-tables-node-aria-key`
**Dev:** inline (Sonnet, autonomous SDLC pipeline)
**Reviewer:** independent subagent, fresh-context Sonnet (easy-tier —
mechanical i18n key-sync fix, a clean-context instance that never saw the
dev reasoning)

## What shipped

Added the single missing key, translated, to `locales/es.json`:

- `tables.node.aria` → "%s — use las teclas de flecha para mover
  (mantenga Mayús para un paso mayor)"

Placed in the same position as core's `en.json` (right after
`tables.edit.hint`, before `tables.status.open_minutes`). No manifest
version bump — nothing in `ci.yml`/`validate.sh` gates a locale-only patch
on one.

Companion fix in the sibling `ut-plugin-language-de` repo (same trigger,
separate PR/review — see that repo's own `docs/code-reviews/`).

## Verification

- `scripts/validate.sh` — green: JSON valid, every value a non-empty
  string, `ok com.universaltill.language-es v1.1.3 (es)`.
- `scripts/check-key-drift.sh` against `universal-till`'s real `main`
  `web/locales/en.json` — **532/1585 translated, 1053 known-untranslated
  (baseline), 8 known-same-as-English, 0 drift, 0 orphans, 0 empty
  values, 0 untranslated-present**.
- `%s` placeholder preserved verbatim, single token, order matches source.
- `i18n-baseline/es.untranslated.txt` / `es.same-as-en.txt` — confirmed
  `tables.node.aria` was in neither file before this change, so no
  baseline pruning was required.
- Terminology/style cross-checked against the pack's existing corpus:
  formal/usted imperative ("mantenga") consistent with the pack's other
  imperative strings (e.g. `tables.edit.hint`'s "Arrastre...").
- No UI/driven-browser check performed for this pass — accepted gap at
  this scale (single-key content-only patch), consistent with this
  directory's own precedent.

## Independent review (fresh-context Sonnet) — 0 blockers, 0 nits

Re-ran `validate.sh` and `check-key-drift.sh` independently rather than
trusting the dev report; confirmed the Spanish grammar, placeholder
preservation, and encoding (no mojibake) by direct byte-level inspection;
confirmed the diff touches only `locales/es.json`, no secrets, no client
names, no stray files.

## Safe-to-merge verdict

Yes.
