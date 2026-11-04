# Review record: channel order action keys (ut-docs#4768)

Follow-up of universaltill/universal-till#2328 (till actions on online orders). Adds the 66 keys core
added (65 `channel_orders.*` plus `elevation.summary.reduce_line_qty` from an earlier core change),
removes the orphan `channel_orders.detail.actions_note`, bumps `manifest.json`.

Translated by Sonnet; independent Opus review checked meaning against en and `en.meta.json`,
placeholders (`%s` order kept), `max_length` (chips ≤ 32, buttons ≤ 40), and terminology against the
pack's existing `channel_orders.*` strings. Fixes made in review (de: verb position in
`reduce_line_qty`, cancel reason "Stornierung auf Kundenwunsch"; es/pt: `pending_short.ship` read as
"shipment not sent").

Checks: `scripts/validate.sh` pass; `UT_CORE_EN_JSON=<core branch en.json> scripts/check-key-drift.sh`
3910/3910, 0 drift/orphans/token mismatches. Merge after universal-till#2328 (its `key-drift` check
here stays red until then).

Verdict: ship after the core PR merges.
