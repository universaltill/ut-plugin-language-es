# Review — pack keys for the visual effects level (ut-docs#2859)

14 new core keys `settings.display.effects*` from universal-till#1420 (per-till Auto/Full/Balanced/Light, ADR-0119), translated by the cycle's model (Opus 5.5); reviewed by Fable against reference/translation.md, neighbouring settings.display.* keys and the help topic: `%d` placeholders, till terminology, quote style OK; one fix applied (effects_help: 'una Raspberry Pi', matching the pack's existing gender for the device). 'Raspberry Pi' and the ', ' separator added to the same-as-English allowlist (deliberate). validate.sh + check-key-drift.sh: 2854/2854 core keys, 0 drift. Version bumped.

**Verdict:** safe to merge.
