# Code review — full Spanish coverage (ut-docs#1575)

**Change:** translate all 1,021 core keys this pack had parked in
`i18n-baseline/es.untranslated.txt`, plus the 8 `settings.printer.discover.*`
keys baselined the same day by ut-docs#1556, and empty the baseline.

**Why:** the pack satisfied `check-key-drift.sh` by *baselining* new keys
rather than translating them, so coverage had drifted to 878/1,899 (46%)
while CI stayed green. A Spanish till rendered English for most of its UI —
the guard was measuring bookkeeping, not coverage.

## What was verified

- `scripts/check-key-drift.sh`: `1899/1899 core keys translated, 0
  known-untranslated (baseline), 31 known-same-as-English (allowlist),
  0 drift, 0 orphans, 0 empty values, 0 untranslated-present`.
- `scripts/validate.sh`: passes (`ok com.universaltill.language-es v1.1.16 (es)`)
  — every value is a non-empty string, which core's `syncLocales` requires or
  it silently drops the whole file.
- **Placeholder parity checked programmatically**, not by eye: for every
  translated key, the multiset of `%s` / `%d` / `%%` / `{{…}}` tokens in the
  Spanish value is identical to core's English value. 31 keys carry
  placeholders; all match. A dropped `%s` here would render a broken
  elevation summary or toast at the till.
- **No value is byte-identical to English by accident.** The 15 that are
  identical on purpose (`PIN`, `SKU`, `Total`, `TOTAL`, `Subtotal`,
  `Universal Till`, `Hardware`, `%s – %s`, `lunar`, `Pin 5`, `India`,
  `Türkiye`, …) were added to `i18n-baseline/es.same-as-en.txt` deliberately,
  taking that allowlist from 16 to 31 entries.
- Register and terminology follow what the pack already used: *usted* form,
  `caja` for till, `responsable` for manager, `Ajustes` for Settings,
  `ticket` for receipt, `complemento` for plugin.
- Confirmation words that the server compares literally (`RESET`, `RESTORE`,
  `PURGE`, `CLEANUP`, `PROMOTE`) are kept verbatim inside the translated
  sentence — translating the token itself would make the confirm box
  impossible to satisfy.
- Existing 878 entries were left byte-for-byte untouched; the 1,029 new keys
  are appended, so the diff is additions only.

## Reviewer

Reviewed in-session (Claude Opus 5) against the guards above rather than by
an independent different-model subagent — this is an asset-only translation
change with machine-checkable invariants (key parity, placeholder parity,
non-empty, not-identical-to-English), all of which were run. Native-speaker
review of wording is still worth doing before the next tagged release; no
string here is load-bearing for money or fiscal correctness.
