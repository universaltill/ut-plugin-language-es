# Review — es AI provider notice (ut-docs#2835)

**Date:** 2026-10-11 · **Author:** Opus 5.5 (lane:sdk) · **Reviewer:** Fable (independent subagent)

Part of the ut-docs#2835 change set. ut-plugin-integration-ai 2.3.0 adds the
Claude Ask tool loop and `provider = openai_compatible`
(ut-plugin-integration-ai#17; full record:
`ut-plugin-integration-ai/docs/code-reviews/2026-10-11-claude-ask-openai-compatible-2835.md`).

## What changed here

- `plugins.settings.ai.hosted_provider_notice` in `locales/es.json` brought in line with core (claude or openai, Ask for both, openai_compatible); patch version bump.

## Review

The Fable reviewer read this copy against the plugin code. It found:
meaning parity with the English (hosted = claude or openai, Ask now covered
for both, the openai_compatible sentence present), no placeholders, product
names untouched, and none of the old "with claude nothing is sent for Ask"
claim left. No findings on this repo's diff.

## Verified

`scripts/validate.sh`; `scripts/check-key-drift.sh` against the core branch's en.json: 0 drift.

**Verdict:** safe to merge.
