# Review: four agent.* keys for the settings tools (ut-docs#4129)

- Branch: feat/4129-agent-settings-keys. Author: Sonnet 5.5; reviewed together with the core
  change (universal-till docs/code-reviews/2026-10-31-ai-settings-tools-4129.md, Opus 5.5
  subagent).
- Adds agent.action.settings_set, agent.field.setting, agent.value.on, agent.value.off
  (confirm-card words for a settings change) and bumps manifest.json.
- Short UI labels, no placeholders; terminology checked against the neighbouring agent.* keys.
- Brand-new core keys: merge the core PR first; the drift guard calls them orphans until then.
- Verdict: safe to merge after the core PR. Not run on a device.
