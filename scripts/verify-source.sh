#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Verify exact upstream revisions declared by the WeaR bring-up manifest.
# Run this before a release build, after repo sync has completed.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "$ROOT_DIR/../build/envsetup.sh" ]]; then
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
elif [[ -f "$ROOT_DIR/../../build/envsetup.sh" ]]; then
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/../..}"
else
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
fi

cd "$ANDROID_DIR"

failures=0

verify_repo() {
    local path="$1"
    local expected="$2"
    local actual
    local git_dir

    if ! git_dir="$(git -C "$path" rev-parse --git-dir 2>/dev/null)"; then
        echo "MISSING  $path"
        failures=$((failures + 1))
        return
    fi

    actual="$(git -C "$path" rev-parse HEAD)"
    if [[ "$actual" != "$expected" ]]; then
        echo "MISMATCH $path"
        echo "         expected: $expected"
        echo "         actual:   $actual"
        failures=$((failures + 1))
        return
    fi

    if [[ -n "$(git -C "$path" status --porcelain --untracked-files=all)" ]]; then
        echo "DIRTY    $path"
        failures=$((failures + 1))
        return
    fi

    echo "OK       $path @ $actual"
}

LINEAGE_REF="${LINEAGE_REF:-}"
if [[ -n "$LINEAGE_REF" && "$LINEAGE_REF" =~ ^[0-9a-fA-F]{40}$ ]]; then
    if [[ ! -d ".repo/manifests" ]]; then
        echo "MISSING  .repo/manifests"
        failures=$((failures + 1))
    else
        verify_repo ".repo/manifests" "$LINEAGE_REF"
    fi
fi

WEAR_REF="${WEAR_REF:-}"
if [[ -n "$WEAR_REF" ]]; then
    verify_repo "vendor/wear" "$WEAR_REF"
fi

verify_repo "device/xiaomi/duchamp" "50f301982df14af45af137ba87c565a459a7e65c"
verify_repo "device/xiaomi/duchamp-kernel" "a2fd5cb97fd76a4eb61fcfe11af03ae74bd57416"
verify_repo "vendor/xiaomi/duchamp" "38c572c3914d90970dce609fef9186cd6decf1db"
verify_repo "device/mediatek/sepolicy_vndr" "1b12039600b2ad9b1a435682bc8f61fd1f0b111d"
verify_repo "hardware/mediatek" "68f9be72a32bca66e7c63d69e9739b18f13c8b48"
verify_repo "hardware/xiaomi" "37fe5e4a6acbce4ca3d91e059fd7bd60a0890540"
verify_repo "hardware/dolby" "6300a4e30757d5810d62b2df0cff973ec438a70f"
verify_repo "packages/apps/Aperture" "a4c34aa57ed56de60f29349a1e6d20cf816ca15"

if (( failures != 0 )); then
    echo
    echo "Source verification FAILED ($failures project(s))." >&2
    exit 1
fi

echo
echo "Source verification PASSED."
