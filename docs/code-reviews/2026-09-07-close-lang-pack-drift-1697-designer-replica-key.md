# Code review: translate designer.error.replica_use_primary

- **Card:** universaltill/ut-docs#1697 — `universal-till` PR #856 gates
  the Till Designer's reorder/add/remove mutations behind
  `requirePrimary` and adds the new key
  `designer.error.replica_use_primary` to core's `web/locales/en.json`,
  ahead of it landing on `main` (to avoid the `lang-pack-drift`
  push-to-`main` gate going red the moment it merges).
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context Sonnet subagent (small,
  mechanical single-key translation follow-up — reviewed at Sonnet per
  the same-day #1689-catalog-item-key precedent in this same directory)
  — did not see the implementation reasoning, read the diff cold, ran
  the repo's own guards live.

## What shipped

`locales/es.json` gets one new key, inserted immediately before the
existing sibling `designer.error.server`:

```
"designer.error.replica_use_primary": "Esta caja sigue a una caja principal — administre los botones de venta rápida en la caja principal."
```

Matches every other `*.error.replica_use_primary` sibling's exact
register and lead clause ("Esta caja sigue a una caja principal —
administre ... en la caja principal.") and uses "botones de venta
rápida" (quick-sale buttons), matching core's English string's choice of
"quick-sale buttons" rather than the plainer "shortcut buttons" it could
have used instead.

Neither the value nor any prefix of it is byte-identical to core's
English string, so no `i18n-baseline/es.same-as-en.txt` allowlist entry
is needed.

## Review findings

None (no must-fix) for this key. The reviewer independently confirmed:
- JSON valid, key present exactly once, correctly placed.
- Translation register/terminology matches sibling keys and this file's
  own established usage.
- Not present in either baseline file (no stale entry to prune).
- `manifest.json` version unchanged (`v1.1.18`) — release/tag is a
  separate, later action, per this directory's own established
  precedent.

## Verified, live, not just read

- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.18 (es)`, exit 0.
- `UT_CORE_EN_JSON=<local universal-till checkout, branch
  fix/1697-buttons-requireprimary-gate> bash scripts/check-key-drift.sh`
  — exit 0: `1999/1999 core keys translated, 0 known-untranslated
  (baseline), 31 known-same-as-English (allowlist), 0 drift, 0 orphans,
  0 empty values, 0 untranslated-present`. The new key is translated and
  accounted for.
- No real client/shop name, no secret-shaped literal.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`.

## Verdict

**Safe to merge.** Small, mechanical, fully guard-verified. Should land
before (or together with) `universal-till` PR #856 merging to `main`, so
`lang-pack-drift` doesn't go red on push.
