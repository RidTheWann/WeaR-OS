#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Shell syntax"
for script in scripts/*.sh; do
    bash -n "$script"
    echo "OK  $script"
done

echo "==> Manifest XML"
python3 - <<'PY'
from pathlib import Path
import xml.etree.ElementTree as ET

path = Path("manifests/duchamp-lineage-23.1.xml")
root = ET.parse(path).getroot()
projects = root.findall("project")
assert projects, "manifest contains no projects"
paths = [p.get("path") for p in projects]
assert len(paths) == len(set(paths)), "duplicate project path in manifest"
required = {
    "vendor/wear",
    "device/xiaomi/duchamp",
    "device/xiaomi/duchamp-kernel",
    "vendor/xiaomi/duchamp",
    "hardware/xiaomi",
    "hardware/mediatek",
    "device/mediatek/sepolicy_vndr",
    "hardware/lineage/interfaces",
    "hardware/dolby",
    "vendor/qcom/opensource/vibrator",
    "packages/apps/Aperture",
}
missing = required.difference(paths)
assert not missing, f"manifest missing: {sorted(missing)}"
print(f"OK  {path} ({len(projects)} projects)")
PY

echo "==> Product registration"
test -f Android.bp
test -f AndroidProducts.mk
test -f products/wear_duchamp.mk
grep -q 'wear_duchamp-userdebug' AndroidProducts.mk
grep -q 'PRODUCT_NAME := wear_duchamp' products/wear_duchamp.mk
grep -q 'device/xiaomi/duchamp/lineage_duchamp.mk' products/wear_duchamp.mk
grep -q 'LUMINE_MAINTAINER :=' products/wear_duchamp.mk

echo "==> Reference lock"
grep -q 'snapboss/device_xiaomi_duchamp' manifests/duchamp-lineage-23.1.xml
grep -q '50f301982df14af45af137ba87c565a459a7e65c' manifests/duchamp-lineage-23.1.xml
grep -q '7d408383a8f199ba9a72e8a3b4314c6d848b459c' scripts/sync.sh

echo "==> Repository hygiene"
test ! -d vendor/wear/products/vendor
if find . -type f \( -name '*.img' -o -name '*.bin' -o -name '*.so' -o -name '*.apk' \) -not -path './.git/*' | grep -q .; then
    echo "ERROR: binary/proprietary artifacts found in WeaR-OS repository" >&2
    exit 1
fi

echo
echo "Validation PASSED."
