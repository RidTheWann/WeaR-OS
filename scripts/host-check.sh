#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

ANDROID_DIR="${ANDROID_DIR:-$(pwd)}"
ARCH="$(uname -m 2>/dev/null || echo unknown)"
CPU="$(nproc 2>/dev/null || echo unknown)"
RAM_GB="$(awk '/MemTotal:/ {printf "%d", $2 / 1024 / 1024}' /proc/meminfo 2>/dev/null || echo 0)"
FREE_GB="$(df -Pk "$ANDROID_DIR" 2>/dev/null | awk 'NR==2 {printf "%d", $4 / 1024 / 1024}' || echo 0)"

echo "WeaR OS build host"
echo "Architecture : $ARCH"
echo "CPU threads  : $CPU"
echo "RAM          : ${RAM_GB} GiB"
echo "Free storage : ${FREE_GB} GiB"

[[ "$ARCH" == "x86_64" ]] || echo "WARN: x86_64 is recommended."
(( RAM_GB >= 32 )) || echo "WARN: Less than 32 GiB RAM may be heavily constrained."
(( FREE_GB >= 300 )) || echo "WARN: Less than 300 GiB free storage remains."
