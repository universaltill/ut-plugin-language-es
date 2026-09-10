# 2026-09-10 — manifest.json version-bump CI guard (ut-docs#1948)

## What shipped

Ports the `manifest.json` version-bump guard `ut-plugin-language-de`
already carries (ut-docs#1940) to this repo. Without it, a PR that edits
`locales/es.json` (or any other shipped file: `manifest.json`,
`README.md`, `LICENSE`) but forgets to bump `manifest.json`'s `version`
lands on `main`, passes every existing check, and then **silently never
ships** — `auto-tag-release.yml` reads the unchanged version, sees
`v<version>` already tagged/released, and correctly does nothing. This
repo has no evidenced hand-repair incident of its own yet, but
`ut-plugin-language-de` needed three (v1.1.32, v1.1.33->34, the
duplicated-keys fix for ut-docs#1863) plus two more on 2026-09-09 alone —
the same silent-failure shape is equally reachable here, and this is the
first of the `ut-plugin-*` rollout ut-docs#1948 asks for
(`ut-plugin-language-es` explicitly named to go first, "most similar
recurring-bug risk").

- `scripts/check-version-bump.sh` — copied **verbatim** from
  `ut-plugin-language-de` (confirmed byte-identical, md5sum match). The
  script is already generic: it keys `SHIPPED_PATTERNS` off
  `scripts/package.sh`'s own `entries=(...)` shape, not this repo's
  identity, so it needed zero changes.
- `scripts/check-version-bump.test.sh` — ported and localized (es/Spanish
  fixture content in place of de/German: `locales/de.json`→`es.json`,
  `com.universaltill.language-de`→`-es`, `German (Deutsch)`→`Spanish
  (Español)`, `Eins/Zwei/Drei`→`Uno/Dos/Tres`), mirroring the same de→es
  localization convention this repo's own `scripts/check-key-drift.test.sh`
  already established. No assertion, control flow, case, or harness
  function was altered — only fixture literals.
- `.github/workflows/ci.yml` — new `version-bump` job, PR-only
  (`if: github.event_name == 'pull_request'`), mirroring
  `ut-plugin-language-de`'s job exactly: self-tests first, then the real
  guard against `BASE_SHA`/`HEAD_SHA` from the PR event, `fetch-depth: 0`
  so the merge-base diff has the history it needs.
- `CLAUDE.md` — documents the new rule, mirroring
  `ut-plugin-language-de`'s own note verbatim (adjusted for this repo's
  self-hosted-copy footnote already present).

## What was verified beyond automated tests

- `bash scripts/check-version-bump.test.sh` — all 11 cases pass,
  including the "entries mirror" self-test, which re-reads this repo's
  **real** `scripts/package.sh` (not a hardcoded restatement) and
  confirms `SHIPPED_PATTERNS` covers every bundle entry
  (`manifest.json`, `locales`, `README.md`, conditional `LICENSE`).
- `bash scripts/validate.sh` and `bash scripts/package.sh` (dry run) —
  both clean; the packaged artifact was unpacked and its contents
  (`manifest.json`, `locales/es.json`, `README.md`, `LICENSE`) checked
  against `SHIPPED_PATTERNS` directly — full coverage, no gap.
  `dist/` (gitignored) removed after inspection.
- `bash scripts/check-key-drift.test.sh` — all cases still pass; this
  PR's diff never touches that script, confirmed via
  `git diff --stat` on the unrelated pathspec.
- **Real failure-mode simulation, in this repo, not just the synthetic
  fixture**: on a scratch commit (reverted afterward, never landed on the
  feature branch), edited the real `locales/es.json` without bumping
  `manifest.json`'s version (`1.1.33`). The guard correctly failed:
  ```
  FAIL: shipped file(s) changed but manifest.json's version is still 1.1.33
  ...
  Fix: bump manifest.json's "version" in this PR to a version higher than 1.1.33, e.g. "1.1.34".
  ```
  Bumping to `1.1.34` in the same scratch branch then passed:
  `ok: manifest.json version bumped 1.1.33 -> 1.1.34, ...`. Confirmed the
  guard run against this PR's own diff (touches only
  `.github/workflows/`, `CLAUDE.md`, `scripts/` — none of which are
  shipped files) passes without requiring a bump:
  `ok: no shipped file changed (...) -- no version bump required`.
- Workflow YAML parsed and validated (`yaml.safe_load`); the new
  `version-bump:` job block diffed against `ut-plugin-language-de`'s own
  — identical (steps, `if:` conditions, both env vars, both `run:`
  targets).
- `find . -name '*.go'` confirms this repo has no Go code at all
  (asset-only pack per ADR-0010) — the two standing recurring bug classes
  (file-write without `os.MkdirAll`, cwd-relative path instead of
  `paths.Data(...)`) are not applicable; checked rather than assumed. The
  shell fixtures `mkdir -p` their target directories before any write
  into them, and both scripts resolve their own path
  (`cd "$(dirname "$0")/.."`) rather than trusting cwd.

## Independent review

Spawned a fresh-context Opus subagent (card is `complexity:medium`, per
"Model routing by complexity") in an isolated worktree (`isolation:
"worktree"`), never sharing this checkout. Verdict: **SAFE TO MERGE**. It
independently:

- confirmed the script is byte-identical to `ut-plugin-language-de`'s via
  md5sum;
- confirmed the test file's localization is complete (swept for leftover
  de/German tokens — none found beyond legitimate historical references)
  and logic-preserving (diffed against `-de`'s original — only fixture
  literals changed);
