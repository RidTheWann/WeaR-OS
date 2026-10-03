#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Check the host before a full Android build. Warnings are informational.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "$ROOT_DIR/../build/envsetup.sh" ]]; then
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
elif [[ -f "$ROOT_DIR/../../build/envsetup.sh" ]]; then
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/../..}"
else
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
fi

echo "WeaR OS build-host check"
echo "Android tree: $ANDROID_DIR"
echo

ARCH="$(uname -m 2>/dev/null || echo unknown)"
CPU="$(nproc 2>/dev/null || echo unknown)"
RAM_GB="$(awk '/MemTotal:/ {printf "%d", $2 / 1024 / 1024}' /proc/meminfo 2>/dev/null || echo 0)"
DISK_GB="$(df -Pk "$ANDROID_DIR" 2>/dev/null | awk 'NR==2 {printf "%d", $4 / 1024 / 1024}' || echo 0)"

echo "Architecture : $ARCH"
echo "CPU threads  : $CPU"
echo "RAM          : ${RAM_GB} GiB"
echo "Free storage : ${DISK_GB} GiB"
echo

if [[ "$ARCH" != "x86_64" ]]; then
    echo "WARN: x86_64 is the expected host architecture for this build workflow."
fi

if (( RAM_GB < 32 )); then
    echo "WARN: Less than 32 GiB RAM. Android builds may be slow or memory constrained."
elif (( RAM_GB < 64 )); then
    echo "NOTE: 32-63 GiB RAM is workable, but 64 GiB+ is preferable for modern LineageOS builds."
else
    echo "OK: RAM is in the preferred range."
fi

if (( DISK_GB < 300 )); then
    echo "WARN: Less than 300 GiB free storage remains on the source filesystem."
elif (( DISK_GB < 400 )); then
    echo "NOTE: 300-399 GiB free. Leave additional space for ccache and build artifacts."
else
    echo "OK: Storage is in the preferred range."
fi

echo
echo "This check does not validate the Android source or device tree."
