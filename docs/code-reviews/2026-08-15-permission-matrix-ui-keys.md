# Code review — permission-matrix UI key parity (ut-docs#556)

**Date:** 2026-08-15
**Card:** universaltill/ut-docs#556 (p2, `complexity:medium`) — stale-PR/CI sweep
follow-up, not the card's own build
**Branch:** `pipeline/556-permission-matrix-ui-lang-pack-keys`
**Dev:** inline (Sonnet, autonomous SDLC pipeline, Scrum Master role doing its
own step-0c CI-red cleanup)
**Reviewer:** independent subagent, fresh-context Sonnet (mechanical i18n
key-sync fix — easy-tier review, a clean-context instance that never saw the
dev reasoning)

## What shipped

`universal-till` PR #365 (`ut-docs#556`, merged `296b0fa`) added a
`super_admin` permission-matrix UI and introduced 23 new core keys —
22 `permissions.*` plus `users.role.super_admin` — in `web/locales/en.json`.
The push-triggered (blocking) `lang-pack-drift` run on `main` failed
immediately after merge because this pack didn't have the new keys.

This pack is a **partial-coverage** pack (447/1444 core keys translated;
whole domains, including `users.role.*`, `settings.*` in part, and now
`permissions.*`, are deliberately tracked as accepted debt rather than
translated same-day). Consistent with that existing pattern — all four
`users.role.*` keys were already untranslated debt before this change — the
fix adds the 23 new keys to the untranslated baseline rather than
translating them, so the guard stops flagging new drift without inventing
Spanish text nobody has reviewed for quality yet.

- `i18n-baseline/es.untranslated.txt`: 23 new entries, generated via
  `scripts/check-key-drift.sh --update-baseline` (not hand-edited) —
  purely additive, correctly sorted/deduplicated, nothing pruned or
  reordered.
- `manifest.json`: `1.0.8` → `1.0.9` (patch — baseline-bookkeeping only).

## Independent review (fresh-context Sonnet) — 0 blockers, 0 nits

Full gate actually re-run: `scripts/validate.sh`, `scripts/check-key-
drift.test.sh`, and `check-key-drift.sh` against a local core checkout of
the just-merged `en.json` — **447/1444 translated, 997 known-untranslated
(baseline), 0 drift, 0 orphans, 0 empty values, 0 untranslated-present**.
Confirmed the "consistent with the pack's existing pattern" claim directly
rather than on faith: all four `users.role.*` keys were already in the
baseline pre-change, and `settings.*`/`reports.*` are only partially
covered. Confirmed the baseline diff is exactly 23 additions, alphabetically
inserted, with no removal or reordering elsewhere in the file. Diff hygiene
confirmed: only `i18n-baseline/es.untranslated.txt` and `manifest.json`
touched, valid file, no secret-shaped or client-name values.

## Verification beyond the automated suite

- Pulled all 23 keys' exact English source text directly from
  `universal-till`'s `origin/main` `web/locales/en.json` before deciding the
  baseline-vs-translate approach.
- Reviewer independently re-ran `--update-baseline` reasoning by inspecting
  the resulting diff for sortedness/dedup rather than trusting the script's
  own report alone.
- Companion fix in the sibling `ut-plugin-language-de` repo (same underlying
  gap, real translations added there since that pack maintains full
  parity) — see that repo's own `docs/code-reviews/`.

## Safe-to-merge verdict

Yes.
