# Review: import from another till system (es, ut-docs#4431)

**What:** the 43 keys core adds for the Import page's fourth option, *From another till system* (`import.welcome.system.*`, `import.system.*`): a shop connects an installed importer plugin, checks & previews, then imports products. `import.welcome.intro` is updated from "three ways" to "four ways". Formal *usted*, as in the rest of the import page; till system is "sistema de caja", importer "plugin de importación", VAT "tipo de IVA", stock "existencias". The manifest version is bumped so it ships.

**Checked:** the translation is by Opus. `%s`/`%d` placeholders kept; `scripts/validate.sh` passes; `scripts/check-key-drift.sh` passes against the core branch's en.json (`UT_CORE_EN_JSON`): 3440/3440 keys, 0 drift, 0 orphans, 0 token mismatches.

Independent review (Sonnet): approved as is (terminology, register and placeholders checked; validate.sh and check-key-drift.sh pass).

**Verdict:** safe to merge once the universal-till change for ut-docs#4431 is on `main`.
