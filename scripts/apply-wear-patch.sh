#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ANDROID_DIR=${ANDROID_DIR:-$ROOT_DIR/..}
DEVICE_DIR=$ANDROID_DIR/device/xiaomi/duchamp
PATCH=$ROOT_DIR/patches/device_xiaomi_duchamp/0001-weaR-product.patch
EXPECTED=50f301982df14af45af137ba87c565a459a7e65c

[[ -d "$DEVICE_DIR" ]] || { echo "ERROR: device tree missing; run sync.sh first" >&2; exit 1; }
[[ -f "$PATCH" ]] || { echo "ERROR: patch missing" >&2; exit 1; }

ACTUAL=$(git -C "$DEVICE_DIR" rev-parse HEAD)
[[ "$ACTUAL" == "$EXPECTED" ]] || {
    echo "ERROR: refusing to patch unexpected Snapboss revision" >&2
    echo "Expected: $EXPECTED" >&2
    echo "Actual:   $ACTUAL" >&2
    exit 1
}

if grep -q 'wear_duchamp.mk' "$DEVICE_DIR/AndroidProducts.mk"; then
    echo "WeaR product already present."
    exit 0
fi

git -C "$DEVICE_DIR" apply --check "$PATCH"
git -C "$DEVICE_DIR" apply "$PATCH"
echo "WeaR product patch applied to Snapboss tree."