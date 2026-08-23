# lang-pack-drift red — 5 missing keys (tracking.*, selforder.confirm.qr_caption) — ut-docs#910

**Reviewer**: independent Sonnet subagent, fresh context (`complexity:easy`
— Sonnet built it, a fresh-context Sonnet instance reviewed it, per the
scrum-master skill's model routing exception for easy cards). One round.
**Branch**: `fix/910-tracking-selforder-qr-keys` (base: `main`).
**Date**: 2026-08-23.

## What shipped

`lang-pack-drift` went red on `universal-till` `main` after merging
universal-till#457 (ut-docs#527, customer order tracking QR), which added
5 new core keys to `web/locales/en.json`:

- `selforder.confirm.qr_caption`
- `tracking.disclosure`
- `tracking.not_found`
- `tracking.title`
- `tracking.updated`

Both `ut-plugin-language-de` and `ut-plugin-language-es` were missing all
5. This is the standard follow-up pattern for this check — see closed
precedents #862, #891, #783, #612, #494, #374, #441, #579, #296.

This PR (`ut-plugin-language-es`) adds Spanish translations for all 5 to
`locales/es.json`. `selforder.confirm.done/hint/receipt/title` remain
untranslated — pre-existing, accepted debt already tracked in
`i18n-baseline/es.untranslated.txt` — out of scope here, only the 5 keys
the ticket names were touched. No `i18n-baseline/` edit needed — none of
these 5 keys were previously listed as known debt (they didn't exist in
core before #457), so this is a pure addition, not a baseline prune.

A companion PR in `ut-plugin-language-de`
(https://github.com/universaltill/ut-plugin-language-de/pull/71) carries
the matching German translations — both are required before ut-docs#910
is fully done; neither PR alone closes it.

## Verified beyond automated tests

- `python3 -m json.tool locales/es.json` — valid JSON.
- `scripts/validate.sh` — `ok com.universaltill.language-es v1.1.3 (es)`.
- `scripts/check-key-drift.sh` — `ok -- 565/1619 core keys translated,
  1054 known-untranslated (baseline), 8 known-same-as-English
  (allowlist), 0 drift, 0 orphans, 0 empty values, 0
  untranslated-present`.
- `git diff main -- locales/es.json` — exactly 5 lines added, nothing
  else touched.
- `i18n-baseline/` unchanged (`git diff main -- i18n-baseline/` empty);
  confirmed `selforder.confirm.done/hint/receipt/title` remain correctly
  listed as pre-existing accepted debt (`i18n-baseline/es.untranslated.txt`
  lines 764-767) and correctly absent from `es.json`.
- No real client/shop name, no secret-shaped literal, anywhere in the
  diff.

## Independent review

Fresh-context Sonnet subagent, briefed with the diff scope, the repo's
own `CLAUDE.md` (guard-script contract), and the English source strings.
Told explicitly to run the guard scripts itself rather than trust the
PR's own claims, and to check translation quality (natural Spanish, not
machine-literal), em-dash/punctuation convention, and cross-language
contamination.

Findings:
- Re-ran `scripts/validate.sh` and `scripts/check-key-drift.sh`
  independently — clean.
- Confirmed the diff is exactly 5 added lines, no reordering, no
  unrelated key changes, no accidental translation of the out-of-scope
  `selforder.confirm.done/hint/receipt/title` debt.
- Confirmed translations are genuine, natural Spanish, consistent formal
  `usted` imperative register (`Escanee`), matching neighboring strings
  (e.g. `pida en el mostrador`).
- Confirmed correct em-dash usage matching source style.
- Noted the new keys land inside the pre-existing `orders.*` /
  `pos.toast`/`fiscal` blocks rather than alphabetically — verified this
  matches the file's existing organic ordering convention (`es.json` is
  not alphabetically sorted anywhere; 214 pre-existing out-of-order
  adjacent key pairs found), not a regression introduced by this PR.

**None blocking. No non-blocking findings either.**

## Safe-to-merge verdict

**Yes.** Small, self-contained, minimal diff; independently re-verified
guard-script results; no drift, no orphans, no cross-language
contamination; pre-existing untranslated debt correctly left untouched.
