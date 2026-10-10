# Review — plugins.settings.ai.image_model_unsupported (ut-docs#4042)

**Change:** translates the core key `plugins.settings.ai.image_model_unsupported` added by universaltill/universal-till#1817 (ut-docs#3126): the AI settings page's notice that a background-removal model is not on the allow-list, so background removal stays off. Bumps `manifest.json`'s `version` to 1.1.194.

**Review:** an independent Sonnet review (author: Opus 5.5) checked meaning against the English, register and terminology against the neighbouring `plugins.settings.ai.*` key and the file's existing words for "background"/"off", that both model ids stay literal, JSON validity, placement and the version bump. No findings.

**Verified:**
- `scripts/validate.sh` and `scripts/check-key-drift.test.sh` pass.
- `scripts/check-key-drift.sh` against core `main`'s `en.json` passes: 3192/3192 keys, 0 drift.

**Ported line:** this PR also carries `plugins.permissions.desc.view_users`, copied verbatim from this pack's #408 (ut-docs#3976, reviewed in that lane). Core `main` already has that key, but #408 is waiting on a human merge. Without the port, this PR's `key-drift` stays red on that key, and #408's stays red on this one, so neither could go green on its own. Once this PR merges, #408's locale line is already on `main`.
