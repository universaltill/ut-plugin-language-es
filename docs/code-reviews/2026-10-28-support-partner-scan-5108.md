# Review: help.support_partner.scan (ut-docs#5108)

**Date:** 2026-10-28 · **Lane:** lane:cloud-41 · **Author:** Opus 5.5 (translation) · **Reviewer:** Sonnet, fresh context

One new core key from universal-till#2199 (the till help's Support partner QR caption).
Screen names checked against my.'s own labels in ut-cloud `locales/` (`manage_app.node.partner`,
`manage_app.title`).

- Reviewer verdict: Fixed: tú → usted to match neighbouring help.*/subscription.panel.scan_* keys; screen names quoted with «…» like the rest of the file.
- `scripts/validate.sh` and `scripts/check-key-drift.sh` (against the PR branch's en.json): ok, 0 drift, 0 orphans.
- manifest version bumped so the change ships.

Safe to merge once universal-till#2199 is on main (until then the drift check calls the key an orphan).
