# Code review: translate import.status.sku_reused_in_file; bump to 1.1.11

- **Card:** universaltill/ut-docs#1236 (blocked on repo access from a
  prior cloud cycle — this cycle has `ut-plugin-language-es` attached and
  picks it up directly). Surfaced while investigating universaltill/ut-docs#1241
  and #1255 (marketplace-release drift for `ut-plugin-tax-de`) — the
  `ut-plugin-language-es` Release workflow's own `check-key-drift.sh` gate
  turned out to be failing on this exact gap, which is why this repo's
  marketplace listing has drifted behind `main` too.
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context general-purpose subagent on
  Opus (complexity:medium per the pipeline's model-routing rubric — this
  fix is part of the broader #1241 card).

## What shipped

`universal-till`'s `web/locales/en.json` gained
`import.status.sku_reused_in_file` (universal-till#604, ut-docs#1222).
This pack was missing the follow-up translation, which is why
`lang-pack-drift` was RED on `universal-till`'s `main` (ut-docs#1236) and
— newly discovered this cycle — why this pack's own `Release` workflow
(`scripts/check-key-drift.sh`, a release gate here, not just advisory)
was failing outright on `workflow_dispatch`, blocking this pack's
marketplace listing from ever updating past `1.1.10`. The sibling
`ut-plugin-language-de` pack hit the identical gap and already fixed it
(PR #115, `v1.1.21`) — this mirrors that fix for Spanish and bumps the
manifest patch version in the same commit, matching that precedent
(rather than deferring the bump to publish time, per an older review
record in this same directory — the two conventions have both been used
here; bumping in-commit is what actually unblocks the Release workflow's
own "tag must match manifest version" check for tag-based releases, and
keeps `workflow_dispatch` releases correctly versioned too).

## Review findings

None (no must-fix), confirmed independently by a fresh-context Opus
reviewer, not just re-reading the diff:

- `git diff main fix/1236-sku-reused-key` is exactly the expected 2-line
  change: one new key in `locales/es.json`, one manifest version bump.
- Valid JSON, no duplicate keys, all 756 translated values non-empty
  strings (the `syncLocales` whole-file-drop hazard this repo's CLAUDE.md
  warns about is not triggered).
- Alphabetical insertion is correct:
  `import.status.sku_already_in_catalog` →
  **`import.status.sku_reused_in_file`** → `import.status.source_deleted`.
- Placeholder parity: exactly one `%s`, matching core's English source.
  Escaped straight quotes (`\"%s\"`) match this file's own convention on
  the sibling `%s`-carrying keys (`import.status.tax_unparseable`,
  `import.status.barcode_no_symbology_match`).
- Translation checked term-by-term against this pack's own established
  vocabulary, not just plausibility: `número de artículo` (not
  `referencia`) matches the direct sibling
  `import.status.duplicate_sku_in_file` = `"número de artículo duplicado
  en este archivo"` exactly — core's own English text draws the same
  "item number" vs "SKU/reference" distinction between these two keys,
  and the translation preserves it. `repetido` (rather than the more
  literal `reutilizado`) reads more naturally alongside the sibling's
  `duplicado` and a native speaker would not flag it as inaccurate;
  meaning ("reused") is fully preserved.
- `scripts/validate.sh`: `ok com.universaltill.language-es v1.1.11 (es)`.
- `scripts/check-key-drift.sh`: `756/1751 core keys translated, 995
  known-untranslated (baseline), 15 known-same-as-English (allowlist), 0
  drift, 0 orphans, 0 empty values, 0 untranslated-present`.
- `scripts/check-key-drift.test.sh`: 14/14 self-tests pass.
- Baseline bookkeeping: the key was never listed in
  `i18n-baseline/es.untranslated.txt` or `es.same-as-en.txt` (this was a
  genuinely new drift, not a previously-baselined key becoming
  translated), so this repo's CLAUDE.md "prune the baseline entry in the
  same change" rule doesn't apply — verified nothing needed pruning.
- Version bump (`1.1.10` → `1.1.11`) is a correct patch bump for an
  additive translation; matches the sibling `ut-plugin-language-de` fix's
  own patch bump (`1.1.20` → `1.1.21`) for the identical gap.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`, a real GitHub-linked
  human identity in the author field, Claude in `Co-Authored-By:` only.
- No real client/shop names, no secret-shaped literals, no
  compliance-outcome wording introduced.

## Verdict

**Safe to merge.** Once merged, `main` is release-ready — the next tag
(or `workflow_dispatch` run) should publish `1.1.11` to the marketplace,
closing the drift found while investigating ut-docs#1241.
