# Review: Settings → Tills role-line keys (ut-docs#2782)

## What shipped
- Translations for the 3 keys core universal-till PR #2009 adds: `settings.tills.role_label`, `settings.tills.role_main`, `settings.tills.main_till_addr` (%s = main till's address).
- `settings.tills.register_label` follows core's new meaning ("Cash register for payouts").

- `manifest.json` patch version bump.

## Review
Independent review by a different model (Sonnet subagent). It found no major or minor issues and three nits on es/pt register-label wording. All three nits are accepted as is: the meaning is right and the labels match each pack's existing terms.

## Verified
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh`, run against core's branch `en.json`: 0 drift, 0 token mismatches.

## Verdict
Safe to merge after core #2009.
