# Review — inventory.empty wording (ut-docs#3901)

Core changed the meaning-bearing text of the existing key `inventory.empty`
(universal-till fix/3901-inventory-empty-wording): the Inventory table's
empty row now shows only when the shop has no stock-tracked items, and says
what to do next. This pack's translation is updated to match, quoting this
pack's own `nav.catalog` and `catalog.stock_untracked` labels in the formal
register; `manifest.json` version bumped so it ships.

Reviewed independently (Sonnet subagent, Opus authored) together with the
core change: label quotes exact, register correct, `validate.sh` green. No
findings for this pack. `check-key-drift.sh` fails only on three unrelated
keys covered by the open ut-docs#5162 pack PR. Full record:
universal-till `docs/code-reviews/2026-10-29-inventory-empty-wording-3901.md`.

Verdict: safe to merge.
