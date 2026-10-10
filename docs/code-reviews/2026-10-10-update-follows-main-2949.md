# Code review — "follows the main till's version" keys (ut-docs#2949)

- **Date:** 2026-10-10
- **Lane:** `lane:cloud-41`

## What shipped

- Translations of the 2 new core keys from universaltill/universal-till#1825:
  - `settings.update.follows_main`
  - `settings.update.follows_main_unknown`
- A manifest version bump.

## Review

- An independent Fable review checked each string against the English, the `%s` placeholder, and the file's existing "main till" term and register.
- es: the first draft used tú ("Cambia"); the file's `settings.*` keys use usted (`settings.error.change_on_main_till` = "Cambie este ajuste en la caja principal."). Fixed to "Cambie" before commit.

## Verified

- `scripts/validate.sh` passes.
- `scripts/check-version-bump.sh` passes.
- `scripts/check-key-drift.sh` against core `main` (after universal-till#1825 merged) passes: 0 drift.
- Rebased onto the ut-docs#4042 pack merge; the version bump moved up one.

## Verdict

Safe to merge after universal-till#1825.
