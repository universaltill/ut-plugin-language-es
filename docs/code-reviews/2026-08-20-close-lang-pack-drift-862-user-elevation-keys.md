# Code review — close lang-pack drift (user-management elevation keys)

**Date:** 2026-08-20
**Card:** universaltill/ut-docs#862 (p3, `complexity:easy`)
**Trigger:** `universal-till`'s `lang-pack-drift` check is red on `main` — a
recent user-management/elevation feature (`ut-docs#794`/`#795`) added 6 new
keys to `web/locales/en.json` and neither language pack had them yet
(pre-existing, not caused by any change in this cycle).
**Branch:** `fix/862-user-elevation-keys`
**Dev:** inline (Sonnet, autonomous SDLC pipeline)
**Reviewer:** independent subagent, fresh-context Sonnet (easy-tier —
mechanical i18n key-sync fix, a clean-context instance that never saw the
dev reasoning)

## What shipped

This pack is a **partial-coverage** pack (505/1536 core keys translated;
whole domains, including all of `users.*` beyond a couple of columns and
most of `elevation.summary.*`, are deliberately tracked as accepted debt
rather than translated same-day). Consistent with that existing pattern —
every other `elevation.summary.*` key except `user_activate`/`user_create`/
`user_deactivate`/`user_pin_set`/`user_role_change` was already untranslated
debt, and `users.role.*` etc. likewise — the fix adds the 6 new keys to the
untranslated baseline rather than translating them, so the guard stops
flagging new drift without inventing Spanish text nobody has reviewed for
quality yet. Same reasoning, same shape as the direct precedent already in
this directory: `2026-08-15-permission-matrix-ui-keys.md`.

- `i18n-baseline/es.untranslated.txt`: 6 new entries
  (`elevation.summary.user_activate`, `elevation.summary.user_create`,
  `elevation.summary.user_deactivate`, `elevation.summary.user_pin_set`,
  `elevation.summary.user_role_change`, `users.saved`), generated via
  `scripts/check-key-drift.sh --update-baseline` (not hand-edited) —
  purely additive, correctly sorted, nothing pruned or reordered.
- `manifest.json`: `1.1.1` → `1.1.2` (patch — baseline-bookkeeping only).

Companion fix in the sibling `ut-plugin-language-de` repo (same underlying
gap, real translations added there since that pack maintains full parity —
see that repo's own `docs/code-reviews/`).

## Verification

- `scripts/validate.sh` — green, `v1.1.2 (es)`.
- `scripts/check-key-drift.sh` against `universal-till`'s real `main`
  `web/locales/en.json` (local checkout at `4df0626`, matching
  `origin/main`) — **505/1536 translated, 1031 known-untranslated
  (baseline), 8 known-same-as-English (allowlist), 0 drift, 0 orphans, 0
  empty values, 0 untranslated-present**.
- `scripts/check-key-drift.test.sh` — all tests passed, unaffected by this
  change (fixture-driven).
- `scripts/package.sh` — dry-run packages cleanly; `dist/` output removed
  before commit (gitignored, not part of the diff).
- Pulled all 6 keys' exact English source text directly from a local
  `universal-till` checkout confirmed to match `origin/main` before
  deciding the baseline-vs-translate approach.

## Independent review (fresh-context Sonnet) — 0 blockers, 0 nits

Re-ran the verification commands independently; read
`2026-08-15-permission-matrix-ui-keys.md` and confirmed it directly
supports the baseline-only approach taken here (same reviewer role, same
reasoning, explicitly contrasts with the DE sibling doing real
translations); confirmed the baseline diff is exactly 6 additions,
alphabetically inserted into the correct existing groups, with no removal
or reordering elsewhere in the file; confirmed no secrets, client names, or
stray files in the diff.

## Safe-to-merge verdict

Yes.
