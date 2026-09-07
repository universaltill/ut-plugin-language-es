# Code review: translate import.error.replica_use_primary

- **Card:** universaltill/ut-docs#1696 — `universal-till` PR #855 gates
  bulk catalog import behind `requirePrimary` and adds the new key
  `import.error.replica_use_primary` to core's `web/locales/en.json`,
  ahead of it landing on `main` (to avoid the `lang-pack-drift`
  push-to-`main` gate going red the moment it merges).
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** self-reviewed via the repo's own guards (mechanical
  single-key translation, same pattern as the same-day #1667/#1689/#1697
  precedents in this directory) — `check-key-drift.sh` run against
  core's `fix/1696-import-requireprimary-gate` branch (which already
  carries the merged key, ahead of `main`).

## What shipped

`locales/es.json` gets one new key, inserted immediately after the
existing sibling `import.error.already_in_progress`:

```
"import.error.replica_use_primary": "Esta caja sigue a una caja principal — importe los catálogos en la caja principal."
```

Matches every other `*.error.replica_use_primary` sibling's exact
register (identical lead clause "Esta caja sigue a una caja principal —
... en la caja principal.") and uses "importe los catálogos" (import the
catalogs) as the verb+object pair, mirroring core's English string's own
choice of "import catalogs" over a generic "administre" (manage) verb
— the same way `plugins.install.error.replica_use_primary` uses
"instale" and `plugins.uninstall.error.replica_use_primary` uses "elimine"
rather than the more common "administre".

Neither the value nor any prefix of it is byte-identical to core's
English string, so no `i18n-baseline/es.same-as-en.txt` allowlist entry
is needed.

## Verified

- `python3 -c "import json; json.load(open('locales/es.json'))"` — valid.
- `scripts/validate.sh`: `ok com.universaltill.language-es v1.1.18 (es)`.
- `scripts/check-key-drift.sh` (`UT_CORE_EN_JSON=<local universal-till
  checkout's fix/1696-import-requireprimary-gate branch>`, since core
  hasn't merged PR #855 to `main` yet): `2000/2000 core keys translated,
  0 drift, 0 orphans, 0 empty values`.
- Confirmed the default (against-`main`) run of `check-key-drift.sh`
  currently reports this key as an orphan, as expected — it clears once
  universal-till#855 merges to `main`; this is the same merge-order
  dependency every prior `*.replica_use_primary` translation PR in this
  pack has carried (see PR body's "Merge order note").

## Safe to merge

Yes, after universal-till#855 (core) merges to `main` first — merging
this PR before that would make `check-key-drift.sh` report an orphan key
on `main`. No blocking findings.
