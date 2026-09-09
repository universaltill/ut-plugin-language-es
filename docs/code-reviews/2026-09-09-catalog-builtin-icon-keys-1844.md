# Code review: translate catalog.builtin_icon.* keys

**Date:** 2026-09-09
**Card:** ut-docs#1844
**Author:** scrum-master pipeline (cloud cycle, lane:cloud-54), on behalf of Farshid Mirza

## What changed

`universal-till`'s catalog image picker (ut-docs#1844) adds 10 new
`catalog.builtin_icon.*` keys to `web/locales/en.json` (a picker letting an
operator choose one of the 5 bundled category icons for an item, instead of
only an uploaded photo). This is the same-cycle language-pack follow-up
this ecosystem's `lang-pack-drift` convention requires: a core key addition
implies a translation here before `main` goes red.

- `locales/es.json`: all 10 keys translated into Spanish.

## Why no re-litigation

Mechanical translation pass following the established, guard-enforced
pattern this repo already runs (`scripts/check-key-drift.sh`) — not new
design.

## Verification performed

- `python3 -c "import json; json.load(...)"` — `locales/es.json` valid JSON.
- `scripts/validate.sh` — OK (JSON validity + non-empty string values).
- `scripts/check-key-drift.sh` against `UT_CORE_EN_JSON=<updated en.json
  from the ut-docs#1844 branch>`: **zero new drift** from this change (no
  Spanish value collided with English, unlike the German pack's
  `sandwich`/`Sandwich` case). The 5 `orders.view.*`/`pos.toast.receipt_*`
  missing keys and 1 `catalog.stock_untracked` orphan the check also
  reports are pre-existing, unrelated drift already tracked as
  ut-docs#1856/#1857.

## Independent review

Self-verified against this repo's own automated guards, proportionate to a
10-key single-file mechanical translation with deterministic correctness
criteria — same reasoning as the sibling `ut-plugin-language-de` PR for
this same card. The substantive feature review lives in `universal-till`'s
`docs/code-reviews/2026-09-09-catalog-image-picker-1844.md`.

## Non-goals confirmed out of scope

- Expanding the built-in icon set beyond the current 5 — split into
  ut-docs#1862. This pack will need a follow-up translation pass once
  that lands.

## Verdict

**Safe to merge.** Additive translations only; no existing key's value
changed.
