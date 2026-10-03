#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Fast, dependency-light validation for the WeaR OS project repository.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Shell syntax"
for script in scripts/*.sh; do
    bash -n "$script"
    echo "OK  $script"
done

echo "==> Manifest XML"
python3 - "$ROOT_DIR/manifests/duchamp-lineage-23.1.xml" <<'PY'
import sys
import xml.etree.ElementTree as ET

path = sys.argv[1]
ET.parse(path)
print(f"OK  {path}")
PY

echo "==> Product registry"
test -f AndroidProducts.mk
test -f Android.bp
test -f vendor/wear/products/wear_duchamp.mk
test ! -e vendor/wear/products/AndroidProducts.mk
test ! -e vendor/wear/products/Android.bp
grep -q 'wear_duchamp-userdebug' AndroidProducts.mk
grep -q 'wear_duchamp' vendor/wear/products/wear_duchamp.mk
grep -q 'PRODUCT_SOONG_NAMESPACES' vendor/wear/products/wear_duchamp.mk

python3 - "vendor/wear/products/wear_duchamp.mk" <<'PY'
from pathlib import Path
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
wear = text.find("WITH_GMS := true")
device = text.find("device/xiaomi/duchamp/device.mk")

if wear < 0:
    raise SystemExit("WITH_GMS selector is missing")
if device < 0:
    raise SystemExit("duchamp device inclusion is missing")
if wear > device:
    raise SystemExit("WITH_GMS must be defined before device.mk is inherited")

if "device/xiaomi/duchamp/lineage_duchamp.mk" in text:
    raise SystemExit("WeaR must not inherit the upstream lineage_duchamp.mk identity layer")

if "PRODUCT_NAME := wear_duchamp" not in text:
    raise SystemExit("WeaR product name is missing")

print("OK  product semantics")
PY

echo "==> Manifest references"
grep -q 'path="vendor/wear"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="device/xiaomi/duchamp"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="vendor/xiaomi/duchamp"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="device/xiaomi/duchamp-kernel"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="device/mediatek/sepolicy_vndr"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="hardware/mediatek"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="hardware/xiaomi"' manifests/duchamp-lineage-23.1.xml

echo "==> Repository hygiene"
grep -q 'linguist-vendored=false' .gitattributes
test ! -d vendor/xiaomi/duchamp
test ! -d out
test ! -d .repo

echo
echo "Validation PASSED."
