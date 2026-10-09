# Review — settings.display.err_invalid_mode (ut-docs#3978)

**Change:** translates the new core key `settings.display.err_invalid_mode` from universaltill/universal-till (ut-docs#3978: an invalid device-profile POST is now a translated, `X-UT-Response: refused` message instead of an English developer string). It also bumps `manifest.json`'s `version`.

**Review:** an independent Sonnet review checked meaning, register (matching `settings.retention.err_invalid_mode` and the `settings.display.mode*` terms), punctuation and JSON validity. No issues.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against the core branch's `en.json` passes (3186/3186 keys, 0 drift).

**Merge order:** after the universal-till PR for ut-docs#3978; until then the key isn't in core's `main`.
