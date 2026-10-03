#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Initialize and synchronize the LineageOS source tree for WeaR OS.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
LINEAGE_BRANCH="${LINEAGE_BRANCH:-lineage-23.1}"
JOBS="${JOBS:-4}"

command -v repo >/dev/null 2>&1 || {
    echo "ERROR: 'repo' is not installed or not in PATH." >&2
    exit 1
}

cd "$ANDROID_DIR"

if [[ ! -d ".repo" ]]; then
    echo "==> Initializing LineageOS $LINEAGE_BRANCH"
    repo init -u https://github.com/LineageOS/android.git \
        -b "$LINEAGE_BRANCH" \
        --git-lfs
fi

mkdir -p .repo/local_manifests
install -m 0644 "$ROOT_DIR/manifests/duchamp-lineage-23.1.xml" \
    ".repo/local_manifests/wear-duchamp.xml"

SYNC_ARGS=(
    "-c"
    "--no-clone-bundle"
    "--no-tags"
    "-j$JOBS"
)

if [[ "${FORCE_SYNC:-0}" == "1" ]]; then
    SYNC_ARGS+=("--force-sync")
fi

echo "==> Syncing source with -j$JOBS"
repo sync "${SYNC_ARGS[@]}"

echo
echo "Source synchronization complete."
echo "Next: $ROOT_DIR/scripts/build.sh"
