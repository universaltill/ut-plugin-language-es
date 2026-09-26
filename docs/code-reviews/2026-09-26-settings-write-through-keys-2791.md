# Review — pack keys for the settings write-through (ut-docs#2791)

3 new core keys `settings.error.{main_till_refused,main_till_unreachable,change_on_main_till}` from universal-till#1427, translated by the cycle's model (Opus 5.5). Reviewed by Sonnet against reference/translation.md and the neighbouring `users.error.main_till_unreachable` / `sync.main_till_unreachable` / `settings.*` keys:
- de: formal Sie, Hauptkasse / Einstellung — OK.
- es: usted, caja principal / ajuste — OK.

`scripts/validate.sh` + `scripts/check-key-drift.sh` against the PR's en.json: 2857/2857 core keys, 0 drift. Version bumped ("version": "1.1.123").

**Verdict:** safe to merge once universal-till#1427 is on main.
