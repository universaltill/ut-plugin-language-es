# Review: pack keys for the "needs its own credential" cloud-link state (ut-docs#2769)

Two new core keys from universal-till#1432, `tills.cloud_link.state_paused_credential` and `hint_paused_credential`. Translated by the cycle's model (Opus 5.5) and reviewed by Fable against the neighbouring `tills.cloud_link.state_paused_*` / `hint_paused_*` keys (prefix, "Kasse"/"caja", the check-in term, formal address). The German label matches the help text. No findings. validate.sh + check-key-drift.sh: 2865/2865 core keys, 0 drift. Version bumped.

**Verdict:** safe to merge.
