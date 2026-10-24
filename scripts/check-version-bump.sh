#!/usr/bin/env bash
#
# Requires a manifest.json version bump on any PR that touches a shipped
# file (ut-docs#1940).
#
# WHY THIS EXISTS: scripts/package.sh bundles manifest.json, locales/ and
# README.md (plus LICENSE when present) into the marketplace release
# artifact. None of this repo's other checks (key-drift, validate, authors)
# look at the version field, so a PR that edits locales/*.json but forgets
# to bump manifest.json's version lands on main, passes every check, and
# then SILENTLY NEVER SHIPS: auto-tag-release.yml reads the unchanged
# version, sees v<version> already tagged/released, and correctly does
# nothing. main and the marketplace diverge with no failing signal
# anywhere. This has already needed hand repair at least three times
# (v1.1.32, v1.1.33->34, and the duplicated-keys fix for ut-docs#1863) plus
# twice more on 2026-09-09 alone, in two different lanes.
#
# WHAT COUNTS AS "SHIPPED": deliberately keyed off the same set
# scripts/package.sh actually bundles, not "any file" -- a docs/code-reviews/
# record or a workflow-only edit must never force a version bump. Keep this
# list mirrored to package.sh's own `entries=(...)` line; nothing enforces
# that automatically, so a change to package.sh's bundle needs a matching
# edit here (and check-version-bump.test.sh's "entries mirror" case exists
# to catch drift between the two by re-reading package.sh's own source).
# The check logic itself lives in scripts/check-version-bump.body.sh, sourced
# at the bottom: one canonical body, byte-identical in every ut-plugin-* repo
# (canonical copy: ut-docs scripts/templates/check-version-bump.body.sh,
# ut-docs#4489). Never edit the body here; only SHIPPED_PATTERNS (and
# SHIPPED_NOTE) are per-repo.
set -euo pipefail
cd "$(dirname "$0")/.."

# SHIPPED_PATTERNS is read by the sourced body, which shellcheck does not
# follow without -x.
# shellcheck disable=SC2034
SHIPPED_PATTERNS=(
    'manifest.json'
    'locales/*'
    'README.md'
    'LICENSE'
)

# shellcheck source=scripts/check-version-bump.body.sh
. scripts/check-version-bump.body.sh
