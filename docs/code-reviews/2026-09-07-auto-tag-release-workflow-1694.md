# Code review: auto-tag-release.yml (release-on-merge automation)

**Date:** 2026-09-07
**Card:** ut-docs#1694
**Author:** scrum-master pipeline (cloud cycle, `lane:cloud-54`), on behalf of Farshid Mirza

## What changed

Added `.github/workflows/auto-tag-release.yml`, byte-identical (sha256
`f18d5928...889535329`) to the copy landing in `ut-plugin-language-de` and
`ut-plugin-tax-de` in the same batch. On every push to `main` it reads
`manifest.json`'s `version`, and if no `v<version>` tag exists yet, creates
and pushes one with the workflow's own `GITHUB_TOKEN`, then
`workflow_dispatch`es the existing `release.yml` on that tag (a tag pushed
with `GITHUB_TOKEN` never starts another workflow on its own — GitHub's
recursion guard — so the explicit dispatch is what actually starts the
release). `release.yml` itself is unchanged.

## Full design rationale, design-gap catch, verification, and independent review

This is one of three identical repo changes in the same batch — the full
write-up (why this exists, the three recorded incidents, the recursion-guard
gap Dev caught and the dispatch fix, the behavioral test suite run against a
real throwaway git repo including a negative control, the Opus independent
review's findings and fixes) lives in
`ut-plugin-tax-de/docs/code-reviews/2026-09-07-auto-tag-release-workflow-1694.md`
and applies verbatim here — the diff is mechanically identical and the
reasoning doesn't vary by repo.

## This repo's own state at merge time

`manifest.json` version `1.1.18` already has a matching `v1.1.18` tag on
`main` — this repo is **not** currently drifted, unlike `ut-plugin-tax-de`.
So the first push carrying this workflow is expected to run, find the tag
already exists, and no-op (`created=false`, no dispatch) — itself a real
verification of acceptance criterion 2 ("a merge that does not change the
version publishes nothing"), on a live repo rather than only the throwaway
test.

## Scope note

Also touches `ut-plugin-tax-de` (currently live-drifted — the real
end-to-end proof of the tag-creation path), `ut-plugin-language-de`
(same as this repo — already caught up), and
`ut-docs/.claude/skills/devops/SKILL.md` (documents the automation, keeps
the manual fallback for every other `ut-plugin-*` repo intact).
