# WeaR OS Source Reference

## Primary hardware baseline

Repository:

    https://github.com/snapboss/device_xiaomi_duchamp.git

Reference branch:

    lineage-23.1

Pinned commit:

    50f301982df14af45af137ba87c565a459a7e65c

The Snapboss tree is the initial hardware baseline for this device tree.

## LineageOS-style engineering reference

Repository:

    https://github.com/Saikrishna1504/device_xiaomi_duchamp.git

Saikrishna's tree is a useful reference for the conventional duchamp device-tree
layout and device-side implementation style used by a LineageOS-derived ROM.

It is not treated as an automatic replacement for the pinned hardware baseline.
Subsystem changes are evaluated against the selected Android base, vendor blobs,
kernel integration, VINTF and SELinux contracts before adoption.

## Repository boundary

WeaR OS is maintained as an actual device/xiaomi/duchamp repository.

The AOSP/LineageOS source checkout lives outside this repository and pulls this
tree through a repo manifest. Proprietary payloads and signing material remain
outside version control.
