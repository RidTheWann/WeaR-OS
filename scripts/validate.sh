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
python3 - <<'PY'
from pathlib import Path
import xml.etree.ElementTree as ET

manifests = [
    Path("manifests/duchamp-lineage-23.1.xml"),
    Path("manifests/duchamp-lineage-23.2.xml"),
]

for path in manifests:
    tree = ET.parse(path)
    root = tree.getroot()
    projects = root.findall("project")
    if not projects:
        raise SystemExit(f"{path}: no projects found")

    seen_paths = set()
    for p in projects:
        path_attr = p.get("path")
        name = p.get("name")
        revision = p.get("revision")
        if not path_attr or not name or not revision:
            raise SystemExit(f"{path}: incomplete project entry: {p.attrib}")
        if path_attr in seen_paths:
            raise SystemExit(f"{path}: duplicate project path: {path_attr}")
        seen_paths.add(path_attr)

    print(f"OK  {path} ({len(projects)} projects)")
PY

echo "==> Manifest profile semantics"
python3 - <<'PY'
from pathlib import Path
import xml.etree.ElementTree as ET

checks = {
    "23.1": (
        Path("manifests/duchamp-lineage-23.1.xml"),
        "snapboss/device_xiaomi_duchamp",
        "50f301982df14af45af137ba87c565a459a7e65c",
        "lineage-23.1",
    ),
    "23.2": (
        Path("manifests/duchamp-lineage-23.2.xml"),
        "mt6897-devs/device_xiaomi_duchamp",
        "6a2cf3be024e42cea0c22cbae7bf16f5def1309d",
        "lineage-23.2",
    ),
}

for label, (path, expected_device_repo, expected_device_sha, expected_branch) in checks.items():
    root = ET.parse(path).getroot()
    projects = {p.get("path"): p for p in root.findall("project")}

    device = projects.get("device/xiaomi/duchamp")
    kernel = projects.get("device/xiaomi/duchamp-kernel")
    vendor = projects.get("vendor/xiaomi/duchamp")

    if device is None or device.get("name") != expected_device_repo:
        raise SystemExit(f"{path}: wrong device tree repository")
    if device.get("revision") != expected_device_sha:
        raise SystemExit(f"{path}: wrong device tree revision")
    if kernel is None or kernel.get("revision") != "a2fd5cb97fd76a4eb61fcfe11af03ae74bd57416":
        raise SystemExit(f"{path}: unexpected kernel revision")
    if vendor is None or vendor.get("revision") != "38c572c3914d90970dce609fef9186cd6decf1db":
        raise SystemExit(f"{path}: unexpected vendor revision")

    print(f"OK  {label} stack semantics; default base branch: {expected_branch}")
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
for manifest in manifests/duchamp-lineage-23.1.xml manifests/duchamp-lineage-23.2.xml; do
    grep -q 'path="vendor/wear"' "$manifest"
    grep -q 'path="device/xiaomi/duchamp"' "$manifest"
    grep -q 'path="vendor/xiaomi/duchamp"' "$manifest"
    grep -q 'path="device/xiaomi/duchamp-kernel"' "$manifest"
    grep -q 'path="device/mediatek/sepolicy_vndr"' "$manifest"
    grep -q 'path="hardware/mediatek"' "$manifest"
    grep -q 'path="hardware/xiaomi"' "$manifest"
done
echo "OK  required project references"

echo "==> Repository hygiene"
grep -q 'linguist-vendored=false' .gitattributes
test ! -d vendor/xiaomi/duchamp
test ! -d out
test ! -d .repo
if find . -type f \( -name '*.img' -o -name '*.bin' -o -name '*.so' -o -name '*.apk' \) -not -path './.git/*' | grep -q .; then
    echo "ERROR: proprietary/binary artifacts detected in source repository" >&2
    find . -type f \( -name '*.img' -o -name '*.bin' -o -name '*.so' -o -name '*.apk' \) -not -path './.git/*' >&2
    exit 1
fi

echo
echo "Validation PASSED."
