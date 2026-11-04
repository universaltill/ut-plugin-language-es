# Review: Reports → Online channels keys (ut-docs#5427)

**Date:** 2026-11-04 · **Lane:** lane:cloud-54 · **Core change:** universal-till#2333

## What shipped
- The 13 new core keys `reports.tab.online_channels` and `reports.online_channels.*` (Reports →
  Online channels tab), translated into this pack's language.
- `elevation.summary.reduce_line_qty`, which core added earlier (ut-docs#5411) and this pack lacked.
- `manifest.json` patch version bump.
- es/pt only: `reports.online_channels.currency_total` ("Total") is allowlisted in
  `i18n-baseline/*.same-as-en.txt`, because it is the correct word in this language.

## Review
- Drafted by Opus. Reviewed independently by Sonnet, and before that as part of the core review (Opus).
- Checked and fine:
  - ICU plural syntax.
  - `%s` count and order.
  - Consistency with this pack's existing terms (refunds, online orders, web shop, fiscal journal).
  - "Order value" / "After refunds" do not read as gross/net of tax.
- Findings, all fixed in this change:
  - es (medium): the notice used informal "tu"; the pack uses "su".
  - de (low): the notice now uses the pack's "Kassenschublade" and "Z-Bericht".
  - pt (low): `reduce_line_qty` uses "(%s)" instead of "como %s", because the reason labels are verbs.
- `scripts/validate.sh` and `scripts/check-key-drift.sh` pass against core en.json with #2333 applied.

**Verdict:** approve.
