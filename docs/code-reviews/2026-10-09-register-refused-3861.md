# Review — settings.enrol.service_unavailable (ut-docs#3861)

**Change:** translates the new core key `settings.enrol.service_unavailable` from universaltill/universal-till (ut-docs#3861: when the cloud refuses a shop at registration, Settings → Till registration now shows a translated, neutral message instead of the raw `register returned 403: {json}` text). It also bumps `manifest.json`'s `version`.

**Review:** an independent Sonnet review checked meaning, neutrality (no country, no reason), terminology against the neighbouring `settings.enrol.*` / `settings.diagnostics.*` keys, punctuation and JSON validity. One fix applied: "negocio" → "tienda" to match the neighbouring keys.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against the core branch's `en.json` passes (3186/3186 keys, 0 drift).

**Merge order:** after the universal-till PR for ut-docs#3861; until then the key isn't in core's `main`.

**Re-cut (2026-10-09, lane:cloud-41 sweep):** merged `main` after the ut-docs#3978 pack release took this branch's version; bumped to 1.1.193. `check-key-drift.sh` against core `main` (now carrying the key, universal-till#1795): 3190/3190, 0 drift. `validate.sh` ok.
