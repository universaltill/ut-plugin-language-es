# Code review: `fiscaldevice.error.owner_required_country_change` (ut-docs#1930)

- **Card:** universaltill/ut-docs#1930 — `universal-till` PR #985
  (ut-docs#1887) adds one new key to core's `web/locales/en.json`,
  `fiscaldevice.error.owner_required_country_change`. `lang-pack-drift`
  is advisory on that PR but blocking on core's `main`, so this pack
  needs the key as soon as it lands there — the lane that merges the core
  change owns the pack follow-up in the same cycle.
- **Repo:** `ut-plugin-language-es`
- **Lane:** `lane:local`.
- **Reviewer:** reviewed **inline by the orchestrating session**, not by a
  fresh-context subagent. Stating that plainly rather than implying the
  usual gate was met: this session runs under a standing
  no-unprompted-subagents instruction, so the `reviewer` skill's
  independent-subagent step could not be run as written. What replaced it
  is the mechanical verification below, which for a two-string
  translation is most of what the subagent would have done anyway — plus
  a second, adversarial Ollama pass that was fed specific complaints
  about the first draft (see "What the review found").

## What shipped

One new key in `locales/es.json`, inserted directly after its sibling
`fiscaldevice.error.owner_required` (the file's `fiscaldevice.*` block is
alphabetical, and this key sorts there):

```
fiscaldevice.error.owner_required_country_change
  EN: Owner (admin) required to change country while a fiscal signing device is confirmed
  es.upper(): Se requiere propietario (administrador) para cambiar el país mientras haya un dispositivo fiscal confirmado
```

## How it was translated

Self-hosted `qwen3:30b-a3b` on the NAS (`192.168.1.231:11434`), per
`ut-docs/reference/translation.md` — no hosted AI API, which is the
reason ut-docs#1930 carried `blocked:env` in the first place (a cold
cloud cycle cannot reach that host).

The model was given this pack's own existing translations for
`fiscaldevice.error.owner_required`, `fiscaldevice.state.confirmed`,
`fiscaldevice.error.server` and `countrysettings.col.country` as a
terminology anchor, and told to reuse them exactly.

## What the review found

1. **First draft was corrected.** The model's first attempt was `Se
   requiere propietario (administrador) para cambiar el país mientras el
   dispositivo fiscal está confirmado` — grammatically fine, but it turns
   the English indefinite ("*a* fiscal signing device is confirmed") into
   a definite reference to a specific device. A second Ollama pass was run
   with that complaint fed back in, per `reference/translation.md`'s own
   rule 3 ("retry with the specific complaint fed back in"), giving
   `mientras haya un dispositivo fiscal confirmado`, which keeps the
   indefinite reading and the subjunctive Spanish wants after *mientras*
   in a conditional clause. Accepted deviation: Spanish says *dispositivo
   fiscal*, not a literal rendering of "fiscal **signing** device" — that
   is this pack's established term.
2. **Terminology is consistent with what this pack already ships**, not
   with a generic dictionary rendering: the owner phrase is reused
   verbatim from the sibling key, "dispositivo fiscal" is this pack's existing
   rendering of the fiscal device (`fiscaldevice.error.server`), and
   "país" is its existing rendering of *country*
   (`countrysettings.col.country`).
3. **No format tokens** in the English source, none introduced — the
   drift check's token comparison confirms this independently.
4. **No trailing full stop**, matching the sibling error key's style.
5. **Not identical to English**, so it does not need an allowlist entry
   and does not trip the `untranslated-present` check.

Nothing blocking. No secret-shaped values, no client/shop names — not
applicable to a locale file, but checked.

## Verification beyond "it parses"

`scripts/check-key-drift.sh` cannot be run against real core `main` yet:
core `main` does not have this key until `universal-till#985` merges, and
the script treats a pack key core `main` lacks as an **orphan — FAIL
always, no baseline exception** (its own header, lines 48-49). That is
also why ut-docs#1930's stated ordering ("land the packs before the core
PR") is impossible as written, and why this cycle inverted it and filed
ut-docs#1934 against the `reviewer` skill rule that produced it.

So it was verified against a **simulated post-merge core**: core
`main`'s `en.json` @ `35300a1d` with this one key inserted, fed in via
the script's own offline hook, `UT_CORE_EN_JSON`:

```
check-key-drift: ok -- 2244/2244 translated, 0 known-untranslated (baseline), 33 known-same-as-English (allowlist),
  0 drift, 0 orphans, 0 empty values, 0 untranslated-present,
  0 token mismatches
```

The real gate still runs on this PR once core `main` carries the key.

## Verdict

**Safe to merge**, once `universal-till#985` is on core `main` — not
before, or this PR's own `key-drift` job fails on the orphan.

## Deferred

- ut-docs#1934 — the `reviewer` skill's lang-pack ordering rule is
  unimplementable for a *new* core key; filed, not fixed here.
