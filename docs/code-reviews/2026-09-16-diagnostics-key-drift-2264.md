# 2026-09-16 — Diagnostics key drift (ut-docs#2264)

## What shipped

Translated the 26 core keys for the remote diagnostics-mode feature
(`diagnostics.chip_label`, `diagnostics.chip_title`, and 24
`settings.diagnostics.*` keys) into Spanish in `locales/es.json`, and
bumped `manifest.json`'s version `1.1.65` → `1.1.66`.

These 26 keys had no Spanish translation and no `i18n-baseline/`
entry, which is *new, unaccounted-for drift* — not a legitimate
ratcheted gap — and had been failing `scripts/check-key-drift.sh` on
the last two release attempts (`v1.1.64`, `v1.1.65`), silently
blocking `auto-tag-release.yml` from ever reaching
`Publish to marketplace`.

## Independent review

Sonnet subagent, fresh context (card is `complexity:easy`, so a
fresh-context Sonnet instance is the mapped review tier — see
`scrum-master` skill's "Model routing by complexity"). Verdict: **safe
to merge as-is, no blockers, no should-fix issues.**

Findings:
- One nit (non-blocking): `settings.diagnostics.activated`'s Spanish
  translation ("ya está activado" / "is already on") is idiomatic
  rather than maximally literal ("ahora está activado") — judged fine
  as-is, no change made.

What it verified, beyond reading the diff:
- Actually ran `scripts/validate.sh` and `scripts/check-key-drift.sh`
  — 0 drift, 0 orphans, 0 empty values, 0 untranslated-present, 0
  token mismatches, both before this review and independently
  cross-checked against the pre-fix state.
- Confirmed diff scope is exactly `locales/es.json` +
  `manifest.json`, no unrelated reordering.
- Confirmed all 26 keys match `universal-till/web/locales/en.json`
  1:1, no missing/extra keys.
- Confirmed `%s`/`%d` placeholder order/count matches English for
  every key that has one (`ended_remotely`, `on_since`,
  `pending_count`, `stop_confirm`, `stopped`).
- Checked terminology consistency against existing strings already in
  `es.json` (caja/soporte/registrar usage, "credenciales" matching the
  pack's existing singular "credencial"), formal *usted*-register
  throughout, correct grammatical gender on the dangling pronoun in
  `on_explain`.
- No secret-shaped literals or real client/shop names introduced (N/A
  for this diff, confirmed).

## TDD-style verification (done independently, twice — by Dev and by Reviewer)

`scripts/check-key-drift.sh` run against the pre-fix `locales/es.json`
(via `git stash`) fails, listing exactly these 26 keys as new drift.
Run again post-fix, it passes clean. Re-confirmed by the review
subagent independently.

## Verified beyond automated tests

- `scripts/validate.sh`, `scripts/check-key-drift.sh`,
  `scripts/check-key-drift.test.sh`,
  `scripts/check-version-bump.sh`/`.test.sh` all run locally, all
  green.
- CI (`ci.yml`, `commit-attribution.yml`) green on the PR's head SHA.

## Safe to merge

Yes. Merged via `merge_method: "merge"` (never squash/rebase — see
`reviewer` skill's "Merge method" note, ut-docs#250).

## Deferred / out of scope

- A companion PR in `ut-plugin-language-de` (#268) covers the German
  half of the same card.
- ut-docs#2264's own "worth checking whether any other
  `ut-plugin-language-*` pack has the same silent-release-block shape"
  item is not covered by this PR — noted as a possible follow-up, not
  actioned here (out of scope for this specific 26-key drift; would
  need its own investigation across the other packs).
- Confirming `auto-tag-release.yml` actually reaches
  `Publish to marketplace` post-merge is a DevOps-phase follow-up, not
  part of this review.

PR: https://github.com/universaltill/ut-plugin-language-es/pull/269
