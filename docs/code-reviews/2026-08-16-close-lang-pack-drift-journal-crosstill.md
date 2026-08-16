# Code review — close lang-pack drift (journal cross-till keys)

**Date:** 2026-08-16
**Trigger:** `universal-till` PR #375 (`ut-docs#550`, cross-till end-of-day
order list) merged to `main` and added 7 new `journal.*` keys to
`web/locales/en.json`. The `lang-pack-drift` workflow is blocking on push
to `main` per this ecosystem's standing rule (`universal-till/CLAUDE.md`),
and went red on the merge commit (`952b321`) because neither language pack
had the new keys yet — expected, not a regression in #375 itself.
**Branch:** `fix/770-journal-crosstill-keys`
**Dev:** inline (Scrum Master pipeline cycle, same session that swept the
stale PR and merged #375 — a same-session "don't leave main red" fix, not a
separately-picked backlog card)
**Reviewer:** self-reviewed inline — proportionate to scope (7 keys, no
logic, precedented fix shape identical to several prior
`close-lang-pack-drift-*` records in this same directory)

## What shipped

- `locales/es.json`: added the 7 missing keys — this pack is NOT at full
  parity with core (462/1464, a large pre-existing backlog tracked in
  `i18n-baseline/es.untranslated.txt`), and fixing that backlog is
  explicitly out of scope here; only the 7 keys this trigger's drift
  check named were added.
  - `journal.col.till` / `journal.filter.till` → `Caja`
  - `journal.filter.all_tills` → `Todas las cajas`
  - `journal.filter.day` → `Día`
  - `journal.replica_no_cross_till` → `Las ventas entre cajas solo están
    disponibles en la caja principal de este negocio.`
  - `journal.till_last_synced` → `Último contacto de %s: %s`
  - `journal.till_unknown` → `Caja desconocida`
- `manifest.json`: `1.1.0` → `1.1.1` (patch).

Companion fix in the sibling `ut-plugin-language-de` repo (same trigger,
separate PR/review — see that repo's own `docs/code-reviews/`; `de` was
already at full parity and stays there).

## Verification

- `scripts/validate.sh` — green (JSON valid, every value a non-empty
  string).
- `scripts/check-key-drift.sh` against `universal-till`'s real `main`
  `web/locales/en.json` (extracted via `git show origin/main:...` after
  the #375 merge, not a stale local checkout) — **462/1464 translated,
  1002 known-untranslated (baseline, unchanged), 7 known-same-as-English
  (allowlist, unchanged), 0 drift, 0 orphans, 0 empty values, 0
  untranslated-present**. The pre-existing backlog is untouched — this
  change only closes the 7 new-drift keys the trigger named.
- `scripts/check-key-drift.test.sh` — 8/8 passed, unaffected by this
  change (fixture-driven, not touching real locale files).
- Terminology cross-checked against the pack's own existing corpus before
  writing the translations: `shifts.register: "Caja"`,
  `settings.tills.register_label: "Caja de este dispositivo"`,
  `setup.till_name.default: "Caja 1"` — `Caja` is the pack's consistent
  term for "till", used rather than a synonym (e.g. "Terminal"). `negocio`
  matches existing shop/business terminology in the file. `%s`/`%s` token
  count and order in `journal.till_last_synced` matches core's
  `"Last contact from %s: %s"` exactly.
- No UI/driven-browser check performed for this pass — accepted gap at
  this scale (a 7-key content-only patch), same reasoning as this
  directory's `2026-08-08-close-lang-pack-drift-374.md` precedent. Every
  new string checked by eye for plausible length against its English
  source; none flagged as overflow risk.

## Safe-to-merge verdict

Yes.
