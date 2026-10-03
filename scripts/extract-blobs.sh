#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Extract device blobs from an authorized duchamp installation.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"

command -v adb >/dev/null 2>&1 || {
    echo "ERROR: adb is not installed or not in PATH." >&2
    exit 1
}

ADB_STATE="$(adb get-state 2>/dev/null || true)"
[[ "$ADB_STATE" == "device" ]] || {
    echo "ERROR: adb device is not connected/authorized." >&2
    adb devices || true
    exit 1
}

DEVICE="$(adb shell getprop ro.product.device | tr -d '\r')"
[[ "$DEVICE" == "duchamp" ]] || {
    echo "ERROR: Connected device reports '$DEVICE', expected 'duchamp'." >&2
    exit 1
}

cd "$ANDROID_DIR/device/xiaomi/duchamp"

echo "==> Extracting proprietary files from $DEVICE"
echo "    Source must be firmware you are authorized to use."

python3 ./extract-files.py

echo
echo "Extraction complete."
