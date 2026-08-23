# Code review — close lang-pack drift (demo_in_basket basket-locality keys)

**Date:** 2026-08-23
**Card:** universaltill/ut-docs#746 (p3, `complexity:medium`)
**Trigger:** companion fix, same cycle as `universal-till`'s
`fix/live-basket-guard-746` and the sibling `ut-plugin-language-de` fix —
core split `settings.data.demo_in_basket` into
`settings.data.demo_in_basket_cashier`/`settings.data.demo_in_basket_kiosk`.
Landed here in the same cycle to avoid the push-to-main-blocking
`lang-pack-drift` workflow going red once core's PR merges.
**Branch:** `fix/746-demo-in-basket-locality-keys`
**Dev:** inline (Sonnet, autonomous SDLC pipeline)
**Reviewer:** independent subagent, fresh-context Sonnet (easy-tier —
mechanical i18n key-sync fix, same class as this repo's own `#891`
precedent)

## What shipped

`locales/es.json`: replaced `settings.data.demo_in_basket` with two keys,
in the same position, translated:

- `settings.data.demo_in_basket_cashier` → "Hay datos de muestra en la
  cesta actual — vacíe la cesta primero." (unchanged text from the
  retired key)
- `settings.data.demo_in_basket_kiosk` → "Hay datos de muestra en la
  cesta del quiosco de autoservicio — vacíe primero la cesta del
  quiosco." ("quiosco de autoservicio" — this pack has no existing
  `mode_self_order`-equivalent key yet to match against, so this follows
  the same "self-service kiosk" sense core's English and the German
  pack's "Selbstbedienungs-Kiosk" both use.)

## Verification

- `scripts/validate.sh` — green: `ok com.universaltill.language-es v1.1.3 (es)`.
- `scripts/check-key-drift.sh` run against core's post-merge `en.json`
  (the `fix/live-basket-guard-746` working tree) — **560/1614 core keys
  translated, 1054 known-untranslated (pre-existing baseline debt, this
  pack is a partial pack), 8 known-same-as-English, 0 drift, 0 orphans, 0
  empty values, 0 untranslated-present, 0 token mismatches**. Neither new
  key added new drift; neither was already sitting in the baseline as
  known debt, so this is a real translation, not just a baseline entry
  removed.
- No placeholder tokens in either string.
- `i18n-baseline/es.untranslated.txt`/`es.same-as-en.txt` — confirmed
  neither the old nor the new keys were ever listed in either file.

## Independent review (fresh-context Sonnet) — 0 blockers, 0 nits

Re-ran `validate.sh` and `check-key-drift.sh` independently; confirmed
Spanish grammar and that "quiosco de autoservicio" reads naturally and
consistently with "Quiosco" (`settings.display.window_mode_kiosk`)
elsewhere in this pack; confirmed no mojibake by direct inspection;
confirmed the diff touches only `locales/es.json`, no secrets, no stray
files, no client names.

## Safe-to-merge verdict

Yes.
