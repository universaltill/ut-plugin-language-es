# Review: `selforder.exit` names leaving kiosk mode (ut-docs#3362)

Date: 2026-11-02 · Lane: lane:cloud-41 · Reviewer: independent subagent, different model from the author

## What shipped

Core (ut-docs#3136) changed the **value** of `selforder.exit` — the aria-label
of the lock link on every self-order screen — to "Exit kiosk mode (PIN
required)", because the link now takes the till out of kiosk mode and lands
on the sale screen, not Settings. `lang-pack-drift` checks keys only, so the
old wording stayed in this pack.

- `selforder.exit`: "Salir a los ajustes de la caja (hace falta el PIN)" → "Salir del modo quiosco (hace falta el PIN)"
- `manifest.json` version 1.1.274 → 1.1.275 (shipped file changed)

## Findings

- None blocking or major.
- Wording checked against core en/tr meaning and this pack's existing terms
  for kiosk mode and PIN prompts; consistent.
- No other `selforder.*` value in this pack still points at Settings.
- Nit (out of scope): `key-drift` is red on `main` for 17 core keys
  (`agent.*`, `catalog.missing.*`, `settings.staff_links.*`) from core
  merges under ut-docs#4128 / #4129 / #3208. Its output is byte-identical
  with and without this change. Their pack PRs are tracked on those cards.

## Verified

- `scripts/validate.sh` passes; JSON parses, no duplicate keys.
- `scripts/check-key-drift.test.sh` and `scripts/check-version-bump.test.sh` pass.
- `check-key-drift.sh` against core `main` en.json: same 17 pre-existing keys
  before and after; `selforder.exit` is not in either baseline file.
- Diff is two files, one line each; version is one patch step.

## Verdict

Safe to merge.
