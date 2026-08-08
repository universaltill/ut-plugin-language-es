# Code review — close lang-pack drift (ut-docs#374)

**Date:** 2026-08-08
**Card:** universaltill/ut-docs#374 (p3, `complexity:hard`)
**Branch:** `fix/374-close-lang-pack-drift-es`
**Dev:** subagent, Fable (hard-tier build model)
**Reviewer:** independent subagent, Opus (hard-tier review model — deliberately
not Fable)

## What shipped

`universal-till`'s `lang-pack-drift` CI workflow had been red on `main` for
at least 3+ commits: this pack (an early, partial translation — ~170 of
core's ~1145 keys) had accumulated 58 new-drift keys not yet in its
accepted-debt baseline, plus one stale baseline line. Fixed:

- `locales/es.json`: 58 new keys translated for real (per this guard's own
  stated preference — "translating the new keys instead is preferred" —
  over just re-baselining them as more debt), taking coverage from 170 to
  229/1145. The pack's other ~916 already-accepted untranslated keys are
  deliberately untouched and out of scope for this card.
- `i18n-baseline/es.untranslated.txt`: pruned the stale `selforder.search_ph`
  line (core renamed this key to `products.search_ph`, one of the 58
  translated keys) plus, from the review round below, `tills.discovery.find_button`.
- `manifest.json`: `1.0.2` → `1.0.3` (patch).

Companion fix in the sibling `ut-plugin-language-de` repo (same card,
separate PR/review — see that repo's own `docs/code-reviews/` for the
German-side diff) closed the other half of the CI failure.

## Independent review (Opus, fresh context) — 0 blockers, 1 SHOULD-FIX + 1 NIT, both fixed

Full gate re-run and confirmed green: `scripts/validate.sh`,
`scripts/check-key-drift.test.sh` (14/14), `check-key-drift.sh` against a
local core checkout (**229/1145 translated, 916 baseline, 0 drift, 0
orphans, 0 empty values, 0 untranslated-present**), `scripts/package.sh`.
Diff hygiene confirmed: only `locales/es.json`, one line of
`i18n-baseline/es.untranslated.txt`, and `manifest.json` touched, no
existing translation altered, no secret-shaped values.

**This pack's `check-key-drift.sh` copy has no automated placeholder-token-
parity check** (unlike the `de` pack's — a known, tracked gap, ut-docs#312
covers unifying the two implementations, out of scope here). The reviewer
hand-verified all 6 token-bearing new keys individually — type, count, and
position all correct against the English source (notably
`import.status.stock_negative_quantity` correctly kept `%g`, not downgraded
to `%s`) — since the automated gate can't catch this on the ES side.

**SHOULD-FIX, fixed — `setup.join.discover_help` quoted a button label that
was still English on screen.** The new help text says to press
«Buscar una caja principal en esta red», but the button it names
(`tills.discovery.find_button`) was still sitting untranslated in the
baseline — a coherence regression introduced by this diff (before it, both
help text and button were English and agreed; the new translation made
them disagree). The `de` pack gets this right (its `find_button`
translation appears byte-identically inside its own `discover_help`).
Fixed: added `tills.discovery.find_button` translated to match the
`discover_help` string exactly, pruned from the baseline. Re-verified:
229/1145 (was 228), 916 baseline (was 917), gate still 0 drift/0
orphans/0 empty/0 untranslated-present.

**NIT, fixed — `catalog.error.barcode_conflict_unknown` over-specified the
conflict target.** The English source is deliberately vague (per
`universal-till/internal/pages/common/barcode_conflict.go:47-55`, this
fallback string covers a conflict target — item *or* variant — that
couldn't be resolved to a name); the ES translation asserted "en otro
artículo" (item), narrowing the meaning. Fixed to "en otro sitio",
matching the source's vagueness. Sibling key
`catalog.error.barcode_conflict` (which does take a resolved name via
`%s`) was already correct and untouched.

**Confirmed correct by the reviewer, no changes needed:** terminology
consistency against the pack's existing keys for every one of the 58 new
strings (till → `caja`, manager → `responsable` — byte-identical to the
existing `pfand.modal.manager_pin` sibling, `retirar efectivo` matching
`shifts.payout`/`shifts.amount_hint`); usted-register consistency
throughout (no tú/vosotros leakage); emoji/punctuation/em-dash preservation
verified codepoint-by-codepoint against the English source for every new
key; version bump semver-sane, matches this pack's own prior
patch-bump-for-content-addition precedent.

## Verification beyond the automated suite

- Live CI logs from the failing run
  (https://github.com/universaltill/universal-till/actions/runs/31239752673)
  used to derive the exact key list and confirm this is genuine drift.
- Reviewer independently re-ran the full gate and hand-verified both
  terminology *and* placeholder tokens (the latter uncovered by this pack's
  own guard script) against the real source and the pack's existing corpus.
- No UI/visible-surface driven-browser check performed for this pass — a
  real-but-accepted gap, same reasoning as the `de` pack's review: this is
  a 58-key incremental patch closing active CI drift, not a full-coverage
  milestone: the automated key-drift/empty-value gate plus by-hand token
  verification is the meaningful regression proof at this scope, and every
  new string was checked by eye for plausible length against its English
  source with no overflow risk flagged.

## Safe-to-merge verdict

Yes.
