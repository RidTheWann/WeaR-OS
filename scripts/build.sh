#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Build a duchamp baseline or the WeaR product.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "$ROOT_DIR/../build/envsetup.sh" ]]; then
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
elif [[ -f "$ROOT_DIR/../../build/envsetup.sh" ]]; then
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/../..}"
else
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
fi

if [[ -z "${JOBS:-}" ]]; then
    CPU_COUNT="$(nproc 2>/dev/null || printf '2')"
    RAM_GB="$(awk '/MemTotal:/ {printf "%d", $2 / 1024 / 1024}' /proc/meminfo 2>/dev/null || printf '0')"

    if (( RAM_GB >= 64 )); then
        JOBS="$CPU_COUNT"
    elif (( RAM_GB >= 32 )); then
        JOBS="$CPU_COUNT"
        (( JOBS > 8 )) && JOBS=8
    elif (( RAM_GB >= 16 )); then
        JOBS=2
    else
        JOBS=1
    fi
else
    JOBS="$JOBS"
fi

BUILD_PRODUCT="${BUILD_PRODUCT:-wear_duchamp-userdebug}"

cd "$ANDROID_DIR"

[[ -f build/envsetup.sh ]] || {
    echo "ERROR: Android source tree not found at $ANDROID_DIR" >&2
    echo "Run scripts/sync.sh first." >&2
    exit 1
}

source build/envsetup.sh
lunch "$BUILD_PRODUCT"

echo "==> Building $BUILD_PRODUCT"
echo "    jobs: $JOBS"

mka bacon -j"$JOBS"

echo
echo "Build finished. Check out/target/product/duchamp/ for artifacts."
