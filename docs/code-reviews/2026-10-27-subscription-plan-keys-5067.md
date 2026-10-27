# Review: subscription plan/capability keys (ut-docs#5067 follow-up)

**Change.** Adds the two core keys universal-till merged for ut-docs#5067
(`subscription.plan.local_plus`, `subscription.cap.order_tracking`), which
left universal-till `main`'s `lang-pack-drift` check red. `local_plus` is a
plan name kept as "Local Plus" (like Shop/Pro) and goes on the same-as-English
allowlist. Version bumped to 1.1.261.

**Review.** Independent different-model reviewer: no findings — translation
matches the neighbouring `subscription.cap.*` wording, JSON and allowlist
ordering valid, version bumped.

**Verified.** `scripts/check-key-drift.sh` against core `main`'s en.json:
0 drift; `scripts/validate.sh` ok.
