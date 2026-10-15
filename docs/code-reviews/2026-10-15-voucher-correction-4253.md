# Review — gift voucher balance correction keys (es, ut-docs#4253)

**What:** the 19 keys core adds for the manager balance correction on the voucher
detail page (`vouchers.adjust.*`, `vouchers.history.type.adjustment`,
`vouchers.history.by`) translated, plus the manifest version bump so the change ships.

**Checked:** wording reuses this pack's own voucher terms (`vouchers.title`,
`vouchers.status.void`, the main-till term from `catalog.sync.main_till_refused`);
`%s` kept in `vouchers.history.by`; `scripts/validate.sh` and
`scripts/check-key-drift.sh` against the core branch's `en.json` pass (0 drift,
0 orphans, 0 token mismatches); version bump present. The core change's independent
review is universal-till `docs/code-reviews/2026-10-15-voucher-balance-correction-4253.md`.

**Verdict:** safe to merge once the core PR is on `main`.
