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

echo "OK  product registration"

echo "==> Manifest references"
grep -q 'path="vendor/wear"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="device/xiaomi/duchamp"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="vendor/xiaomi/duchamp"' manifests/duchamp-lineage-23.1.xml
grep -q 'path="device/xiaomi/duchamp-kernel"' manifests/duchamp-lineage-23.1.xml

echo "OK  required project references"

echo
echo "Validation PASSED."
