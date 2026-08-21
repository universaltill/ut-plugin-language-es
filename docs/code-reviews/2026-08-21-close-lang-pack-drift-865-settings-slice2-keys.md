# Code review — close lang-pack drift (settings slice 2 elevation keys)

**Date:** 2026-08-21
**Card:** universaltill/ut-docs#865 (complexity:medium, `universal-till`'s
own card; this pack-side fix is the same-day follow-up the `lang-pack-drift`
push-blocking check on `main` forced)
**Trigger:** `universal-till`'s `lang-pack-drift` check went red on `main`
immediately after PR universaltill/universal-till#415 merged — that PR added
12 new `elevation.summary.*` keys to `web/locales/en.json` (wiring the
remaining 10 settings-page mutations onto the manager-override-elevation
mechanism) and neither language pack had them yet.
**Branch:** `chore/865-elevation-summary-keys`
**Dev:** inline (Sonnet, autonomous SDLC pipeline)
**Reviewer:** independent subagent, fresh-context Sonnet (easy-tier —
mechanical i18n key-sync fix, a clean-context instance that never saw the
dev reasoning)

## What shipped

This pack is a **partial-coverage** pack (511/1562 core keys translated
before this change; whole domains, including most of
`elevation.summary.*`, are deliberately tracked as accepted debt rather
than translated same-day). Consistent with that existing pattern — every
other `elevation.summary.*` key already in the baseline except the small
set the DE/ES `#862` and earlier closures translated — the fix adds the 12
new keys to the untranslated baseline rather than translating them, so the
guard stops flagging new drift without inventing Spanish text nobody has
reviewed for quality yet. Same reasoning, same shape as the direct
precedent already in this directory:
`2026-08-20-close-lang-pack-drift-862-user-elevation-keys.md` and
`2026-08-15-permission-matrix-ui-keys.md`.

- `i18n-baseline/es.untranslated.txt`: 12 new entries
  (`elevation.summary.dismiss_pending_base_plugin`,
  `elevation.summary.dismiss_restore_prompt`,
  `elevation.summary.display_mode`, `elevation.summary.enrol_claim_code`,
  `elevation.summary.enrol_now`, `elevation.summary.idle_lock`,
  `elevation.summary.kiosk_idle_reset`,
  `elevation.summary.launch_on_startup_off`,
  `elevation.summary.launch_on_startup_on`,
  `elevation.summary.telemetry_off`, `elevation.summary.telemetry_on`,
  `elevation.summary.window_mode`), generated via `scripts/check-key-drift.sh
  --update-baseline` (not hand-edited) — purely additive, correctly sorted
  into their existing alphabetical groups, nothing pruned or reordered.
- `manifest.json`: `1.1.2` → `1.1.3` (patch — baseline-bookkeeping only).

Companion fix in the sibling `ut-plugin-language-de` repo (same underlying
gap, real translations added there since that pack maintains full parity —
see that repo's own `docs/code-reviews/`).

## Verification

- `scripts/validate.sh` — green, `v1.1.3 (es)`.
- `scripts/check-key-drift.sh` against `universal-till`'s real `main`
  `web/locales/en.json` (local checkout at `a7d6536` / PR #415's merge
  commit) — **511/1562 translated, 1051 known-untranslated (baseline), 8
  known-same-as-English (allowlist), 0 drift, 0 orphans, 0 empty values, 0
  untranslated-present**.
- `scripts/check-key-drift.test.sh` — all 14 fixture cases passed,
  unaffected by this change.
- `scripts/package.sh` — dry-run packages cleanly; `dist/` output removed
  before commit (gitignored, not part of the diff).
- Pulled all 12 keys' exact English source text directly from the local
  `universal-till` checkout confirmed to match `origin/main`'s merge
  commit `a7d6536` before deciding the baseline-vs-translate approach.
- Confirmed the baseline diff is exactly 12 additions, alphabetically
  inserted into the correct existing `elevation.summary.*` group, with no
  removal or reordering elsewhere in the file.

## Independent review (fresh-context Sonnet) — 0 blockers, 0 nits

Re-ran the verification commands independently; read
`2026-08-20-close-lang-pack-drift-862-user-elevation-keys.md` and confirmed
it directly supports the baseline-only approach taken here (same reasoning,
same DE-translates/ES-baselines split); confirmed the baseline diff is
purely additive and correctly sorted; confirmed no secrets, client names,
or stray files in the diff.

## Safe-to-merge verdict

Yes.
