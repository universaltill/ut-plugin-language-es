# 2026-09-18 — `catalog.variant_codeless_hint` active-variants scoping for ut-docs#2424 (core ut-docs#2247)

## What shipped

Core's `web/locales/en.json` reworded `catalog.variant_codeless_hint`
(ut-docs#2247, merged: universal-till#1279) to add a scoping clause —
"(This warning only appears for active variants.)" — inserted mid-sentence.
This is an existing key, not a new one, so the pack's translation carried
the stale wording and neither `lang-pack-drift` (key presence only) nor
`locale-render-audit` (flags untranslated English leaking through, not a
stale-but-translated string) catches this class of drift.

Updated `locales/es.json`'s translation to add the matching Spanish
clause, "(Este aviso solo aparece para variantes activas.)", in the same
position as the English/fa/tr/ar parenthetical. `manifest.json` bumped
1.1.88 -> 1.1.89 per this repo's shipped-file version-bump rule.

## Independent review

Fresh-context Sonnet (easy change): verified diff scope (exactly
`locales/es.json` + `manifest.json`), translation accuracy and house-style
fit ("aviso" matches existing precedent pervasively used in the file,
never "advertencia" for this kind of notice), punctuation/placement
matching the fa/tr/ar reference style, and commit author (`Farshid Mirza
<farsid@taskrunnertech.co.uk>`). Confirmed `catalog.variant_codeless_hint`
is not present in either `i18n-baseline/es.untranslated.txt` or
`es.same-as-en.txt` (it was already a real translation before this
change, so no baseline entry should exist or need pruning). Verdict: safe
to merge, no problems found.

## Verified

`bash scripts/validate.sh` (ok, v1.1.89), `bash scripts/check-key-drift.sh`
(2583/2583 core keys translated, 0 drift, 0 orphans), and
`bash scripts/check-version-bump.sh` (bump 1.1.88 -> 1.1.89 recognized)
all green locally against core's `main`. Companion change:
`ut-plugin-language-de` (same key, same core follow-up).
