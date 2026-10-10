# Review — plugins.settings.ai.image_model_unsupported (ut-docs#4042)

**Change:** translates the core key `plugins.settings.ai.image_model_unsupported` added by universaltill/universal-till#1817 (ut-docs#3126): the AI settings page's notice that a background-removal model is not on the allow-list, so background removal stays off. Bumps `manifest.json`'s `version` to 1.1.194.

**Review:** an independent Sonnet review (author: Opus 5.5) checked meaning against the English, register and terminology against the neighbouring `plugins.settings.ai.*` key and the file's existing words for "background"/"off", that both model ids stay literal, JSON validity, placement and the version bump. No findings.

**Verified:**
- `scripts/validate.sh` and `scripts/check-key-drift.test.sh` pass.
- `scripts/check-key-drift.sh` against core `main`'s `en.json` no longer lists this key. The only remaining drift is `plugins.permissions.desc.view_users`, which this pack's open ut-docs#3976 PR adds. Against `en.json` without that key the guard passes: 3191/3191 keys, 0 drift.

**Merge order:** independent of the #3976 pack PR; whichever merges second needs a version re-bump.
