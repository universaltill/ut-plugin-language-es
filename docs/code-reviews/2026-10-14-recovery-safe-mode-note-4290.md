# Review — `recovery.safe_mode_this_device_only` (ut-docs#4290)

**Shipped:** one new core key translated into this pack, "El modo seguro (una vista de solo lectura de las ventas de hoy) solo se puede abrir en la propia caja." for core's "Safe mode (a read-only view of today's sales) can only be opened on the till itself." — the note the recovery screen shows instead of the safe-mode link when it is opened from another computer the LAN guard admits (safe mode itself stays loopback-only). Pairs with the universal-till PR for ut-docs#4290. Version bumped to 1.1.217.

**Review:** checked against `reference/translation.md`: no placeholders, wording reuses this pack's existing "Modo seguro"/"Ventas de hoy"/"caja" terms from the neighbouring `recovery.*` keys; `scripts/validate.sh` and `scripts/check-key-drift.sh` run against the core branch.

**Verdict:** safe to merge once the core PR is on `main`.
