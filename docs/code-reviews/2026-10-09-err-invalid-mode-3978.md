# Review — settings.display.err_invalid_mode (ut-docs#3978)

**Change:** translates the new core key `settings.display.err_invalid_mode` from universaltill/universal-till#1793 (a refused device-profile save now shows a translated message instead of a raw server body). Bumps `manifest.json`'s `version` to 1.1.192 (re-bumped after rebasing onto `main`, which took 1.1.191 for the #3121 disk-low keys).

**Review:** an independent Sonnet review checked meaning, formal register (matching the neighbouring `err_*` keys), that the three option names match this pack's `settings.display.mode_*` labels, and punctuation. No issues.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against universal-till#1793's `en.json` passes: 3187/3187 keys, 0 drift.

**Merge order:** after universal-till#1793; until then the key isn't in core's `main`.
