# Review: "Renew or change plan" panel keys (ut-docs#4286; core universal-till#1926)

**Shipped:** 15 new keys (`elevation.summary.subscription_panel`, `subscription.renew_open_btn`, `subscription.panel.*`). They are placed in en.json order. The manifest version is bumped.

**Review:** independent, Fable (translated by Opus 5.5). It checked:
- the meaning against core en.json, with nothing dropped or added;
- the `%s` placeholder (the plan name) kept;
- the same terms as the neighbouring `subscription.*` keys;
- the formal register;
- the quoted button in `poll_stopped` matches `subscription.check_now_btn` exactly, in this file's quote style;
- "Universal Till" left untranslated;
- the JSON is valid.

Result: approved as is.

**Checks:**
- `check-key-drift.sh` against #1926's en.json: 0 drift, 0 orphans.
- `validate.sh`: OK.
- The new version is not already tagged, and the branch is on current main.

**Verdict:** safe to merge after universal-till#1926.
