# Review — reports.zpaper.* (es, ut-docs#4330)

**What:** the 8 keys core adds in universal-till `fix/4330-zreport-print-labels`. The printed end-of-day (Z) report's header line, totals, tips heading and VAT-table headings now follow the till's language. This change translates them and bumps the manifest version so it ships.

**Checked:** an independent review (Sonnet; the translation is by Opus) found the values accurate and consistent with this pack's `reports.sales`, `reports.refunds`, `reports.eod.*` and `tender.*` terms. The printf verbs match English, every value is at most 42 characters, and every value encodes in cp858. `scripts/validate.sh` passes. `scripts/check-key-drift.sh` passes against the core branch's en.json (0 drift, 0 orphans, 0 token mismatches). The version bump is present. The core change's review is universal-till `docs/code-reviews/2026-10-15-zreport-print-labels-4330.md`.

**Verdict:** safe to merge once the core change is on `main`.
