# Review: phone sale screen keys (ut-docs#3059)

**Shipped:** the 4 keys core added in universal-till#1520 (the phone sale
screen): `basket.phonebar.items`, `basket.sheet.close`, `nav.drawer.open`,
`nav.drawer.close`, translated into Spanish; manifest version bumped.

**Checked:** `scripts/validate.sh` and `scripts/check-key-drift.sh` against
core main c680861 (0 drift, 0 untranslated). Wording follows the pack's own
neighbours (`basket.title`, `nav.menu`, `categories.item_count`).

**Reviewer:** self-review. A four-string translation that follows existing
terms; the core feature had an independent Fable review
(universal-till docs/code-reviews/2026-09-29-phone-sale-screen.md).

**Verdict:** safe to merge.
