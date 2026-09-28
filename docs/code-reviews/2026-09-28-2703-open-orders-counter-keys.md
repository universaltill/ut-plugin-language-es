# Review: es keys for Open orders tabs + removed Pay at counter page (ut-docs#2703, #3096)

**Date:** 2026-09-28 · **Lane:** lane:local · **Translated by:** Claude Opus 5.5 (build-time, #2291) · **Checked by:** orchestrator against reference/translation.md

## Change
- +8 `open_orders.*` keys from core universal-till#1507 (tab labels, count label, h/d ages, empty state, "priced when opened", add-by-hand notice).
- −12 keys of the deleted /kiosk-counter-orders page (`kiosk_counter_orders.*`, `nav.kiosk_counter_orders`, `page.title.pay_at_counter`), same as core, so no orphans remain.
- +`setup.error.store_name_required` (core #1499 / ut-docs#3096): lang-pack drift was red on main without it.
- `open_orders.age_hours` / `age_days` ("%d h" / "%d d") added to `es.same-as-en.txt` via `check-key-drift.sh --update-allowlist`: the abbreviations are genuinely the same in Spanish.

## Checks
- Placeholders preserved (`%d`, `%s`); no English left; product names untouched.
- Terminology matches this pack's existing strings: the counter tab reuses the pack's own wording for "pay at the counter" ("Pagar en el mostrador"); receipt wording follows `receipt.title` (ticket).
- `scripts/check-key-drift.sh` against core main: 0 drift, 0 orphans, 0 untranslated-present.

**Verdict:** safe to merge.
