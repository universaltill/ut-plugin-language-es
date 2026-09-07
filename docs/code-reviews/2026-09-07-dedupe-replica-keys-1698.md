# Code review: remove duplicate replica_use_primary keys

- **Card:** universaltill/ut-docs#1698 — `es.json` carried
  `kitchenstations.error.replica_use_primary` and
  `tables.error.replica_use_primary` each twice (identical values both
  times), found incidentally by an earlier independent review while
  translating a new key for ut-docs#1689.
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context Sonnet subagent, adversarial —
  did not trust the diff description, re-derived it from `git diff`
  directly against `main`, confirmed both deleted lines were
  byte-for-byte identical to the lines that remain (not just similar),
  and ran a custom duplicate-key scan (Python `object_pairs_hook`
  counting) over the WHOLE file on both `main` and the fix branch to
  confirm no other duplicate keys exist anywhere else that this fix
  missed.

## What shipped

Deleted the second (duplicate) occurrence of each key, keeping the
first. `git diff --stat`: `locales/es.json | 2 --`, one file, two lines
removed, nothing else touched.

## Review findings

None. Independently confirmed:

- Both deleted lines are byte-for-byte identical to the retained line
  in each pair (pulled both copies from `git show main:locales/es.json`
  and diffed them directly).
- A full-file duplicate-key scan on `main` found exactly these 2
  duplicate keys and no others; the same scan on the fix branch found
  zero duplicates remaining.
- `python3 -c "import json; json.load(open('locales/es.json'))"` — valid
  JSON.
- `scripts/validate.sh`: `ok com.universaltill.language-es v1.1.18 (es)`.
- `scripts/check-key-drift.sh`: `1999/1999 core keys translated, 0
  drift, 0 orphans, 0 empty values` — unchanged from before the
  deletion (as expected: JSON's last-write-wins parsing means the
  duplicate was never actually adding translation coverage; removing it
  removes dead weight only, not a real key).

## Safe to merge

Yes. No blocking findings.
