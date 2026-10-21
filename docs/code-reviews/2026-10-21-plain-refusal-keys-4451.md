# Review: plain-HTTP refusal join errors (ut-docs#4451)

Pack follow-up to universaltill/universal-till#2072: three new core keys `tills.join_error.{main_no_tls,satellite_tls_only,tls_only}`, translated by Opus 5.5 (lane:cloud-41), with `manifest.json` version bumped so the change ships.

## Review (Sonnet 5.5, a different model from the author)
All three strings are OK. Each says what the English says, sentence for sentence: nothing is dropped or added, and the "older version → update, otherwise restart both" branch is kept. Each uses this pack's existing terms (main till, satellite, secure connection) and its usual formal register. No findings. The reviewer also noted a pre-existing inconsistency outside this diff: es `tills.join_error.name_taken` uses the informal "elige".

## Verified
`scripts/validate.sh` ok. `scripts/check-key-drift.sh` against the PR's `en.json` is ok, with 0 drift, 0 orphans and 0 token mismatches.

## Verdict
Safe to merge once universal-till#2072 is on `main`.
