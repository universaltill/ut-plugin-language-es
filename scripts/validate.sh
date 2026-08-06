#!/usr/bin/env bash
# Validates the language-pack manifest and every locale file (ADR-0010):
# asset-only runtime, canonical_type language, locales/*.json parse and cover
# a sane share of the base keys.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
import json, os, re, sys
m = json.load(open("manifest.json"))
errs = []
if not re.match(r'^[a-z0-9]+([.-][a-z0-9]+)*$', m.get("id","")): errs.append("bad id")
if not m.get("name"): errs.append("missing name")
if not re.match(r'^\d+\.\d+\.\d+', m.get("version","")): errs.append("bad version")
if not m.get("permissions"): errs.append("missing permissions")
if m.get("runtime") != "none": errs.append("runtime must be 'none' (asset-only, ADR-0010)")
if m.get("device_arch") != "any": errs.append("device_arch must be 'any'")
if m.get("canonical_type") != "language": errs.append("canonical_type must be 'language'")
locs = m.get("locales") or []
if not locs: errs.append("manifest.locales must list shipped locales")
for loc in locs:
    p = f"locales/{loc}.json"
    if not os.path.isfile(p):
        errs.append(f"missing {p}"); continue
    try:
        d = json.load(open(p))
        if len(d) < 20: errs.append(f"{p}: suspiciously few keys ({len(d)})")
        # Core's internal/plugins/syncLocales unmarshals each locale file into
        # map[string]string and, on error, logs and skips the ENTIRE file --
        # so one non-string value (an object, number, bool, null) silently
        # drops every translation in this pack on every till, with CI staying
        # green unless this catches it first. An empty string is also
        # rejected here: core's T() returns it unconditionally, so it renders
        # blank UI rather than falling back to English.
        for k, v in d.items():
            if not isinstance(v, str):
                errs.append(f"{p}: value for {k!r} is not a string ({type(v).__name__}) -- would silently drop the whole file in core's syncLocales")
            elif not v.strip():
                errs.append(f"{p}: value for {k!r} is empty or whitespace-only")
    except Exception as e:
        errs.append(f"{p}: invalid JSON: {e}")
if errs:
    print("FAIL: " + "; ".join(errs)); sys.exit(1)
print(f"ok {m['id']} v{m['version']} ({', '.join(locs)})")
PY
