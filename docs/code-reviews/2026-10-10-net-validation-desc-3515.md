# Review — plugins.permissions.desc.net_validation (ut-docs#3515)

**Change:** translates the core key added by universaltill/universal-till#1840 (ut-docs#3515): the store card's consent line for a `net:validation:<host>` permission (unencrypted HTTP to one host for certificate-validation data; the plugin is expected to check signatures itself). Bumps `manifest.json`'s `version` to 1.1.199.

**Review:** independent Sonnet review (author: Opus 5.5) of meaning, register and neighbouring `plugins.permissions.desc.*` terminology. de: one should-fix, fixed ("muss … prüfen" overstated an expectation as a rule; now "vom Plugin wird erwartet"). es, pt: faithful, no should-fix.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against the core PR branch's `en.json` passes: 3200/3200 keys, 0 drift, 0 orphans.
