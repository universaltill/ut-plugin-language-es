# Code review — tables/floor-plan keys (close lang-pack drift)

**Date:** 2026-08-19
**Trigger:** `universal-till` PR #394 (`ut-docs#814`, table map / floor-plan
designer) merged to `main` and added 34 new `tables.*` keys to
`web/locales/en.json`. The `lang-pack-drift` workflow is blocking on push to
`main` per this ecosystem's standing rule (`universal-till/CLAUDE.md`), and
has been RED on `main` since 07:29 UTC because neither language pack carried
the new keys — expected on the merge itself, but it was left red rather than
fixed in the merging cycle, which is the deviation this change closes.
**Branch:** `feat/814-tables-keys`
**Dev:** inline (local interactive session — a same-session "don't leave
`main` red" fix, not a separately-picked backlog card)
**Reviewer:** self-reviewed inline — proportionate to scope (34 keys, no
logic, fix shape identical to the several prior `close-lang-pack-drift-*`
records in this same directory). The substantive review risk here is
translation *quality*, not code, and that is addressed by the explicit
checks below rather than by a second model re-reading a diff of string
literals.

## What shipped

- `locales/es.json`: +34 `tables.*` keys, inserted at the same relative slot
  core's `en.json` uses (immediately after `kitchenstations.error.routes`),
  469 → 503 keys. This pack is NOT at full parity with core (503/1520, a
  large pre-existing backlog tracked in `i18n-baseline/es.untranslated.txt`);
  fixing that backlog is explicitly out of scope — only the 34 keys the
  drift check named were added.
- `i18n-baseline/es.same-as-en.txt`: +`tables.status.open_minutes`. Its value
  (`%d min`) is genuinely byte-identical in Spanish, so it belongs in the
  deliberate allowlist rather than tripping the untranslated-value guard.
  File re-sorted, as `check-key-drift.sh` requires.
- `manifest.json`: `1.1.1` → `1.1.2` (patch), per this repo's convention.

## Translation provenance

Produced on the **self-hosted homelab model** — Ollama `qwen3:30b-a3b` at
`192.168.1.231:11434`, per `ut-docs/reference/translation.md`. **No paid AI
API was used**, which is a standing product rule that covers build-time
tooling, not only what ships.

Two of that doc's four documented failure modes were hit for real and are
worth recording:

1. **The model ignored `"think": false`** and streamed its full chain of
   thought as message content, terminated by a `</think>` marker, with the
   answer JSON after it. Handled by extracting the last parseable balanced
   JSON object rather than trusting the whole response body.
2. **Two concurrent requests to the single-model server serialise**, and the
   first one issued (German) produced nothing for ~15 minutes while the
   second completed. Not a hang — the client accumulates the stream and only
   writes at the end — but worth knowing before assuming a stuck job.

## Verification

- `scripts/validate.sh` — green (JSON valid; every value a non-empty string,
  which is what stops core's `syncLocales` silently dropping the whole file).
- `scripts/check-key-drift.sh` (with `UT_CORE_EN_JSON` pointed at the local
  core checkout) — green: **503/1520 translated, 1017 known-untranslated
  (baseline), 8 known-same-as-English (allowlist), 0 drift, 0 orphans,
  0 empty values, 0 untranslated-present.**
- Placeholder integrity checked programmatically, not by eye: `%d` is present
  in exactly the two keys core has it in (`tables.seats_n`,
  `tables.status.open_minutes`) and in no others.
- **One real translation defect found and fixed by review, not by a guard:**
  the model returned `tables.edit.hint` in the informal *tú* register
  (`"Arrastra una mesa..."`) while every one of its siblings — and the
  existing `kitchenstations.*` block — uses formal *usted* (`"Elija"`,
  `"cambie"`, `"añada"`, `"inténtelo"`). Worse, that same string then mixed
  registers internally (`tú` imperative + `usted` possessive). Corrected to
  `"Arrastre una mesa para moverla — su posición se guarda automáticamente."`
  No guard in this repo can catch a register inconsistency; only reading it
  can.

## Not verified

- Not rendered in a running till. The keys are consumed by
  `universal-till`'s `/tables` page, which this repo cannot exercise; core's
  own `guard-i18n.sh` and its handler tests cover the render path, and this
  pack is an asset-only overlay (ADR-0010).
- Spanish wording has not been read by a native speaker. It is machine
  translation, reviewed for register/placeholder/terminology correctness by
  the same session that produced it — an honest limitation shared by every
  prior record in this directory, not a new one.

## Safe-to-merge verdict

Safe to merge. Companion fix for the German pack lands in its own repo (same
trigger, separate PR/review) — **both are required for `universal-till`'s
`main` to go green**; merging this one alone leaves `lang-pack-drift` red.
