# Review — gift voucher keys (ut-docs#4214)

**Shipped:** 20 new keys for the gift voucher item type (universal-till#1882),
translated; 16 obsolete `tender.issue_voucher.*` / `tender.status.voucher_*`
keys removed (the Split-tab "Sell a voucher" block was deleted in core); any
baseline entries for removed keys pruned; manifest version bumped.

**Reviewer:** independent Sonnet subagent (translated by Opus 5.5): meaning, POS
wording, the pack's existing voucher terminology, formal address, placeholders,
and that no removed key is referenced elsewhere in the pack. Verdict OK to ship.
Applied its polish: de "geben Sie … ein" and "… enthalten"; pt "Vale-oferta"
(matches the pack's "Cartão-oferta"; "ler" kept for scanning, the normal pt-PT
verb).

**Verified:** `scripts/validate.sh` ok; `check-key-drift.sh` against core's
PR branch: 3253/3253 keys, 0 drift, 0 orphans, 0 token mismatches.

**Merge order:** after universal-till#1882 (until then core main lacks the keys).
