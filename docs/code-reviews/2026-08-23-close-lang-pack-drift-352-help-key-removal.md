# lang-pack-drift red — 109 stale untranslated-baseline entries — ut-docs#352

**Reviewer**: independent Sonnet subagent, fresh context (`complexity:easy`
— Sonnet built it, a fresh-context Sonnet instance reviewed it, per the
scrum-master skill's model routing exception for easy cards). One round.
**Branch**: `fix/352-drop-dead-help-keys` (base: `main`).
**Date**: 2026-08-23.

## What shipped

`lang-pack-drift` went red on `universal-till` `main` after merging
universal-till#459 (ut-docs#352), which removed 109 now-dead
`help.feat.*`/`help.features.*`/`help.guide.*` keys from
`web/locales/en.json` (kept `help.guide.title`/`help.guide.intro`, which
are still live). `locales/es.json` never had translations for these 109
keys — they were tracked as known, accepted debt in
`i18n-baseline/es.untranslated.txt`. With core no longer having them at
all, those 109 baseline entries are stale ("translated, or core dropped
them" — here, core dropped them), which `check-key-drift.sh` fails
unconditionally until pruned.

This PR removes the same 109 entries from
`i18n-baseline/es.untranslated.txt`, regenerated via
`scripts/check-key-drift.sh --update-baseline` (a pure shrink — the
baseline wasn't empty, so the script's `--allow-growth` guard against
reopening debt on an empty baseline doesn't apply here). `locales/es.json`
itself needs no change — it never carried these keys, so there's nothing
to remove there.

A companion PR in `ut-plugin-language-de`
(https://github.com/universaltill/ut-plugin-language-de/pull/new/fix/352-drop-dead-help-keys)
carries the equivalent fix (that pack *did* have real translations for
these 109 keys, so it removes them from `locales/de.json` plus prunes one
stale `i18n-baseline/de.same-as-en.txt` allowlist entry) — both are
required before ut-docs#352 is fully closed out; neither PR alone clears
`lang-pack-drift` on `universal-till`'s `main`, since the check evaluates
both packs.

## Verified beyond automated tests

- `git diff main -- locales/es.json` — empty; this file needed no change.
- `git diff main -- i18n-baseline/es.untranslated.txt` — exactly 109 lines
  removed, matching the exact key set core removed in universal-till#459,
  nothing else touched.
- `scripts/validate.sh` — `ok com.universaltill.language-es v1.1.3 (es)`.
- `scripts/check-key-drift.sh` — `ok -- 565/1510 core keys translated, 945
  known-untranslated (baseline), 8 known-same-as-English (allowlist), 0
  drift, 0 orphans, 0 empty values, 0 untranslated-present`.
- No real client/shop name, no secret-shaped literal, anywhere in the
  diff.

## Independent review

Fresh-context Sonnet subagent, briefed with the diff scope for both
`ut-plugin-language-de` and `ut-plugin-language-es` together (same root
cause, same fix pattern), this repo's `CLAUDE.md` (guard-script contract),
and universal-till PR #459's actual diff (the set of keys core removed).
Told explicitly to run the guard scripts itself rather than trust the
PR's own claims.

Findings:
- Re-ran `scripts/validate.sh` and `scripts/check-key-drift.sh`
  independently — clean.
- Confirmed `locales/es.json` has zero diff (correct — it never had these
  keys).
- Confirmed the 109 pruned `i18n-baseline/es.untranslated.txt` entries are
  byte-identical to the key set core removed in universal-till#459 — no
  extra, no missing.
- Confirmed no cross-language contamination (no German text in this
  pack's diff — there is no diff to `locales/es.json` at all).

**None blocking. No non-blocking findings either.**

## Safe-to-merge verdict

**Yes.** Minimal, mechanical, baseline-only diff; independently
re-verified guard-script results; correctly recognizes this pack never
carried real translations for the removed keys.
