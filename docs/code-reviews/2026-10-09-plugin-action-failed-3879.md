# Review — plugin.view.action_failed (ut-docs#3879)

**Change:** translates the new core key `plugin.view.action_failed` from universaltill/universal-till#1776 (a failed plugin view action keeps the operator's input). It also bumps `manifest.json`'s `version` (re-bumped after rebasing onto `main`, which took the previous patch number for #3940/#3243).

**Review:** an independent Sonnet review checked meaning, register (matching the neighbouring `plugin.view.*`/`plugin.job.*` keys), dash/punctuation conventions and JSON validity. No issues.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against universal-till#1776's `en.json` passes: 3185/3185 keys, 0 drift.
- `scripts/check-version-bump.sh` passes.

**Merge order:** after universal-till#1776; until then the key isn't in core's `main`.
