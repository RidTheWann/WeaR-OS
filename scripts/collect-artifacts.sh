#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
PRODUCT_DIR="$ANDROID_DIR/out/target/product/duchamp"
ARTIFACT_DIR="$ANDROID_DIR/wear-artifacts"

[[ -d "$PRODUCT_DIR" ]] || { echo "ERROR: product output is missing: $PRODUCT_DIR" >&2; exit 1; }
rm -rf "$ARTIFACT_DIR"
mkdir -p "$ARTIFACT_DIR"

OTA=""
while IFS= read -r -d '' z; do
    if unzip -l "$z" 2>/dev/null | grep -q 'payload.bin'; then
        OTA="$z"
        break
    fi
done < <(find "$PRODUCT_DIR" -maxdepth 1 -type f -name '*.zip' -print0 | sort -z)

[[ -n "$OTA" ]] || { echo "ERROR: no OTA ZIP containing payload.bin was found." >&2; exit 1; }
cp -f "$OTA" "$ARTIFACT_DIR/$(basename "$OTA")"

sha256sum "$ARTIFACT_DIR/$(basename "$OTA")" > "$ARTIFACT_DIR/SHA256SUMS"

if [[ -d "$ANDROID_DIR/.repo" ]] && command -v repo >/dev/null 2>&1; then
    repo manifest -r > "$ARTIFACT_DIR/source-manifest.xml"
else
    echo "ERROR: repo metadata unavailable; cannot record source state." >&2
    exit 1
fi

cat > "$ARTIFACT_DIR/build-info.txt" <<EOF
WeaR OS build
Build product: ${BUILD_PRODUCT:-unknown}
Lineage ref: ${LINEAGE_REF:-unknown}
WeaR ref: ${WEAR_REF:-unknown}
Build commit: ${GITHUB_SHA:-unknown}
ROM: $(basename "$OTA")
ROM bytes: $(stat -c '%s' "$ARTIFACT_DIR/$(basename "$OTA")")
EOF

cat "$ARTIFACT_DIR/SHA256SUMS"
