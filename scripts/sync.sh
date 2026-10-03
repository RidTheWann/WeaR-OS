#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ANDROID_DIR=${ANDROID_DIR:-$ROOT_DIR/..}
JOBS=${JOBS:-4}

command -v repo >/dev/null 2>&1 || { echo "ERROR: repo is not installed" >&2; exit 1; }
cd "$ANDROID_DIR"
repo init -u https://github.com/LineageOS/android.git -b lineage-23.1 --git-lfs
mkdir -p .repo/local_manifests
cat > .repo/local_manifests/wear-device.xml <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <remote name="github" fetch="https://github.com/" />
    <project path="device/xiaomi/duchamp" name="snapboss/device_xiaomi_duchamp" remote="github" revision="50f301982df14af45af137ba87c565a459a7e65c" />
</manifest>
XML

repo sync -c --no-clone-bundle --no-tags -j"$JOBS"
echo "Snapboss duchamp source synchronized."
echo "Run bash $ROOT_DIR/scripts/verify-source.sh before applying WeaR changes."