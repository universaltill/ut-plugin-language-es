# Review — demo refusal message key (ut-docs#2687)

Core (universal-till, branch `feat/2687-demo-mode-gate`) adds `demo.not_available`,
the message a public demo till answers for routes that are not available in the demo
(ADR-0113 §1.4). This pack adds the translation:

- "demo.not_available": "No disponible en la demo.",
- `manifest.json` "version": "1.1.119" (bumped; shipped file changed).

Verified: `scripts/validate.sh` ok; `UT_CORE_EN_JSON=<core branch en.json> scripts/check-key-drift.sh`
→ 0 drift, 0 orphans. Short, neutral wording matching the ar/fa/tr core translations.
Merge order: after the core PR (this pack's drift check reads core `main`).

Verdict: safe to merge once core has merged.
