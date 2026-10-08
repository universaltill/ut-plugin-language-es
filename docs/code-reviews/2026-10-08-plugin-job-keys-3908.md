# Review — plugin job keys (ut-docs#3908)

**Change:** translates the 4 new core keys from universaltill/universal-till#1756 (plugin jobs, ADR-0121 §8): `plugin.job.busy`, `plugin.job.gone`, `plugin.job.refresh`, `plugin.job.running`. It also bumps `manifest.json`'s `version`.

**Review:** an independent Sonnet review checked meaning, register (matching the rest of the file), terminology, punctuation conventions and JSON validity. It found no issues.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh`, run against the branch's `en.json`, passes: 3172/3172 keys, 0 drift.

**Merge order:** merge after universal-till#1756. Until then the new keys don't exist in core's `main`.
