# 2026-08-09 — lang-pack-drift: stale `plugins.marketplace.install_success` baseline entry

**Card:** universaltill/ut-docs#494
**Branch:** `fix/494-lang-pack-drift-stale-baseline`

## What shipped

`i18n-baseline/es.untranslated.txt` still listed
`plugins.marketplace.install_success` as known-accepted untranslated debt,
but core (`universal-till/web/locales/en.json`) dropped that key entirely
in `universal-till`#261 ("remove unverified legacy plugin install
endpoints"). `check-key-drift.sh` treats a baseline entry for a key core
no longer has as stale (the same rule as an entry that's since been
translated) — it must be pruned so the baseline can never quietly hide a
real re-regression later. That staleness is what took the
`lang-pack-drift` GitHub Actions check red on `universal-till` `main`.

Fix: delete the single stale line from `i18n-baseline/es.untranslated.txt`.
`locales/es.json` itself never carried this key (confirmed — see below),
so nothing there needed touching.

## Independent review

Reviewed by a fresh-context Sonnet subagent (this is a `complexity:easy`
card — see the `scrum-master` skill's model-routing table), given the
exact diff, both repos' `CLAUDE.md`/`check-key-drift.sh` header contracts,
and told to actually run things, not just read the diff.

Verified by the reviewer, independently:
- `i18n-baseline/es.untranslated.txt` line count 968 → 967, exactly the
  one targeted line removed, no stray blank line, still sorted/deduped.
- `grep -n "install_success" locales/es.json` → no match — confirms the
  real Spanish locale file never carried this key, so removing only the
  baseline entry (not `locales/es.json`) was the correct, minimal fix.
- `UT_CORE_EN_JSON=<core's current en.json> scripts/check-key-drift.sh` →
  exit 0, `241/1183 core keys translated, 0 drift, 0 orphans, 0 empty
  values, 0 untranslated-present`.
- `scripts/validate.sh` → exit 0.
- `scripts/check-key-drift.test.sh` (14 subtests) → all pass, unmodified.
- Core's PR #261 genuinely dropped this key on purpose — not
  re-litigating that call, only bringing the pack's bookkeeping back to
  parity with it, per the issue's own non-goals.
- `check-lang-pack-drift.sh`'s `PACKS` array lists only
  `ut-plugin-language-de` and `ut-plugin-language-es` — no other pack is
  known to core CI, so the acceptance criterion "no other pack has
  silently drifted" holds by construction.
- No secrets, no real client/shop name, no file-write/path-handling
  concern (pure data deletion in an already-tracked file).
- `web/help/` manual: N/A — this repo has no `web/help/` tree; this is
  developer-only i18n bookkeeping, nothing a shop owner sees or does.

**Findings: none.**

## Verdict

Safe to merge. Together with the matching `ut-plugin-language-de` fix
(`fix/494-lang-pack-drift-orphan-key`), both packs are back in key parity
with core and `lang-pack-drift` should go green on `universal-till`
`main` once both are merged.
