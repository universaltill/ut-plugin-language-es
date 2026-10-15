# Review — `plugin.chat.*` keys (ut-docs#4132)

**Shipped:** the 8 new core keys for the plugin-view `chat` component (transcript, question box, thinking bubble, tool chips, screen-reader "you/assistant" labels), translated into this pack. Pairs with the universal-till PR for ut-docs#4132. Version bumped to 1.1.224.

**Review:** checked against `reference/translation.md`: the `%s` placeholder in `plugin.chat.used_tool` is kept, nothing is dropped, and the wording uses the formal "usted" register, matching the pack ("Enviar", "Haga una pregunta…"). `scripts/validate.sh` passes; `scripts/check-key-drift.sh` against the core branch reports no drift.

**Verdict:** safe to merge once the core PR is on `main`.
