# Review: pair-replace confirm keys (es) — ut-docs#3557

**What shipped.** Three new core keys for universal-till's new confirm
dialog before a registered till is re-paired (Settings → Till registration
→ "Pair with a shop"): `settings.enrol.pair_replace_title`,
`settings.enrol.pair_replace_body` (two `%s`: shop name, then the typed
pairing code) and `settings.enrol.pair_replace_confirm`. Manifest version
bumped.

**Review.** Independent reviewer on a different model from the author.
Verdict: approve, no findings. Checked: accuracy against the English, two
`%s` in source order with grammar that holds for any shop name, terms
matching this pack's existing `settings.enrol.*` and
`elevation.summary.enrol_pair` wording, register, no compliance claims,
`scripts/validate.sh` ok.

**CI expectation.** `key-drift` against core `main` reports the 17 keys
that were already missing there (`agent.*`, `catalog.missing.*` from
ut-docs#4128/#4129, `settings.staff_links.*` from #3208). Until the core
PR merges, it also lists these three keys as not in core. Against the core
branch, only the 17 pre-existing keys are reported. Merge after the core
PR, once pack `main` is green.