- ran the full self-test suite, `validate.sh`, `package.sh`, and
  `check-key-drift.test.sh` itself, all green;
- **mutation-tested the self-test suite**: removing `locales/*` from
  `SHIPPED_PATTERNS` broke 4 cases including the entries-mirror one;
  neutering the version-comparison broke 5 cases; adding a fake bundle
  entry to `package.sh` was caught by the entries-mirror case. All
  mutations reverted afterward;
- **independently reproduced the TDD proof** on its own scratch commit:
  edited `locales/es.json` without a version bump, confirmed the guard
  FAILs with the expected message, bumped the version, confirmed it
  PASSes — matching the same real-repo verification above;
- diffed the new `version-bump:` CI job block against `-de`'s and found
  it identical;
- confirmed no real client/shop name and no secret-shaped literal
  anywhere in the diff (the only `GH_TOKEN` reference is a pre-existing,
  unrelated `key-drift` job's context expression);
- confirmed this diff touches no UI surface and no
  `universal-till/web/help/` content, so the UX-guidelines/user-manual
  checks don't apply here — stated explicitly rather than silently
  skipped.

Nits raised, all inherited verbatim from `ut-plugin-language-de`'s
already-reviewed original (not new drift introduced by this port), left
as-is for parity rather than diverging from the reference implementation:
the guard step itself lacks `if: always()` (a self-test regression would
skip the real check — worth an ecosystem-wide follow-up, not a
per-repo fix); `always()` on the job's first step is a no-op; the
entries-mirror pattern-extraction regex harvests every quoted literal in
the script, not just `SHIPPED_PATTERNS` (no actual collision today,
flagged as theoretical). The one required addition — this review record
— is what you're reading.

## Safe-to-merge verdict

Yes. Matches ut-docs#1948's acceptance criteria for this repo: guard
script, self-test suite, CI job, and `CLAUDE.md` note all landed;
`ut-plugin-language-es` is the first repo done in the rollout the card
asks for.

## Deferred / out of scope

- The inherited nits above (F2-F4 in the independent review) — worth an
  ecosystem-wide follow-up across all packs carrying this guard, not a
  divergent one-off fix here.
- The rest of the `ut-plugin-*` rollout (`ut-plugin-tax-de`,
  `ut-plugin-payment-sumup`, etc., minus the documented `ut-plugin-faq`/
  `ut-plugin-themes` exceptions) — ut-docs#1948's own scope, tracked
  there for a future cycle.
