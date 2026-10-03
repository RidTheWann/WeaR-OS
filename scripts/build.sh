#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
BUILD_PRODUCT="${BUILD_PRODUCT:-wear_duchamp-userdebug}"

cd "$ANDROID_DIR"

[[ -f build/envsetup.sh ]] || {
    echo "ERROR: Android source tree not found at $ANDROID_DIR" >&2
    echo "Run scripts/sync.sh first." >&2
    exit 1
}

source build/envsetup.sh
lunch "$BUILD_PRODUCT"

echo "==> Build target: $BUILD_PRODUCT"
echo "==> Starting mka bacon"

if [[ -n "${JOBS:-}" ]]; then
    mka bacon -j"$JOBS"
else
    mka bacon
fi

echo
echo "Build complete: $ANDROID_DIR/out/target/product/duchamp"
