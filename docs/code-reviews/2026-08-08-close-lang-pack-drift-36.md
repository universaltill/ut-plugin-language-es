# Code review — close lang-pack drift (universaltill/ut-docs#36)

**Date:** 2026-08-08
**Card:** universaltill/ut-docs#36 (p3, `complexity:easy`), closed via
`universal-till` PR #241 (`fix: i18n the multi-till join/pairing error
messages`)
**Branch:** `fix/close-lang-pack-drift-36`
**Dev:** inline (Sonnet — easy tier)
**Reviewer:** independent fresh-context Sonnet subagent

## What shipped

`universal-till`'s `lang-pack-drift` CI check went red on `main` right
after PR #241 merged: that PR added 8 new keys under `tills.join_error.*`
to core's `web/locales/en.json`, and this pack (a partial translation,
229/1153 keys before this change — its entire `tills.*` namespace,
including all of `tills.join*`, was previously in the accepted-debt
baseline) had no way to know about them yet. Fixed:

- `locales/es.json`: all 8 new keys translated for real — per this guard's
  own documented preference in this exact repo ("translating the new keys
  instead is preferred" over re-baselining, established at #374) — using
  vocabulary already established elsewhere in this pack (`caja` = till,
  `caja principal` = primary till, from `tills.discovery.find_button`/
  `tills.the_primary`/`sync.banner_open_primary_unavailable`; `no se pudo`
  = "could not", from `hold.error.failed`/`catalog.error.barcode_attach_failed`/
  `import.status.*`). Coverage moves from 229/1153 to 237/1153.
- `manifest.json`: `1.0.3` → `1.0.4` (patch, matching #374's own precedent).
- `i18n-baseline/es.untranslated.txt` deliberately untouched — these 8 keys
  never existed in core before PR #241, so they were never baseline
  entries to prune.

Companion fix in the sibling `ut-plugin-language-de` repo (same root
cause, separate PR/review — see that repo's own `docs/code-reviews/` for
the German-side diff, which restores that pack's full parity).

## Independent review (fresh-context Sonnet, easy tier) — 0 blockers

Full gate re-run and confirmed green: `scripts/validate.sh`,
`scripts/check-key-drift.sh` against a local core checkout (**237/1153
translated, 916 baseline, 0 drift, 0 orphans, 0 empty values, 0
untranslated-present**), `scripts/check-key-drift.test.sh` (14/14),
`scripts/package.sh`. Diff hygiene confirmed: only `locales/es.json` and
`manifest.json` touched, no existing translation altered, no secret-shaped
values, no duplicate JSON keys. Independently re-ran the drift check
against the pre-change tree (`git stash`) and confirmed the same 8 keys
report as new drift there — genuinely the CI-breaking gap, not a
false-positive on the check itself.

**This pack's `check-key-drift.sh` has no automated placeholder-token-parity
check** (a known, tracked gap shared with #374's own review, ut-docs#312
covers unifying the two implementations — out of scope here). Hand-verified
all 8 new keys individually against core's `en.json`: the 6 carrying a
`%s` in core (`not_a_till`, `request_failed`, `snapshot_failed`,
`stage_identity_failed`, `stage_snapshot_failed`, `unreachable`) each have
exactly one `%s` in the Spanish value, correctly positioned; the 2 without
(`bad_code`, `refused`) have no stray `%s`.

Terminology/register cross-checked against this pack's own existing
corpus: `caja`/`caja principal` consistent with `tills.discovery.find_button`;
the lowercase, no-trailing-period fragment style matches this pack's
existing error-key convention (`catalog.error.barcode_attach_failed`,
`import.status.*`) rather than the full-sentence-capitalized style used
elsewhere (`hold.error.failed`) — the right choice here since it mirrors
core's own lowercase-fragment English source for these 8 keys; inverted
`¿…?` correctly used in `refused`; formal `usted`-imperative (`pegue`,
`compruebe`) consistent with existing imperatives elsewhere in the pack; no
tú/vosotros leakage.

**No findings.**

## Verification beyond the automated suite

- Confirmed via a live gate run (and the pre-change `git stash` re-run
  above) that this is genuine drift, not a guard false-positive.
- No UI/visible-surface driven-browser check performed — same
  accepted-gap reasoning as #374's own review for this repo: an 8-key
  incremental patch closing active CI drift, not a full-coverage
  milestone; the automated key-drift/empty-value gate plus by-hand
  terminology/token verification (this pack's own script doesn't
  automate the token check) is the meaningful regression proof at this
  scope.

## Safe-to-merge verdict

Yes.
