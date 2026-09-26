# Review: pack key for the restart-pending update status (ut-docs#2759)

New core key `status.update_restart_pending` from universal-till#1424 (Linux updates prove the new binary runs before switching). Translated by the cycle's model (Opus 5.5) and reviewed by Fable against the neighbouring `status.update_*` keys. German: "es" replaced with "das Update" so the one-glance status line names its subject. Spanish: OK as written; the review also found two neighbours (`status.update_failed`, `status.update_installed_reload`) using tú in a file that is otherwise usted, and both were aligned to usted. validate.sh + check-key-drift.sh: 2857/2857 core keys, 0 drift. Version bumped.

**Verdict:** safe to merge.
