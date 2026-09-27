# Review: pack key for the Portugal country tile (ut-docs#2963)

One new core key from universal-till#1473: `setup.country.pt`, which is the setup wizard's name for Portugal. The value is "Portugal", which is the standard name in this language and is identical to English, so the key is listed in `i18n-baseline/es.same-as-en.txt` in sorted order. It was reviewed by Fable against the neighbouring `setup.country.*` values, and there were no findings. Checked against core `b99d6f3`: `validate.sh` passes (v1.1.129), and `check-key-drift.sh` reports 2867/2867 core keys, 46 same-as-English, 0 drift and 0 orphans. The version is bumped.

**Verdict:** safe to merge.
