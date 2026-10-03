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

command -v python3 >/dev/null 2>&1 || {
    echo "ERROR: python3 is required." >&2
    exit 1
}

[[ "$LINEAGE_REF" =~ ^[0-9a-fA-F]{40}$ ]] || {
    echo "ERROR: LINEAGE_REF must be a full 40-character commit SHA." >&2
    exit 1
}

[[ "$WEAR_REF" == "main" || "$WEAR_REF" =~ ^[0-9a-fA-F]{40}$ ]] || {
    echo "ERROR: WEAR_REF must be main or a full 40-character commit SHA." >&2
    exit 1
}

[[ "$JOBS" =~ ^[1-9][0-9]?$ ]] && (( 10#$JOBS <= 64 )) || {
    echo "ERROR: JOBS must be between 1 and 64." >&2
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
import xml.etree.ElementTree as ET

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
wear_ref = sys.argv[3]

if wear_ref != "main":
    if len(wear_ref) != 40 or any(c not in "0123456789abcdefABCDEF" for c in wear_ref):
        raise SystemExit("ERROR: WEAR_REF must be main or a full 40-character commit SHA")

tree = ET.parse(src)
root = tree.getroot()

matches = [
    project for project in root.findall("project")
    if project.get("name") == "RidTheWann/WeaR-OS"
    and project.get("path") == "vendor/wear"
    and project.get("remote") == "github"
]

if len(matches) != 1:
    raise SystemExit(
        f"ERROR: expected exactly one vendor/wear WeaR project entry, found {len(matches)}"
    )

matches[0].set("revision", wear_ref)
tree.write(dst, encoding="utf-8", xml_declaration=True)
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
