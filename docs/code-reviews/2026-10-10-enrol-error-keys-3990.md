# Review — settings.enrol.claim_failed, not_configured, busy (ut-docs#3990)

**Change:** translates the three core keys added by universaltill/universal-till#1836 (ut-docs#3990): the Till registration card's message when a claim code can't be fetched, when the till has no cloud address configured, and when another registration attempt is still running. Bumps `manifest.json`'s `version` by one patch.

**Review:** an independent Sonnet review (author: Opus 5.5; Fable was unavailable) checked meaning against the English, register and terminology against the neighbouring `settings.enrol.*` keys (this pack's words for claim, till, cloud and register), dash style, JSON validity and the version bump. No findings.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against the core PR branch's `en.json` passes: 3197/3197 keys, 0 drift, 0 orphans.
