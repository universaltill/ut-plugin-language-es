# Review: pack keys for "an additional till follows its main till" (ut-docs#2738)

Core universal-till#1426 added `sync.link.update_following[_hint]` and `sync.link.update_manual[_hint]` and removed `sync.link.update_waiting`. The same change is made here: 4 keys translated by the cycle's model (Opus 5.5), the obsolete key removed. Reviewed by Fable against the neighbouring `sync.link.*` keys, `nav.settings` + `settings.update.title` (the Settings path in the hint matches the UI exactly) and the formal address form. All four keys OK, `%s` kept, and the chip text is short enough for the 1024px status bar. validate.sh + check-key-drift.sh: 2860/2860 core keys, 0 drift. Version bumped.

**Verdict:** safe to merge.
