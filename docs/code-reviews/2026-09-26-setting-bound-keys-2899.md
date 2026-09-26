# Review — pack keys for setting-bound grants (ut-docs#2899)

4 new core keys `plugins.permissions.setting_bound{,_hint,_now,_not_set}` from universal-till#1407, translated by the cycle's model (Opus 5.5); reviewed by Sonnet against reference/translation.md and neighbouring plugins.permissions.* keys (de: formal Sie, Berechtigung/Einstellung — OK; es: one tú→usted fix applied, permiso/ajuste — OK). `scripts/validate.sh` + `scripts/check-key-drift.sh`: 2820/2820 core keys, 0 drift. Version bumped.

**Verdict:** safe to merge.
