# Review: stale quick-button toast (ut-docs#2525)

- **Change:** adds the new core key `pos.toast.tile_stale_refreshed`. Core
  universal-till (branch `fix/2525-stale-tile-refresh`) shows it when a tapped
  sale-screen tile no longer resolves because the catalog changed elsewhere;
  the grid then refreshes itself. `manifest.json` gets a patch bump so the
  change ships (ut-docs#1940).
- **Review:** covered by the core independent review, which also checked the
  translations: universal-till
  `docs/code-reviews/2026-09-25-stale-tile-refresh-2525.md`.
- **Verified:** `scripts/validate.sh` and `scripts/check-key-drift.sh` (run
  against the core branch's en.json) pass: every core key is translated, with 0 drift.
- **Verdict:** safe to merge once the core PR is on `main`.
