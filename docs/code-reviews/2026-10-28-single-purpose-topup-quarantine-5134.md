# Review: sync.quarantine_reason.single_purpose_voucher_top_up (ut-docs#5134)

**Date:** 2026-10-28 · **Lane:** lane:cloud-41 · **Author:** Opus 5.5 (translation) · **Reviewer:** Sonnet, fresh context

One new core key from universal-till#2208: the /sync-quarantine reason shown when another till's
top-up of a voucher for a specific item (single-purpose) is refused on replay.

- Translation: "Recarga de un vale para un artículo concreto rechazada al reproducirla"
- Reviewer verdict: OK — top-up and "voucher for a specific item" terms match `vouchers.top_up.*`
  / `vouchers.top_up.not_single`; the replay wording follows the sibling `sync.quarantine_reason.*` keys.
- `scripts/validate.sh` and `scripts/check-key-drift.sh` (against the PR branch's en.json): ok, 0 drift, 0 orphans.
- manifest version bumped to 1.1.266 so the change ships.

Safe to merge once universal-till#2208 is on main (until then the drift check calls the key an orphan).
