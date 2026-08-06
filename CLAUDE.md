# ut-plugin-language-es — rules

Language pack (ADR-0010): asset-only, runtime none, locales/es.json only.

Keep keys in sync with universal-till `web/locales/en.json`. This is
guarded by two mechanisms, not just JSON validity:

- `scripts/validate.sh` enforces JSON validity AND that every value in
  every `locales/*.json` file is a non-empty string (core's
  `internal/plugins/syncLocales` unmarshals into `map[string]string` and
  drops the WHOLE FILE on any non-string value, silently, so this must
  never regress).
- `scripts/check-key-drift.sh` enforces key parity against core's base
  locale plus real-value sanity: a key that's present but empty, or
  present but byte-identical to core's English string, is treated as
  untranslated (ut-docs#292 was exactly this for the German pack —
  `"pfand.action": "Deposit refund"`, present and non-empty, passed a
  key-set-only check; ut-docs#296 found the identical gap here). It reads
  two files in `i18n-baseline/` (NOT `locales/` — that ships to
  customers; these are developer bookkeeping and must never be added to
  `scripts/package.sh`'s bundle):
  - `i18n-baseline/es.untranslated.txt` — every core key this pack
    doesn't yet translate, one per line, sorted.
  - `i18n-baseline/es.same-as-en.txt` — keys where `es.json`'s value is
    deliberately identical to core's English string (allowlist).
  Both are enforced the same way: an entry that's gone stale (translated
  since, or the key/identity no longer holds) FAILS CI so it gets pruned.
  **Landing a translation for a key that's in the baseline requires
  pruning that key from `i18n-baseline/es.untranslated.txt` in the same
  change** — leaving it there is a stale entry and the guard will fail.
  Regenerate either file with `scripts/check-key-drift.sh
  --update-baseline` / `--update-allowlist`, then review the diff like
  any other change — neither file may grow silently, only through a
  reviewed edit.

This script is currently a per-repo copy of the one `ut-plugin-language-de`
carries (same origin, ut-docs#292) — see this repo's
`docs/code-reviews/2026-08-06-es-pfand-keys-and-drift-guard.md` and
ut-docs#312 for why extracting one shared cross-repo implementation was
deferred to its own card rather than done as part of this change.

Never publish by hand — tag v<version>.
