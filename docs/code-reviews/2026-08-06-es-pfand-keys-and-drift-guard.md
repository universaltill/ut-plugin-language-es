# 2026-08-06 — Spanish `pfand.*` keys + ratcheting key-drift guard

Card: [ut-docs#296](https://github.com/universaltill/ut-docs/issues/296)
Branch: `fix/296-es-pfand-keys-and-drift-guard`
Prior art: [ut-docs#292](https://github.com/universaltill/ut-docs/issues/292)
(`ut-plugin-language-de`, `docs/code-reviews/2026-08-05-de-pfand-keys-and-drift-guard.md`)

## What shipped

1. The 6 `pfand.*` keys in `locales/es.json` — 164 → 170 keys.
2. `scripts/check-key-drift.sh` — the same ratcheting parity guard #292
   built for the German pack, ported to Spanish: run on PR, on a weekly
   schedule (staggered from `de`'s: Tue 03:23 UTC vs Mon 03:17 UTC), on
   `workflow_dispatch`, and in `release.yml`.
3. `scripts/check-key-drift.test.sh` — the same 14 self-tests, ported.
4. `i18n-baseline/es.untranslated.txt` (918 keys) and
   `i18n-baseline/es.same-as-en.txt` (6 keys) — accepted-debt ledgers,
   mechanically generated via `--update-baseline` / `--update-allowlist`
   against core's real `web/locales/en.json` (1088 keys).
5. `scripts/validate.sh` — ported the non-string/empty-value rejection
   #292 added (core's `syncLocales` drops the whole file on one bad
   value).
6. manifest 1.0.1 → 1.0.2; overclaiming description ("translates the full
   till interface") corrected to the same honest wording #292 used;
   README + CLAUDE.md updated.

## Translations

| key | value | rationale |
|---|---|---|
| `pfand.action` / `pfand.modal.title` | Devolución de depósito | Standard Spanish term for a deposit-return scheme (cf. Spain's SDDR — Sistema de Depósito, Devolución y Retorno). |
| `pfand.modal.amount` | Importe | Matches this pack's existing `shifts.amount` convention. |
| `pfand.modal.cancel` | Cancelar | Matches `plugins.install.modal.cancel`. |
| `pfand.modal.confirm` | Abonar | See "Independent review" below — first draft used "Pagar", changed after review. |
| `pfand.modal.manager_pin` | PIN del responsable | See "Independent review" below — first draft used "PIN de gerente", changed after review. |

## Why the bug happened

Same root cause as #292: ADR-0010 makes a language pack an overlay, and
core's `I18n.T()` resolves `es → es → en → en`. This pack sat at the
identical 164-key coverage the pre-fix German pack had, including the
same missing `pfand.*` keys, discovered while working #292 rather than
from a live incident.

## Verification

Driven run, real till binary (not `go run`, built and run from a fresh
temp data dir per the e2e suite's own convention — avoids the legacy-DB
CWD trap `e2e/run-till.sh` documents), throwaway `UT_DATA_DIR`, the
pack's real `locales/es.json` seeded via a temporary tool mirroring
`e2e/seed_faq`'s pattern (inserts into `plugin_catalog`/`plugins`, drops
the real locale file under `<data>/plugins/<id>/<version>/locales/`, so
`internal/plugins.Manager.syncLocales` picks it up exactly like a real
install — not a mocked route). The tool was written under
`e2e/seed_lang_verify/`, used, and deleted — not part of this repo's
shipped diff or `universal-till`'s.

| pack seeded | `GET /?lang=es`, `#pfand-modal-title` + `kiosk-pfand-open` button |
|---|---|
| pre-fix, `git show main:locales/es.json` | "Deposit refund" — bug reproduced |
| working tree (170 keys, first-draft translations) | "Devolución de depósito" / Importe / PIN de gerente / Cancelar / Pagar |
| working tree (170 keys, post-review translations) | "Devolución de depósito" / Importe / PIN del responsable / Cancelar / Abonar |

The pre-fix pass is the negative control: the same locator returns
English when the keys are absent, so the assertion is not a tautology.
Re-ran after the review's translation fixes to confirm the final strings
actually render, not just parse.

Guard self-tests: 14/14 pass. Guard run against the real core `en.json`:
`ok -- 170/1088 core keys translated, 918 known-untranslated (baseline),
6 known-same-as-English (allowlist), 0 drift, 0 orphans, 0 empty values,
0 untranslated-present`. `scripts/package.sh` output confirmed to contain
only `manifest.json`, `locales/es.json`, `README.md`, `LICENSE` —
`i18n-baseline/` correctly excluded from the shipped artifact.

## Independent review (Opus, fresh context) — no blockers, 9 findings

Fixed in this branch:

- **`pfand.modal.confirm` = "Pagar" collided with this pack's own
  `tender.tab.pay` = "Pagar"** — same word for two opposite cash-flow
  directions (customer paying the till vs. the till paying out a
  deposit) in one locale file. Changed to **Abonar**.
- **"PIN de gerente" set a manager-term precedent conflicting with the
  pack's existing usage** — `plugins.store.filtered_note` /
  `plugins.store.empty` already use "responsable" for a manager-type
  role; four other `*.manager_pin` keys are still in the baseline and
  would have inherited whichever term landed first. Changed to
  **PIN del responsable** for consistency.
- **Stale hardcoded key counts in `check-key-drift.sh`'s header comment**
  ("170 of core's 1087 keys", "917 untranslated") — copied verbatim from
  `de` and already wrong (core is now 1088 keys). This is exactly the
  overclaim class #292's own review flagged and fixed in the README;
  the script's comment was missed there and inherited here. Reworded to
  not hardcode a count that goes stale on core's next commit.
- **`if: always()` was on the wrong CI step** — it sat on the *first*
  step (self-tests), which runs unconditionally anyway since nothing
  precedes it; the comment's stated intent (both results visible even if
  one fails) requires it on the *second* step (the drift check), so a
  self-test regression doesn't hide the drift result. Moved.
- **README's package-contents claim omitted `LICENSE`** — the shipped
  tarball includes it; the sentence made a deliberately precise claim
  about what reaches a customer till and was wrong. Corrected.
- **"identical 164-key gap" was ambiguous** (reads as "a gap of 164
  keys" rather than "164 keys translated, ~924-key gap") — reworded in
  the script header and README to state plainly that 164 was the
  pre-fix *translated* count, not the gap size.
- **Dangling doc pointers** — CLAUDE.md, README.md and the script header
  all said "see ut-docs#296's PR / code-review record" before this
  record existed and before this repo had a `docs/` directory at all.
  Now point at this file (`docs/code-reviews/2026-08-06-...md`) and at
  ut-docs#312 (the deferred cross-repo-generalization card) specifically,
  rather than a document that didn't exist.

Deferred, judged genuinely cosmetic and already present in
`ut-plugin-language-de`'s copy (not introduced here, and fixing only one
of two copies would desync them ahead of ut-docs#312's planned
unification):

- A non-string locale value crashes `check-key-drift.sh`'s Python block
  with a raw traceback instead of a clean message (still exits non-zero,
  so no silent-pass risk — `validate.sh`, which runs in a separate CI
  job, already reports this cleanly).
- `--update-baseline` / `--update-allowlist` throw `FileNotFoundError`
  if the target file doesn't exist yet (only matters when bootstrapping
  a brand-new pack repo — worked around here by pre-creating empty files
  before the first run).

## Generalising vs. copy-pasting (card AC #3)

Per #296's own acceptance criteria, generalizing the guard into one
shared cross-repo implementation was considered. Scoping it fully —
extracting a shared implementation *and* retrofitting
`ut-plugin-language-de`'s already-shipped, tagged, in-production copy to
consume it — would turn this medium, single-repo card into a cross-repo
architecture change needing its own review cycle (retrofitting `de` risks
regressing a repo this card has no reason to touch). **Chose: ship a
second per-repo copy again, same as #292 → this card, and open
[ut-docs#312](https://github.com/universaltill/ut-docs/issues/312) to do
the actual extraction** (weighing a reusable `workflow_call`, a
canonical-script-fetched-at-CI-time model mirroring how this script
already fetches core's `en.json`, or a versioned tool artifact) as its
own scoped, reviewed piece of work — before a third language-pack repo
would mean a third copy.

## Not done

No e2e test was added to `universal-till` for Spanish rendering, same
reasoning as #292: it would need a **copied** `es.json` fixture, which
would pass even if this pack regressed. This repo's own drift guard is
the regression gate; the rendering path itself is covered by
`faq.spec.ts` and `rtl.spec.ts` in `universal-till`.
