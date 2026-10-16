# Review — plugins.settings.ai.image_endpoint_invalid (ut-docs#4095)

**Change:** translates the core key `plugins.settings.ai.image_endpoint_invalid` added by universaltill/universal-till#1981 (ut-docs#4095): the AI settings page's hint that the `image_endpoint` value is not a valid http(s) address, so the till ignores it and keeps its built-in background removal. Bumps `manifest.json`'s `version` to 1.1.230.

**Review:** an independent Sonnet review (author: Opus 5.5) checked meaning against the English, register and terminology against the neighbouring `plugins.settings.ai.*` keys and the file's existing words for "till" and "background removal", that the URL literals stay unchanged, JSON validity and the version bump. No defects; no findings.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against the core PR branch's `en.json` passes: 3373/3373 keys, 0 drift.
