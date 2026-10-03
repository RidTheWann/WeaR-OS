# WeaR OS

Custom AOSP/LineageOS ROM project for Xiaomi/POCO duchamp.

## Device

- POCO X6 Pro 5G / Redmi K70E
- Codename: `duchamp`
- SoC: MediaTek Dimensity 8300 Ultra / MT6897

## Authoritative reference

WeaR OS is developed from the LineageOS duchamp device tree supplied for this project:

    https://github.com/snapboss/device_xiaomi_duchamp.git

Branch: `lineage-23.1`
Reference commit: `50f301982df14af45af137ba87c565a459a7e65c`

The device tree is treated as the hardware source of truth. WeaR changes are layered on top of it rather than replacing it with another duchamp tree.

## Project architecture

```text
AOSP / LineageOS
        |
        +-- device/xiaomi/duchamp
        |      +-- Snapboss hardware implementation
        |      +-- shims / UDFPS / vibrator
        |      +-- overlays / sepolicy
        |      +-- power / thermal
        |      +-- VINTF / init / configs
        |
        +-- vendor/xiaomi/duchamp
        +-- MediaTek / Xiaomi dependencies
        |
        +-- vendor/wear
               +-- WeaR product
               +-- future WeaR framework
               +-- future Settings / SystemUI
               +-- future performance services
```

## Current stage

**Alpha 0.1 — reference bring-up**

The first objective is a reproducible build using the exact locked dependency set. Performance and kernel modifications are intentionally deferred until the reference hardware path is boot-verified.

## Build

From the Android source parent:

    bash /path/to/WeaR-OS/scripts/sync.sh
    bash /path/to/WeaR-OS/scripts/verify-source.sh

Reference product:

    BUILD_PRODUCT=lineage_duchamp-userdebug bash /path/to/WeaR-OS/scripts/build.sh

WeaR product:

    BUILD_PRODUCT=wear_duchamp-userdebug bash /path/to/WeaR-OS/scripts/build.sh

See `docs/dependency-audit.md`, `docs/bringup.md`, and `docs/github-actions.md`.
