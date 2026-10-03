#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Initialize and synchronize the LineageOS source tree for WeaR OS.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "$ROOT_DIR/../build/envsetup.sh" ]]; then
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
elif [[ -f "$ROOT_DIR/../../build/envsetup.sh" ]]; then
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/../..}"
else
    ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
fi

LINEAGE_BRANCH="${LINEAGE_BRANCH:-lineage-23.1}"
JOBS="${JOBS:-4}"
WEAR_REF="${WEAR_REF:-main}"

command -v repo >/dev/null 2>&1 || {
    echo "ERROR: 'repo' is not installed or not in PATH." >&2
    exit 1
}

cd "$ANDROID_DIR"

repo init -u https://github.com/LineageOS/android.git \
    -b "$LINEAGE_BRANCH" \
    --git-lfs

mkdir -p .repo/local_manifests
MANIFEST_OUT=".repo/local_manifests/wear-duchamp.xml"

# Render the local manifest with an explicit WeaR revision. Development defaults
# to main; release builds should pass an immutable commit SHA.
python3 - "$ROOT_DIR/manifests/duchamp-lineage-23.1.xml" "$MANIFEST_OUT" "$WEAR_REF" <<'PY'
from pathlib import Path
import sys

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
wear_ref = sys.argv[3]

data = src.read_text(encoding="utf-8")
needle = '''name="RidTheWann/WeaR-OS"
        remote="github"
        revision="main"'''
replacement = f'''name="RidTheWann/WeaR-OS"
        remote="github"
        revision="{wear_ref}"'''

if needle not in data:
    raise SystemExit("ERROR: WeaR project entry was not found in the manifest template.")

dst.write_text(data.replace(needle, replacement, 1), encoding="utf-8")
PY

SYNC_ARGS=(
    "-c"
    "--no-clone-bundle"
    "--no-tags"
    "-j$JOBS"
)

if [[ "${FORCE_SYNC:-0}" == "1" ]]; then
    SYNC_ARGS+=("--force-sync")
fi

echo "==> Syncing LineageOS $LINEAGE_BRANCH with WeaR ref $WEAR_REF"
repo sync "${SYNC_ARGS[@]}"

echo
echo "Source synchronization complete."
echo "Run scripts/verify-source.sh before the first build."
