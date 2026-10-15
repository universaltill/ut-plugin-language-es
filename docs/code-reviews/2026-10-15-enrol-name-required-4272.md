# Review — settings.enrol.name_required (es, ut-docs#4272)

**What:** the key core adds in universaltill/universal-till#1939. Register now on a shop with no real name explains that the shop must be named first; the message is followed by a link to the Shop name card. This change translates it and bumps the manifest version so it ships.

**Checked:** an independent review (Sonnet; the translation is by Opus) found the wording consistent with this pack's `settings.enrol.*` terms and the `settings.store_name.title` card name, with the same register and nothing dropped. `scripts/validate.sh` passes. `scripts/check-key-drift.sh` passes against the core branch's en.json (0 drift, 0 orphans). The version bump is present. The core change's review is universal-till `docs/code-reviews/2026-10-15-register-requires-shop-name-4272.md`.

**Verdict:** safe to merge once core #1939 is on `main`.
