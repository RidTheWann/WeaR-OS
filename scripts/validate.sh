#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT_DIR"

for script in scripts/*.sh; do
    bash -n "$script"
done

python3 - <<'PY'
from pathlib import Path
import xml.etree.ElementTree as ET

p = Path('manifests/duchamp-lineage-23.1.xml')
root = ET.parse(p).getroot()
projects = root.findall('project')
assert len(projects) == 1
device = projects[0]
assert device.get('path') == 'device/xiaomi/duchamp'
assert device.get('name') == 'snapboss/device_xiaomi_duchamp'
assert device.get('revision') == '50f301982df14af45af137ba87c565a459a7e65c'
print('manifest validation: PASS')
PY

grep -q 'wear_duchamp-userdebug' patches/device_xiaomi_duchamp/0001-weaR-product.patch
grep -q 'PRODUCT_NAME := wear_duchamp' patches/device_xiaomi_duchamp/0001-weaR-product.patch
grep -q '50f301982df14af45af137ba87c565a459a7e65c' README.md

echo 'WeaR OS project validation: PASS'