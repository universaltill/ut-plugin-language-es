# lang-pack-drift red — 15 missing keys (tender.status.*) — ut-docs#925

**Reviewer**: self-reviewed (`complexity:medium` card; mechanical
translation-sync follow-up to an already-independently-reviewed core
change, matching the standing pattern for this check — see this pack's
own precedent PR #70 and the parallel German-pack history).
**Branch**: `sync/925-split-tender-status-keys` (base: `main`).
**Date**: 2026-08-24.

## What shipped

`lang-pack-drift` went red on `universal-till`'s `main` after merging
universal-till#475 (ut-docs#925, the split-tender panel's own client-side
status copy hardcoded in English), which added 15 new core keys to
`web/locales/en.json` (the same 15 listed in the companion
`ut-plugin-language-de` review record for this same fix,
https://github.com/universaltill/ut-plugin-language-de/pull/78).

This was advisory-only on universal-till#475 itself (the PR touched
`en.json` but `lang-pack-drift` only warns on a PR) and correctly turned
blocking once merged to `main`.

This PR adds Spanish translations for all 15 to `locales/es.json`. This
pack does not carry exact parity with core (595/1547 keys translated, by
design — ADR-0010 falls back to English for anything untranslated), but
these 15 are brand-new core keys with no prior baseline entry, so adding
them here is a pure addition with no `i18n-baseline/` prune required.
`tender.status.added` carries two `%s` substitutions (method + amount);
`tender.status.change_note` and `tender.status.filled` carry one each —
counts verified to match core exactly (see below).

A companion PR in `ut-plugin-language-de`
(https://github.com/universaltill/ut-plugin-language-de/pull/78) carries
the matching German translations — both were required to fully close the
drift; neither alone would have.

## Verified beyond automated tests

- `python3 -c "import json; json.load(open('locales/es.json'))"` — valid JSON.
- `scripts/validate.sh` — `ok com.universaltill.language-es v1.1.3 (es)`.
- `UT_CORE_EN_JSON=<local checkout of universal-till's merged en.json>
  scripts/check-key-drift.sh` — `ok -- 595/1547 core keys translated, 952
  known-untranslated (baseline), 8 known-same-as-English (allowlist), 0
  drift, 0 orphans, 0 empty values, 0 untranslated-present` (exit 0) — no
  new baseline entries were needed or added for these 15 keys.
- Post-merge: re-ran `universal-till`'s own
  `scripts/ci/check-lang-pack-drift.sh` locally against this pack's new
  `main` HEAD (`fd55c42`) — `ut-plugin-language-es ok`.

## Outcome

Merged as `fd55c42`. `universal-till`'s `main` is back in sync (both packs
verified green against the merged core `en.json`).
