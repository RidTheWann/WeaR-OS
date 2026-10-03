#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ANDROID_DIR=${ANDROID_DIR:-$ROOT_DIR/..}
DEVICE_DIR=$ANDROID_DIR/device/xiaomi/duchamp
EXPECTED=50f301982df14af45af137ba87c565a459a7e65c

[[ -d "$DEVICE_DIR" ]] || { echo "ERROR: device tree missing" >&2; exit 1; }
ACTUAL=$(git -C "$DEVICE_DIR" rev-parse HEAD)
[[ "$ACTUAL" == "$EXPECTED" ]] || { echo "ERROR: Snapboss revision mismatch: $ACTUAL" >&2; exit 1; }

echo "OK: Snapboss duchamp @ $ACTUAL"
echo "Source-of-truth verification passed."