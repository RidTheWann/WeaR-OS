#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Collect and verify the flashable OTA artifact from an Android build.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -n "${ANDROID_DIR:-}" ]]; then
    :
elif [[ -f "$ROOT_DIR/../build/envsetup.sh" ]]; then
    ANDROID_DIR="$ROOT_DIR/.."
elif [[ -f "$ROOT_DIR/../../build/envsetup.sh" ]]; then
    ANDROID_DIR="$ROOT_DIR/../.."
else
    ANDROID_DIR="$ROOT_DIR/.."
fi

PRODUCT_DIR="$ANDROID_DIR/out/target/product/duchamp"
ARTIFACT_DIR="$ANDROID_DIR/wear-artifacts"

[[ -d "$PRODUCT_DIR" ]] || {
    echo "ERROR: product output directory does not exist: $PRODUCT_DIR" >&2
    exit 1
}

rm -rf "$ARTIFACT_DIR"
mkdir -p "$ARTIFACT_DIR"

OTA=""
while IFS= read -r -d '' zipfile; do
    if unzip -l "$zipfile" 2>/dev/null | grep -q 'payload.bin'; then
        OTA="$zipfile"
        break
    fi
done < <(find "$PRODUCT_DIR" -maxdepth 1 -type f -name '*.zip' -print0 | sort -z)

if [[ -z "$OTA" ]]; then
    echo "ERROR: no OTA ZIP containing payload.bin was found." >&2
    echo "Available ZIP files:" >&2
    find "$PRODUCT_DIR" -maxdepth 1 -type f -name '*.zip' -printf '  %f\n' >&2 || true
    exit 1
fi

cp -f "$OTA" "$ARTIFACT_DIR/$(basename "$OTA")"

echo "==> Flashable OTA:"
echo "    $(basename "$OTA")"

sha256sum "$ARTIFACT_DIR/$(basename "$OTA")" > "$ARTIFACT_DIR/SHA256SUMS"

# Preserve the exact local manifest used by repo sync, including the rendered
# immutable WeaR revision passed to the workflow.
if [[ -f "$ANDROID_DIR/.repo/local_manifests/wear-duchamp.xml" ]]; then
    cp -f "$ANDROID_DIR/.repo/local_manifests/wear-duchamp.xml" "$ARTIFACT_DIR/source-manifest.xml"
else
    cp -f "$ROOT_DIR/manifests/duchamp-lineage-23.1.xml" "$ARTIFACT_DIR/source-manifest.xml"
fi

cat > "$ARTIFACT_DIR/build-info.txt" <<EOF
WeaR OS build
Build product: ${BUILD_PRODUCT:-unknown}
Source stack: ${STACK:-unknown}
Lineage reference: ${LINEAGE_REF:-unknown}
WeaR reference: ${WEAR_REF:-unknown}
Build commit: ${GITHUB_SHA:-unknown}
ROM: $(basename "$OTA")
ROM size bytes: $(stat -c '%s' "$ARTIFACT_DIR/$(basename "$OTA")")
EOF

echo
cat "$ARTIFACT_DIR/SHA256SUMS"
echo
cat "$ARTIFACT_DIR/build-info.txt"