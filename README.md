# ut-plugin-language-es

Spanish language pack for Universal Till (`canonical_type: "language"`,
ADR-0010). Ships `locales/es.json`; the till merges it as an overlay on
install — base strings always win on key conflict, so packs add locales but
cannot hijack core text. The nav language switcher picks up ES automatically.

Release: bump manifest version, tag `v<version>` → CI validates, packages,
publishes to the marketplace, auto-approves (dev).
