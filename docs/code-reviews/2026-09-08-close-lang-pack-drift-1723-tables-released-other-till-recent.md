# Code review: translate tables.error.released_other_till_recent

- **Card:** universaltill/ut-docs#1723 — `universal-till` PR #908 (branch
  `fix/1723-free-table-cross-till-signal`) adds the new key
  `tables.error.released_other_till_recent` to core's
  `web/locales/en.json`, ahead of it landing on `main` (to avoid the
  `lang-pack-drift` push-to-`main` gate going red the moment it merges).
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context Sonnet subagent (small,
  mechanical single-key translation follow-up, same-day companion to the
  `ut-plugin-language-de` review of the identical key) — did not see the
  implementation reasoning, read the diff cold, ran the repo's own
  guards live.

## What shipped

`locales/es.json` gets one new key, inserted immediately after the
existing sibling `tables.error.release` and before
`tables.error.replica_use_primary` (alphabetical order this file already
follows in this region):

```
"tables.error.released_other_till_recent": "Mesa liberada, pero la marca pertenecía a otra caja vista recientemente — confirme con ella que ya no queda ningún pedido en espera antes de volver a sentar a alguien."
```

Formal **usted** register matches sibling `tables.error.*` keys in this
region ("reanúdelo", "complételo"); uses "caja" for till and "marca" for
the occupancy claim, both already established in this file's own
`tables.error.replica_use_primary` / `tables.error.held_order_attached`.

Neither the value nor any prefix of it is byte-identical to core's
English string, so no `i18n-baseline/es.same-as-en.txt` allowlist entry
is needed.

## Review findings

None (no must-fix) against this diff. The reviewer independently
confirmed:
- JSON valid, key present exactly once, correctly placed.
- Translation register/terminology matches sibling keys and this file's
  own established usage; conveys the same meaning as the English source.
- Not present in either baseline file (no stale entry to prune).
- `manifest.json` version unchanged (`v1.1.18`) — release/tag is a
  separate, later action.

One pre-existing, unrelated observation noted by the reviewer but **not**
a finding against this change: `tables.error.load_failed` elsewhere in
this file uses informal "Inténtalo" against the surrounding formal
register — a pre-existing inconsistency this diff doesn't touch or
introduce.

## Verified, live, not just read

- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.18 (es)`, exit 0.
- `UT_CORE_EN_JSON=<local universal-till checkout, branch
  fix/1723-free-table-cross-till-signal> bash scripts/check-key-drift.sh`
  — exit 0: `2063/2063 core keys translated, 0 known-untranslated
  (baseline), 32 known-same-as-English (allowlist), 0 drift, 0 orphans,
  0 empty values, 0 untranslated-present`. The new key is translated and
  accounted for.
- No real client/shop name, no secret-shaped literal.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`.

## Verdict

**Safe to merge.** Small, mechanical, fully guard-verified. Should land
before (or together with) `universal-till` PR #908 merging to `main`, so
`lang-pack-drift` doesn't go red on push.
