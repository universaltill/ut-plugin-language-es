# Code review: port token-parity check into check-key-drift.sh

- **Card:** universaltill/ut-docs#1760 — `ut-plugin-language-es`'s
  `scripts/check-key-drift.sh` was missing the placeholder-token-parity
  check `ut-plugin-language-de`'s copy of the same script already carries
  (added there for ut-docs#297), found during independent review of
  ut-docs#1758. 0 mentions of "token" in the ES script (DE has 16), and
  its self-test suite had no token-mismatch cases at all (14 tests vs.
  DE's 22).
- **Repo:** `ut-plugin-language-es`
- **Reviewer:** independent fresh-context Sonnet subagent (`complexity:easy`
  → same-tier review, per `MODEL-ROUTING.md`), isolated worktree, adversarial.

## What shipped

Ported the token-extraction/parity logic (AC #1) from
`ut-plugin-language-de/scripts/check-key-drift.sh` into the ES copy,
behaviorally identical (only `de`→`es` naming differs): the ordered
format-token regex (`%s`/`%d`/…, `{{name}}`, `{0}`), the `token_mismatches`
computation, and the failure report. Added 3 self-test cases mirroring
DE's (`token-count-differs`, `token-order-differs`,
`tokens-match-mixed`). `git diff --stat`: `scripts/check-key-drift.sh |
+30/-1`, `scripts/check-key-drift.test.sh | +65`, nothing else touched.

**AC #2 (whether to also do the ut-docs#312 shared-extraction now) was
deliberately left undone** — the source issue explicitly left that as a
BA/Architect call, not asserted as required, and folding a cross-repo
shared-implementation extraction into this easy-complexity, single-file
port would have widened scope well past what this card asked for. Noted
here so the deferral is visible rather than silently dropped; ut-docs#312
remains the tracking card for that separate decision.

## Review findings

None blocking. Independently confirmed, not just taken on trust:

- **TDD re-verified by revert/restore**: reverted only
  `check-key-drift.sh` to its pre-fix content (kept the new test cases),
  re-ran the suite — exactly the 2 new mismatch-detecting cases failed
  ("expected non-zero exit, got 0"), the 3rd (`tokens-match-mixed`) still
  passed as expected. Restored the fix, diffed byte-identical, reran:
  all 17 cases pass again.
- `bash scripts/check-key-drift.test.sh` — all 17 pass (14 pre-existing +
  3 new), no regressions.
- `bash scripts/validate.sh` — `ok com.universaltill.language-es v1.1.19
  (es)`.
- `bash scripts/package.sh` — packaged clean; tarball contents confirmed
  to exclude `i18n-baseline/` as required by this repo's `CLAUDE.md`.
- **Live check against today's shipped core + es.json** (no local
  `UT_CORE_EN_JSON` override skipped — used the real
  `universal-till/web/locales/en.json`, 2066 keys):
  `2066/2066 core keys translated, 0 drift, 0 orphans, 0 empty values,
  0 untranslated-present, 0 token mismatches` — confirms the new,
  stricter check introduces no surprise regression against the real,
  currently-shipped translation.
- Diffed line-by-line against DE's script: the regex, computation, and
  message format are byte-for-byte equivalent aside from `de`/`es`
  naming — a faithful port, no reinvention, and no scope creep into DE's
  separate `--allow-growth`/exact-parity ratchet feature (ut-docs#297's
  other half), which this diff correctly leaves untouched.
- Regex edge cases checked directly: no tokens → no spurious mismatch;
  adjacent tokens each parse correctly; `{{0}}` parses as one template
  token, not `{0}`; `%%` (escaped percent) correctly produces no match.
  Byte-identical to DE's regex, so any theoretical edge-case quirk is
  inherited and pre-existing, not introduced by this port.
- One minor, non-blocking, pre-existing-in-DE-too observation: the token
  check runs over the full shared-key set without excluding
  empty-value keys, so a key that's both empty and token-bearing reports
  under two headings at once (redundant, not incorrect — it already
  fails CI for the empty-value reason regardless). Not changed, since it
  mirrors DE exactly and this card is a narrow, behavior-preserving port.
- Scope check: only the two script files changed — no touches to
  `i18n-baseline/`, `locales/es.json`, or DE's ratchet feature. No
  secrets, no real client/shop name, no UI surface (backend CI script).

## Safe to merge

Yes. No blocking findings, no fixes needed.
