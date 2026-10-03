#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Verify the project revisions declared by the active local manifest.

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

MANIFEST_FILE=".repo/local_manifests/wear-duchamp.xml"
SOURCE_ENV=".repo/local_manifests/wear-source.env"

[[ -f "$MANIFEST_FILE" ]] || {
    echo "MISSING  $MANIFEST_FILE" >&2
    echo "Run scripts/sync.sh first." >&2
    exit 1
}

failures=0

if [[ -f "$SOURCE_ENV" ]]; then
    # shellcheck disable=SC1090
    source "$SOURCE_ENV"
else
    STACK="${STACK:-}"
    LINEAGE_REF="${LINEAGE_REF:-}"
    WEAR_REF="${WEAR_REF:-}"
fi

resolve_project_ref() {
    local path="$1"
    local expected="$2"
    local resolved=""

    if resolved="$(git -C "$path" rev-parse "$expected^{commit}" 2>/dev/null)"; then
        printf '%s\n' "$resolved"
        return 0
    fi

    if [[ "$expected" =~ ^[0-9a-fA-F]{40}$ ]]; then
        if resolved="$(git -C "$path" cat-file -t "$expected" 2>/dev/null)" && [[ "$resolved" == "commit" ]]; then
            printf '%s\n' "$expected"
            return 0
        fi
    fi

    while IFS= read -r remote; do
        [[ -n "$remote" ]] || continue
        if resolved="$(git -C "$path" rev-parse "$remote/$expected^{commit}" 2>/dev/null)"; then
            printf '%s\n' "$resolved"
            return 0
        fi
    done < <(git -C "$path" remote)

    return 1
}

verify_repo() {
    local path="$1"
    local expected="$2"
    local actual

    if ! git -C "$path" rev-parse --git-dir >/dev/null 2>&1; then
        echo "MISSING  $path"
        failures=$((failures + 1))
        return
    fi

    actual="$(git -C "$path" rev-parse HEAD)"

    local resolved
    if ! resolved="$(resolve_project_ref "$path" "$expected")"; then
        echo "UNRESOLVED $path @ $expected"
        failures=$((failures + 1))
        return
    fi

    if [[ "$actual" != "$resolved" ]]; then
        echo "MISMATCH $path"
        echo "         expected: $resolved (manifest: $expected)"
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

# Validate the Lineage manifest repository itself when LINEAGE_REF is immutable.
LINEAGE_REF="${LINEAGE_REF:-}"
if [[ -n "$LINEAGE_REF" ]]; then
    if ! git -C ".repo/manifests" rev-parse --git-dir >/dev/null 2>&1; then
        echo "MISSING  .repo/manifests"
        failures=$((failures + 1))
    else
        resolved_manifest="$(git -C ".repo/manifests" rev-parse "$LINEAGE_REF^{commit}" 2>/dev/null || true)"
        actual_manifest="$(git -C ".repo/manifests" rev-parse HEAD 2>/dev/null || true)"
        if [[ -z "$resolved_manifest" || "$actual_manifest" != "$resolved_manifest" ]]; then
            echo "MISMATCH .repo/manifests"
            echo "         expected: $LINEAGE_REF -> $resolved_manifest"
            echo "         actual:   $actual_manifest"
            failures=$((failures + 1))
        else
            echo "OK       .repo/manifests @ $actual_manifest"
        fi
    fi
fi

# The local manifest is authoritative for device-specific projects.
python3 - "$MANIFEST_FILE" <<'PY' > /tmp/wear-projects.tsv
import sys
import xml.etree.ElementTree as ET

root = ET.parse(sys.argv[1]).getroot()
for project in root.findall("project"):
    path = project.get("path")
    revision = project.get("revision")
    name = project.get("name")
    if not path or not revision:
        raise SystemExit(f"Invalid project entry: {project.attrib}")
    print(f"{path}\t{revision}\t{name or ''}")
PY

while IFS=$'\t' read -r path revision name; do
    [[ -n "$path" ]] || continue
    verify_repo "$path" "$revision"
done < /tmp/wear-projects.tsv

rm -f /tmp/wear-projects.tsv

if (( failures != 0 )); then
    echo
    echo "Source verification FAILED ($failures project(s))." >&2
    exit 1
fi

echo
echo "Source verification PASSED."
