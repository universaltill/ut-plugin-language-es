# Review: iOS Bluetooth notice keys (ut-docs#3261)

**Date:** 2026-10-02 · **Lane:** lane:cloud-24 · **Reviewer:** Fable (independent subagent)

Two new core keys go into `locales/es.json`: `bluetoothdevices.ios_system_pairing` and `bluetoothdevices.ios_no_printers`. They are translated from core's en.json (universal-till#1608), and `manifest.json`'s version is bumped.

The reviewer ran `scripts/validate.sh` and `scripts/check-key-drift.sh` against the core branch's en.json: all keys translated, 0 drift, 0 orphans.

Translation checks:
- register matches the pack;
- product names (iPhone, iPad, Bluetooth, Wi-Fi, Ethernet) untouched;
- no placeholders.

Fixed wording nits: de "tippt das Gerät" (pronoun agreement), and es "impresoras de tickets Bluetooth y las básculas Bluetooth" (scope).

Verdict: safe to merge once core#1608 is on main.
