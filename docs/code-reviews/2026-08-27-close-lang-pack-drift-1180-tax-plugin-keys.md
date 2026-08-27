# Code review: translate 4 new setup.tax_plugin.* keys

- **Card:** universaltill/ut-docs#1180 (closed by universal-till PR #586;
  this is the implied lang-pack follow-up, per the "own it explicitly"
  rule in the `scrum-master` skill — no separate board card)
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context general-purpose subagent (same
  session model tier — complexity:easy per the pipeline's model-routing
  rubric)

## What shipped

Core (`universal-till`'s `web/locales/en.json`) gained 4 new keys under
`setup.tax_plugin.*` (PR #586, "prompt to install the country tax plugin
(ADR-0025 D4)", closing ut-docs#1180). This pack tracks a large, deliberate
untranslated baseline (995 keys, ratchet mode — this pack does not claim
full parity), but a *new* key not yet in that baseline is still drift, and
this one wasn't: it was failing `lang-pack-drift`'s push-to-main check on
`universal-till` (confirmed: `universal-till`'s `main` had a red
`lang-pack-drift` run at 23:46:38Z for exactly this gap, head `5bc98c5`,
naming all 4 keys for both `de` and `es`). Added real Spanish translations
for all 4 keys rather than adding them to the baseline — the card is
Germany-specific but a Spanish-speaking operator can still reach this
wizard step if they select Germany as their shop's country, so the
strings are worth having translated, same reasoning as every other
`setup.*` key this pack already covers.

## Review findings

None (no must-fix). Confirmed independently by a fresh-context reviewer,
not just re-reading the diff:

- Diffed core's actual `web/locales/en.json` for the 4 new keys and
  confirmed the 4 keys added here are exactly the 4 new core keys — no
  more, no fewer, no typo'd key names (`setup.tax_plugin.description`,
  `.install_btn`, `.install_pending`, `.title`).
- `es.json` is valid JSON, alphabetical insertion correct (between
  `setup.shop_type.title` and `setup.till_name.default` — this pack has
  no `setup.store.*` translation yet, so the file skips directly from
  `shop_type` to the new `tax_plugin` block), no duplicate keys.
- `scripts/validate.sh` and `scripts/check-key-drift.sh` (run against a
  local `universal-till` checkout at `main`'s post-merge head `5bc98c5`,
  via `UT_CORE_EN_JSON`) both pass: 748/1743 core keys translated, 995
  known-untranslated (baseline, unchanged by this commit), 0 drift, 0
  orphans, 0 empty values, 0 token mismatches.
- Translation quality checked term-by-term against the pack's own
  existing vocabulary, not just checked for plausibility: `TSE` left
  untranslated (matches `fiscal.chip_ok`, `fiscalregister.col.tse_*`,
  `setup.tse.*`, `receipt.fiscal.tse.*` — all keep `TSE` as-is); `§12
  UStG` kept verbatim (same treatment as `fiscalregister.intro`'s `§146a
  Abs. 4 AO`); "dine-in/takeaway" → `"consumo en el local y para
  llevar"` matches `plugins.settings.takeaway.dine_in_rate` ("Tipo en el
  local") / `.rate` ("Tipo para llevar") exactly, not an invented
  phrasing; "Install" → `"Instalar"` matches
  `plugins.store.action.install` exactly; the `install_pending` phrasing
  ("Todavía instalando … en segundo plano") mirrors this pack's own
  `setup.language.install_pending` construction word-for-word in
  structure.
- No format tokens (`%s`/`%d`/…) in any of the 4 strings — nothing to
  drop/reorder, confirmed by the drift script's own token-mismatch check
  (0).
- Wording checked against core's own compliance-claims constraint
  (ADR-0040, `universal-till` CLAUDE.md): the English source describes a
  factual capability rather than a legal-outcome claim; the Spanish
  translation preserves that distinction — no certification/outcome
  wording introduced.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`, a real GitHub-linked
  human identity, not an AI-tool default.
- No real client/shop names, no secret-shaped literals.

## Verdict

**Safe to merge.** `manifest.json`'s version is not bumped in this
commit — this pack's own established convention (see the #1133-equivalent
review record in the `de` pack, same posture here) bumps/tags at publish
time, not in the content commit; noted here so the next release-tag pass
remembers one is owed.
