# Review — `settings.display.additional_kiosk_use_profile` (ut-docs#4263)

**Shipped:** one new core key translated into this pack, «Esta caja es una caja adicional. Para convertirla en un quiosco de autopedido, use Ajustes → Perfil del dispositivo …» — the refusal an additional till gets when `POST /api/settings/upsert` tries to switch it to the self-order kiosk without the Device profile confirm. Pairs with the universal-till PR for ut-docs#4263. Version bumped to 1.1.216.

**Review:** checked against `reference/translation.md`: no placeholders, nothing dropped; reuses the pack's existing terms (Caja adicional / Quiosco de autopedido / Ajustes / Perfil del dispositivo / caja principal). `scripts/validate.sh` and `scripts/check-key-drift.sh` (`UT_CORE_EN_JSON` = the core branch's en.json) pass.

**Verdict:** safe to merge once the core PR is on `main`.
