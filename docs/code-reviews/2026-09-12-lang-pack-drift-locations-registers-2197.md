# Code review: `locations.*`/`registers.*` record_dialog keys (ut-docs#2197)

**Branch:** `fix/2197-lang-pack-drift`
**Author:** Farshid Mirza (pipeline, `lane:cloud-NN`*)
**Card:** universaltill/ut-docs#2197

\* this cycle's own routine prompt carried an unfilled template
placeholder for the lane id instead of a real one — see the cycle's
closing comment on the card for detail. Noted here only so a future
reader doesn't mistake it for a made-up label.

## What changed

Card ut-docs#2197 was filed after `ut-plugin-language-{de,es}`'s own
`scripts/check-key-drift.sh` was found failing against `universal-till`
main: core's Locations admin screen was ported to the shared
`record_dialog`/`list_header` UI pattern (ut-docs#2124,
universal-till#1129), and this pack was never updated to match.

**Scope widened during Dev, not just at pick-up.** By the time this cycle
picked the card up, `universal-till` main had *also* gained the identical
record_dialog port for the Registers admin screen
(`fix/2185-registers-record-dialog`, merged after ut-docs#2197 was filed)
— an independent, unrelated PR that introduced the exact same key shape
under `registers.*`. Fixing only the `locations.*` keys the card
literally listed would have left `check-key-drift.sh` — and this card's
own stated acceptance criterion ("`check-key-drift.sh` should report 0
drift against core's main afterward") — still failing. So this fix covers
both domains in one pass rather than filing a second follow-up card for
something already in scope of "make the drift check pass."

- `locales/es.json`: added `locations.{create,edit,empty,new,
  search_placeholder,deactivate_confirm}` and the identical six keys
  under `registers.*`, in strict alphabetical position. Removed the six
  now-orphaned old-dialog keys: `locations.{new.submit,new.title,rename}`
  and `registers.{new.submit,new.title,rename}` — confirmed absent from
  core's `en.json` (not merely stale-in-the-pack; core genuinely doesn't
  emit them any more, so this is not a regression).
- `manifest.json`: `1.1.59` → `1.1.60` (this repo's own rule — any PR
  touching a shipped file must bump the version, enforced by
  `scripts/check-version-bump.sh`).

## Translation decisions

Matched against `categories.*` — the closest existing sibling in the same
record_dialog key family (`create`/`edit`/`empty`/`new`/
`search_placeholder`/`deactivate_confirm`), already translated in this
pack:

- `locations.create` / `registers.create` → **"Crear ubicación"** /
  **"Crear caja"** — reuses the exact wording the now-removed
  `locations.new.submit` / `registers.new.submit` already had (same
  action, new key name only), so no new decision was actually needed here.
- `*.edit` → **"Editar ubicación"** / **"Editar caja"**, following
  `categories.edit` → "Editar categoría" ("Editar" + noun).
- `*.new` → **"Nueva ubicación"** / **"Nueva caja"** — again a direct
  carry-over of the removed `*.new.title` values.
- `*.search_placeholder` → **"Buscar ubicaciones"** / **"Buscar cajas"**,
  following `categories.search_placeholder` → "Buscar categorías"
  ("Buscar" + plural noun).
- `*.empty` → **"Aún no hay ubicaciones: pulse + para añadir una."** /
  **"Aún no hay cajas: pulse + para añadir una."**, following
  `categories.empty`'s exact template ("Aún no hay {plural}: pulse + para
  añadir {pronoun}."). Both "ubicación" and "caja" are feminine, so the
  object pronoun is "una" in both — same form `categories.empty` uses for
  the feminine "categoría".
- `*.deactivate_confirm` → **"¿Desactivar esta ubicación? Podrá
  reactivarla más tarde."** / **"¿Desactivar esta caja? Podrá reactivarla
  más tarde."** Modeled on `categories.deactivate_confirm` ("¿Desactivar
  esta categoría? Sus artículos conservan su asignación y podrá
  reactivarla más adelante.") but trimmed to match the *simpler* English
  source template shared by `locations`/`registers` ("Deactivate this X?
  You can reactivate it later." — no items-keep-their-assignment clause).
  Used "más tarde" (matching the simpler `catalog.delete_confirm_named`
  template's "later" → "más tarde") rather than `categories`' "más
  adelante" — both are standard and synonymous here, but "más tarde" is
  the closer match to this key's own, simpler English source. Both nouns
  feminine → "esta"/"reactivarla" throughout, same as `categories`'
  feminine "esta categoría"/"reactivarla".

## Verified

- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.60 (es)`.
- `UT_CORE_EN_JSON=<local universal-till>/web/locales/en.json bash
  scripts/check-key-drift.sh` — `ok -- 2362/2365 core keys translated,
  3 known-untranslated (baseline), 37 known-same-as-English (allowlist),
  0 drift, 0 orphans, 0 empty values, 0 untranslated-present, 0 token
  mismatches`.
- `bash scripts/check-version-bump.sh` — `ok: manifest.json version
  bumped 1.1.59 -> 1.1.60, covering: locales/es.json, manifest.json`.
- None of the 12 new keys appear in `i18n-baseline/es.untranslated.txt` or
  `i18n-baseline/es.same-as-en.txt` — brand-new translated keys, no
  baseline pruning owed.
- `git diff --stat` against `origin/main`: exactly `locales/es.json` and
  `manifest.json` touched, nothing else. Key count 2356 → 2362 (+12 added,
  −6 removed), still strictly alphabetically sorted, no duplicate keys.
- Did not additionally run core's `scripts/ci/check-lang-pack-drift.sh`
  (the raw-fetch-and-re-run-the-pack's-own-script proxy core CI uses) —
  that script fetches each pack's *pushed* `main`, which this unmerged
  branch isn't yet, and it invokes exactly the same
  `check-key-drift.sh` already run directly above against core's real,
  current `en.json`. Re-implementing its raw-fetch-override plumbing for
  this small, contained diff would verify the same thing a second way,
  not a different thing.

## Independent review

Reviewed by a fresh-context Sonnet subagent (per `complexity:easy`
routing), briefed to independently re-derive every added translation
against core's `en.json`, check grammatical gender agreement against the
`categories.*` precedent, confirm the six removed keys are genuinely
orphaned (not still emitted by core), re-run all four guard scripts
itself rather than trust this record, verify alphabetical key order and
literal (non-escaped) UTF-8, and check for collateral changes.

Verdict: **no blockers, no should-fix items, no nits.** It independently
confirmed feminine gender agreement on both new nouns ("esta
ubicación"/"reactivarla", "esta caja"/"reactivarla", "una" referring back
to the feminine noun), confirmed punctuation/tone match to
`categories.empty`'s template, re-ran
`check-key-drift.sh`/`validate.sh`/`check-version-bump.sh` and got
identical clean results, and confirmed via `git diff --name-only
origin/main` that only the two intended files changed.
