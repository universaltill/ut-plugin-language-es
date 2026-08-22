# Code review: fix tú-register leakage in `plugins.manage.empty` (ut-docs#508)

**Date:** 2026-08-22
**Repo:** ut-plugin-language-es
**Related:** ut-docs#508 (found during independent review of ut-docs#411, 2026-08-09)

## What shipped

`locales/es.json`'s `plugins.manage.empty` value changed from the informal
*tú* imperative "Consíguelos" to the formal *usted* imperative
"Consígalos", matching the pack's established formal register used
consistently everywhere else in the file (e.g. "Pida a su responsable...",
"administre los plugins...", "elimine los plugins...").

Single-line diff, one key, no other changes.

## Independent review

Performed by a fresh-context Sonnet subagent (complexity: easy, per the
pipeline's model-routing rules) that did not write the fix.

- Confirmed the diff touches only `plugins.manage.empty`'s value — no
  other key, file, or whitespace change.
- Confirmed "Consígalos" is the grammatically correct formal (usted)
  imperative of *conseguir* + enclitic *los*, and matches the register of
  neighboring keys.
- Ran `scripts/validate.sh` — passed (`ok com.universaltill.language-es
  v1.1.3 (es)`).
- Ran `scripts/check-key-drift.sh` — passed clean: `531/1584 core keys
  translated, 1053 known-untranslated (baseline), 8 known-same-as-English
  (allowlist), 0 drift, 0 orphans, 0 empty values, 0 untranslated-present`.
- Confirmed `plugins.manage.empty` is not listed in either
  `i18n-baseline/es.untranslated.txt` or `i18n-baseline/es.same-as-en.txt`
  — correct, since this is a value fix to an already-translated key, not
  a newly-translated one, so no baseline/allowlist edit was needed or
  made.
- No secrets, no real-client-name literals, nothing else in scope.

**Verdict: safe to merge.** No findings.

## Verified beyond automated tests

JSON validity independently re-confirmed (`python3 -c "import json;
json.load(...)"`); grammar/register manually checked against surrounding
keys in the same file.

## Deferred / out of scope

None — this was a single, fully-scoped value fix with no follow-up work
implied.
