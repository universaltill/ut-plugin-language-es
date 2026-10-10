# Review: plugins.permissions.desc.view_shop (ut-docs#4045)

**Date:** 2026-10-10 · **Lane:** lane:cloud-41 · **Reviewer:** Sonnet 5.5,
fresh context, which reviewed this pack's line together with the core change.

- **What it adds:** one locale line for the new core key
  `plugins.permissions.desc.view_shop`. It is the consent line for the non-★
  `view:shop` class (`shop.context.v2`) and sits right after
  `view_users`. The manifest version gets a patch bump (CLAUDE.md
  version-bump rule).
- **Review:** the reviewer found the translation accurate and the wording
  consistent with the neighbouring `view_users` line and this pack's terms
  for shop and till. `scripts/validate.sh` passes. `check-key-drift.sh`
  against core's en.json with the key added passes.
- **Order:** the core change (universaltill/universal-till
  `feat/4045-view-shop-class`) merges first, because the key is new.

**Verdict:** safe to merge.
