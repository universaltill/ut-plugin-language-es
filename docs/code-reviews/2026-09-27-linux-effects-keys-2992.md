# Review: pack keys for Auto effects → Light on Linux (ut-docs#2992)

Core universal-till#1454 changed `settings.display.effects_help` (Auto also picks Light "on Linux") and added `settings.display.effects_reason_webkitgtk` ("WebKitGTK"). Help sentence updated by the cycle's model (Opus 5.5); the new key is a product name, kept as-is and added to the same-as-English allowlist (regenerated with `check-key-drift.sh --update-allowlist`). Reviewed by Fable against English and the neighbouring `effects_*` keys: meaning exact, idiomatic preposition, quote style and level names consistent. No findings. validate.sh + check-key-drift.sh: 2866/2866 core keys, 0 drift. Version bumped.

**Verdict:** safe to merge.
