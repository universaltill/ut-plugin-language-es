# Review: ICU plural count keys (ut-docs#4480) — 1.1.268

**What:** translates the two new core MessageFormat keys
`categories.item_count_plural` and `products.category_button_count_plural`
(universal-till#2218), placed after their old `%d` keys, which stay.
Manifest bumped to 1.1.268.

**Review:** independent Sonnet review (author: Opus). Grammar and term
consistency with the old keys, CLDR categories, ICU syntax (`other`
present, argument `count` unchanged), +1 patch bump, JSON validity: no
blocking finding. Accepted: Spanish CLDR `many` (round millions, "de
artículos") falls back to `other` — a till never shows such a count;
Portuguese keeps a defensive `=0` branch (pt vs pt-PT `one` rules differ).

**Verified:** `scripts/validate.sh` and `scripts/check-key-drift.sh`
against the core branch's en.json pass; every value formatted with the
till's `internal/msgfmt` for 0/1/2/5 renders the expected form.

**Verdict:** safe to merge after universal-till#2218.
