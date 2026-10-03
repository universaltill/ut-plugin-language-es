# Review: joined-device report keys (ut-docs#3291)

- Date: 2026-10-02 · Lane: lane:cloud-24 · Author: Opus 5.5 · Reviewer: Sonnet 5 (independent)
- Core change: universaltill/universal-till#1649

Two new core keys are translated:
`issuereport.status.pending_reason.joined_awaiting_credential` and
`issuereport.status.failing_reason.joined_no_access`. The manifest version
is bumped.

Checks: `check-key-drift.sh` passes against the #1649 branch's
`en.json` (0 drift, 0 orphans), and `validate.sh` passes.

Review: no findings. Meaning, terminology and formality all match the
existing keys. One optional nit was accepted: the "joined to the shop"
wording is slightly literal but understandable.
