# Review — pack keys for the cloud-link status row (ut-docs#2895)

20 new core keys `tills.cloud_link.*` from universal-till#1415, translated by the cycle's model (Opus 5.5); reviewed by Sonnet against reference/translation.md and neighbouring tills.* keys: formality, `%s` placeholders, terminology OK; one fix applied (hint_stopped: de 'registrieren' / es 'dar de alta' — the packs' existing re-enrolment terms). de: 'Live' added to the same-as-English allowlist (correct German, as on my.). validate.sh + check-key-drift.sh: 2840/2840 core keys, 0 drift. Version bumped.

**Verdict:** safe to merge.
