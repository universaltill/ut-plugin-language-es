# Code review: translate catalog.error.item_replica_use_primary

- **Card:** universaltill/ut-docs#1689 — `universal-till` PR #854 gates
  item/variant/barcode catalog mutations behind `requirePrimary` and adds
  the new key `catalog.error.item_replica_use_primary` to core's
  `web/locales/en.json`, ahead of it landing on `main` (to avoid the
  `lang-pack-drift` push-to-`main` gate going red the moment it merges).
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context Sonnet subagent (small,
  mechanical single-key translation follow-up — reviewed at Sonnet per
  the `ut-plugin-language-de` sibling repo's 2026-09-05 #1585-replica-keys
  precedent) — did not see the implementation reasoning, read the diff
  cold, ran the repo's own guards live.

## What shipped

`locales/es.json` gets one new key, inserted immediately after the
existing sibling `catalog.error.replica_use_primary`:

```
"catalog.error.item_replica_use_primary": "Esta caja sigue a una caja principal — administre el catálogo en la caja principal."
```

Matches the sibling key's exact register (formal "administre", identical
lead clause `Esta caja sigue a una caja principal`) and uses "catálogo"
— the term already used consistently elsewhere in this file
(`import.view_catalog`, `plugins.store.catalog_error`).

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
  separate, later action, per the `ut-plugin-language-de` sibling repo's
  established precedent.

**Incidental finding, NOT caused by this commit (out of scope, new
Backlog card filed separately):** `locales/es.json` already carries two
pre-existing duplicate key pairs —
`kitchenstations.error.replica_use_primary` (lines 292/294) and
`tables.error.replica_use_primary` (lines 788/790) — confirmed by diff
inspection to predate this change (this commit is a single `+1` line).

## Verified, live, not just read

- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.18 (es)`, exit 0.
- `UT_CORE_EN_JSON=<local universal-till checkout> bash scripts/check-key-drift.sh`
  — exit 1, but the reported gap is exclusively the 3 pre-existing
  `sync.quarantine_reason.*` keys tracked separately as ut-docs#1695;
  the new key does **not** appear in the missing-keys output.
- No real client/shop name, no secret-shaped literal.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`.

## Verdict

**Safe to merge.** Small, mechanical, fully guard-verified. Should land
before (or together with) `universal-till` PR #854 merging to `main`, so
`lang-pack-drift` doesn't go red on push.
