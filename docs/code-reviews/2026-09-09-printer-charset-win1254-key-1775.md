# Code review: `settings.printer.charset_win1254` (ut-docs#1775 pack follow-up)

- **Card:** universaltill/ut-docs#1775 — `universal-till` PR #970 (merged
  `35300a1d`) adds the Turkish Windows-1254 receipt-printer charset and,
  with it, one new key in core's `web/locales/en.json`:
  `settings.printer.charset_win1254`. `lang-pack-drift` is advisory on
  that PR but **blocking on core's `main`**, so `main` is red until this
  pack carries the key — the lane that merges the core change owns the
  pack follow-up in the same cycle.
- **Repo:** `ut-plugin-language-es`
- **Lane:** `lane:local`. This is the same cycle that merged
  universal-till#970.
- **Reviewer:** reviewed **inline by the orchestrating session**, not by a
  fresh-context subagent — this session runs under a standing
  no-unprompted-subagents instruction, so the `reviewer` skill's
  independent-subagent step could not be run as written. Saying so plainly
  rather than implying the usual gate was met. What replaced it is the
  mechanical verification below.

## What shipped

One new key in `locales/es.json`, inserted in its alphabetical position
between `settings.printer.charset_win1253` and
`settings.printer.charset_win1257`:

```
settings.printer.charset_win1254
  EN: Turkish (Windows-1254 — €/ş/ı)
  es: Turco (Windows-1254 — €/ş/ı)
```

## Review notes

1. **This is a closed pattern, not a free translation.** The pack already
   ships five sibling options in this dropdown, and every one of them
   translates *only* the language/region name — the code-page name and the
   sample characters are carried through verbatim (e.g.
   `Griego (Windows-1253 — €/α/β)`). The new entry follows that
   exactly; anything else would have been the finding.
2. **Sample characters are deliberately NOT localised.** `€/ş/ı` are the
   glyphs Windows-1254 is being chosen *for*; translating or transliterating
   them would defeat the point of the label.
3. The em dash and spacing match the siblings byte-for-byte, so the option
   list still reads as one set in the settings dropdown.
4. **No format tokens** in the source, none introduced. Not identical to
   English, so no allowlist entry is needed.
5. Translated with the self-hosted `qwen3:30b-a3b` on the NAS per
   `ut-docs/reference/translation.md` — no hosted AI API — with the five
   sibling options given as the pattern anchor.

Nothing blocking.

## Verification

`scripts/check-key-drift.sh` against **live core `main`**
(`35300a1d`, i.e. with universal-till#970 already merged):

```
check-key-drift: ok -- 2243/2243 core keys translated,
  0 known-untranslated (baseline), 33 known-same-as-English (allowlist),
  0 drift, 0 orphans, 0 empty values, 0 untranslated-present,
  0 token mismatches
```

## Verdict

**Safe to merge.** Merging it is what takes core `main`'s
`lang-pack-drift` back to green.
