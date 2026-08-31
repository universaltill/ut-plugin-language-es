# Code review: translate the new `products.add` key

- **Card:** universaltill/ut-docs#1352 (implied lang-pack follow-up to
  universal-till PR #670 / ut-docs#1332 — the sale-screen left icon rail
  change, per the "own it explicitly" rule in the `scrum-master` skill;
  filed on the board so it's visible rather than only discoverable in a
  red push-CI run)
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context general-purpose subagent (same
  session model tier — `complexity:easy` per the pipeline's model-routing
  rubric)

## What shipped

Core (`universal-till`'s `web/locales/en.json`) gained one new key,
`products.add` ("Add product" — the catalog admin's `+ Add product` link),
in PR #670. This pack never translated it, which was failing
`lang-pack-drift`'s push-to-`main` check on `universal-till` since commit
`0798df4`. Added `"products.add": "Añadir producto"`.

## Review findings

None (no must-fix). Confirmed independently by a fresh-context reviewer,
not just re-reading the diff:

- Diffed core's actual `web/locales/en.json` and confirmed the key name
  added here is byte-exact (`products.add`), no typo, nothing else in
  core's file touched.
- `es.json` is valid JSON, alphabetical insertion correct (between
  `pos.toast.voucher_overtender` and `products.search_ph`), no duplicate
  keys (797 keys total).
- `scripts/validate.sh` and `scripts/check-key-drift.sh` (run against a
  local `universal-till` checkout at `main`, via `UT_CORE_EN_JSON`) both
  pass: 797/1800 core keys translated, 1003 known-untranslated
  (baseline), 15 known-same-as-English (allowlist), 0 drift, 0 orphans, 0
  empty values, 0 untranslated-present.
- `products.add` was not already in `i18n-baseline/es.untranslated.txt`
  (it's a brand-new core key), so no baseline-pruning was owed; confirmed
  the baseline files weren't touched.
- Translation checked against this pack's own established vocabulary, not
  just checked for plausibility: `"Añadir producto"` matches the pack's
  standing `Añadir <Object>` convention for add-actions (`designer.add`:
  "Añadir", `designer.add_button`: "Añadir botón", `tender.scan.add`:
  "Añadir") — idiomatic, correct as a catalog-admin action label.
- No format tokens (`%s`/`%d`/…) in the string.
- No compliance-outcome wording (ADR-0040 doesn't apply to this key
  anyway) — targeted grep near the new line found none.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`, a real GitHub-linked
  human identity, not an AI-tool default (`Co-Authored-By:` trailer is
  co-author attribution only).
- No real client/shop names, no secret-shaped literals — the entire diff
  is the one new locale line.

## Verdict

**Safe to merge.** `manifest.json`'s version is not bumped in this
commit — this pack's own established convention (see the `de` pack's
#1180 review record, same pattern applies here) bumps/tags at publish
time, not in the content commit; noted here so the next release-tag pass
remembers one is owed.
