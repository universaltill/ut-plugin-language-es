# Review: cloud-terms accept keys (ut-docs#4720)

Adds the four keys universal-till PR #2102 introduced:
`settings.enrol.terms.label`, `settings.enrol.terms.link`,
`settings.enrol.terms.accepted` and `settings.enrol.terms_required`.
It also bumps the manifest version.

Review checks:
- Both `%s` placeholders are kept.
- The terminology matches the pack's existing `settings.enrol.*` strings.
- No certification claim is made (ADR-0040).

The translations were checked against the English source in core
`web/locales/en.json`.
