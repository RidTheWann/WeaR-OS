#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Build the unmodified LineageOS duchamp baseline used as the first WeaR OS milestone.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
JOBS="${JOBS:-4}"

cd "$ANDROID_DIR"

[[ -f build/envsetup.sh ]] || {
    echo "ERROR: Android source tree not found at $ANDROID_DIR" >&2
    echo "Run scripts/sync.sh first." >&2
    exit 1
}

# The first milestone deliberately builds the upstream product. Product customization
# is introduced only after the device baseline is boot-verified.
source build/envsetup.sh

lunch lineage_duchamp-userdebug

echo "==> Building LineageOS duchamp baseline"
echo "    jobs: $JOBS"
echo "    product: lineage_duchamp-userdebug"

mka bacon -j"$JOBS"

echo
echo "Build finished. Check out/target/product/duchamp/ for artifacts."
