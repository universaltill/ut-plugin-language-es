# Review: AI-agent confirm card keys (ut-docs#2838), v1.1.208

Adds core's 18 new `agent.*` keys (the confirm card for AI-proposed
changes, universal-till#1868), placed before `ai.identify.button`.

Checked: `%s`/`%d` placeholders match English, key for key; terminology
matches this pack's existing strings (stock/catalogue, Cancel);
the confirm button's `%s` stays a count; `scripts/check-key-drift.sh`
passes against core main. Manifest version bumped. Verdict: safe to merge.
