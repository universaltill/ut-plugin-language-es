# Review: tills.discovery.denied (ut-docs#3218)

**Change:** one new key in `locales/es.json` (the iOS Local Network refusal
message added by universal-till#1606) and a patch version bump.

**Reviewer:** independent model (not the author), 2026-10-02.

**Findings (both fixed in this PR):**
1. Blocker: the string used tú ("permítelo", "activa", "introduce"), but every
   other `tills.*` key uses usted ("escriba", "espere", "vuelva a intentarlo").
   Fixed by rewriting it in usted form.
2. Minor: "instead" was dropped. Fixed by adding "en su lugar".

Checked clean: "Red local" and "Ajustes" match Apple's Spanish iOS labels;
"código de emparejamiento" is the pack's existing term (`tills.join_code`,
`setup.join.help`); «…» quotes match pack convention.

**Checks:** `scripts/validate.sh` passes; `scripts/check-key-drift.sh` shows no
drift for this key against core `main` after universal-till#1606.
