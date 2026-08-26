# Code review: track 14 new sync-quarantine keys as known-untranslated debt

- **Card:** universaltill/ut-docs#1133 (closed by universal-till PR #568;
  this is the implied lang-pack follow-up, per the "own it explicitly"
  rule in the `scrum-master` skill — no separate board card)
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context general-purpose subagent (same
  session model tier — complexity:easy per the pipeline's model-routing
  rubric)

## What shipped

Core (`universal-till`'s `web/locales/en.json`) gained 14 new keys under
`sync.chip_quarantine*` / `sync.quarantine_*` (PR #568, "admin panel for
quarantined LAN-sync journal entries", closing ut-docs#1133), which this
pack never translated — new, unaccounted drift against
`i18n-baseline/es.untranslated.txt`, failing `lang-pack-drift`'s
push-to-main check on `universal-till`.

This pack carries substantial pre-existing untranslated debt (~980
keys). Following the same precedent as ut-docs#1136's fix (PR #108,
"drawer-pin-baseline"), the 14 keys were added to
`i18n-baseline/es.untranslated.txt` via `scripts/check-key-drift.sh
--update-baseline` rather than translated now — a documented, guard-
supported way to close the drift, not a workaround.

## Review findings

None (no must-fix). Confirmed independently by a fresh-context reviewer:

- Diffed core's actual PR range for `web/locales/en.json` and confirmed
  the 14 keys added to the baseline here are exactly the 14 new core
  keys — no more, no fewer.
- `git diff --stat` confirms only `i18n-baseline/es.untranslated.txt` is
  touched; the 14 lines are inserted in the correct sorted position (the
  file is enforced sorted/deduplicated by the check script itself).
- `scripts/validate.sh` and `scripts/check-key-drift.sh` (run against
  `universal-till` main @ `167e1c7`) both pass: 744/1739 core keys
  translated, 995 known-untranslated (baseline), 0 drift, 0 orphans, 0
  empty values.
- Git identity on the commit: `Farshid Mirza
  <4035824+farshidmirza@users.noreply.github.com>`, a real GitHub-linked
  human identity, not an AI-tool default.
- No real client/shop names, no secret-shaped literals.

## Verdict

**Safe to merge.**
