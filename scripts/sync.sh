#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
LINEAGE_REF="${LINEAGE_REF:-7d408383a8f199ba9a72e8a3b4314c6d848b459c}"
WEAR_REF="${WEAR_REF:-main}"
JOBS="${JOBS:-4}"

command -v repo >/dev/null 2>&1 || {
    echo "ERROR: repo is required." >&2
    exit 1
}

[[ -d "$ROOT_DIR/manifests" ]] || {
    echo "ERROR: WeaR manifest directory is missing." >&2
    exit 1
}

cd "$ANDROID_DIR"

echo "==> Initializing LineageOS manifest at $LINEAGE_REF"
repo init -u https://github.com/LineageOS/android.git \
    -b "$LINEAGE_REF" \
    --git-lfs

mkdir -p .repo/local_manifests
python3 - "$ROOT_DIR/manifests/duchamp-lineage-23.1.xml" ".repo/local_manifests/wear-duchamp.xml" "$WEAR_REF" <<'PY'
from pathlib import Path
import sys

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
wear_ref = sys.argv[3]

data = src.read_text(encoding="utf-8")
needle = 'name="RidTheWann/WeaR-OS"\\n        remote="github"\\n        revision="main"'
replacement = 'name="RidTheWann/WeaR-OS"\\n        remote="github"\\n        revision="' + wear_ref + '"'

if needle not in data:
    raise SystemExit("ERROR: WeaR project entry missing from manifest template")

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

echo "==> Syncing duchamp source stack"
repo sync "${SYNC_ARGS[@]}"

cat > .repo/local_manifests/wear-source.env <<EOF
LINEAGE_REF=$LINEAGE_REF
WEAR_REF=$WEAR_REF
JOBS=$JOBS
EOF

echo
echo "Source sync complete."
echo "Next: bash $ROOT_DIR/scripts/verify-source.sh"
