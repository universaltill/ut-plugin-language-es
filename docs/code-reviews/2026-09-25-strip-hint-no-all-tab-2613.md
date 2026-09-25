# Review: strip browsing-mode hint drops the All tab (ut-docs#2613)

- **Change:** `settings.sell_screen.browsing_mode_strip_overflow_hint` is reworded. Core
  universal-till#1350 removes the All tab from the "Category strip with quick
  buttons" sell-screen mode, so the hint no longer says "an All tab first".
  `manifest.json` gets a patch bump so the change ships (ut-docs#1940).
- **Review:** covered by the core independent review, which checked the
  translation's meaning: universal-till
  `docs/code-reviews/2026-09-24-strip-no-all-tab-2613.md`.
- **Verified:** `scripts/validate.sh` and `scripts/check-key-drift.sh` pass. The
  key set is unchanged, so there is no drift.
- **Verdict:** safe to merge.
