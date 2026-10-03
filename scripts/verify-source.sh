#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_DIR="${ANDROID_DIR:-$ROOT_DIR/..}"
MANIFEST_FILE="$ANDROID_DIR/.repo/local_manifests/wear-duchamp.xml"

cd "$ANDROID_DIR"

[[ -f "$MANIFEST_FILE" ]] || {
    echo "ERROR: $MANIFEST_FILE does not exist. Run sync.sh first." >&2
    exit 1
}

failures=0

verify_project() {
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
    if ! resolved="$(git -C "$path" rev-parse "$expected^{commit}" 2>/dev/null)"; then
        # The expected revision may be a SHA that exists but is not named by a
        # local branch; cat-file still permits exact object validation.
        if [[ "$expected" =~ ^[0-9a-fA-F]{40}$ ]] && [[ "$(git -C "$path" cat-file -t "$expected" 2>/dev/null || true)" == "commit" ]]; then
            resolved="$expected"
        else
            echo "UNRESOLVED $path @ $expected"
            failures=$((failures + 1))
            return
        fi
    fi

    if [[ "$actual" != "$resolved" ]]; then
        echo "MISMATCH $path"
        echo "         expected: $resolved"
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

python3 - "$MANIFEST_FILE" <<'PY' > /tmp/wear-projects.tsv
import sys
import xml.etree.ElementTree as ET

root = ET.parse(sys.argv[1]).getroot()
for project in root.findall("project"):
    path = project.get("path")
    revision = project.get("revision")
    name = project.get("name", "")
    if not path or not revision:
        raise SystemExit(f"Invalid project entry: {project.attrib}")
    print(f"{path}\\t{revision}\\t{name}")
PY

while IFS=$'\t' read -r path revision name; do
    [[ -n "$path" ]] || continue
    verify_project "$path" "$revision"
done < /tmp/wear-projects.tsv

rm -f /tmp/wear-projects.tsv

if (( failures != 0 )); then
    echo
    echo "Source verification FAILED ($failures project(s))." >&2
    exit 1
fi

echo
echo "Source verification PASSED."
