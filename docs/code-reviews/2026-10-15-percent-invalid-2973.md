# Review — percent-field invalid message (es, ut-docs#2973)

**What:** the key core adds for ut-docs#2973 — `common.percent.invalid`, the
message a percent field (promotion percent, payment-fee percent, tax rates)
shows for an unparseable value, instead of the money message — translated,
plus the manifest version bump so the change ships.

**Checked:** wording mirrors this pack's own `common.money.invalid` (same
structure, "amount" → "percentage", example 7.5 / 7,25; names the two-decimal limit); `scripts/validate.sh`
passes; `scripts/check-key-drift.sh` against the core branch's `en.json`
reports 0 drift, 0 orphans; version bump present. The core change's review is
universal-till `docs/code-reviews/2026-10-15-percent-invalid-message-2973.md`.

**Verdict:** safe to merge once the core key is on universal-till `main`.
