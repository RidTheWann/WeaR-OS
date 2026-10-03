# WeaR OS Architecture

## Repository role

WeaR OS is intentionally a thin customization layer on top of AOSP and LineageOS. The repository is consumed as a repo-managed project under vendor/wear.

The Android source tree remains responsible for:

- AOSP framework and build system
- LineageOS common features
- device hardware integration
- MediaTek platform code
- vendor and kernel projects

WeaR OS owns:

- product registration
- build identity
- future SystemUI and Settings features
- future performance services
- project documentation and validation tooling

## Dependency graph

    AOSP
      |
      +-- LineageOS common configuration
      |
      +-- device/xiaomi/duchamp
      |      |
      |      +-- MediaTek hardware
      |      +-- Xiaomi hardware
      |      +-- vendor/xiaomi/duchamp
      |      +-- device/xiaomi/duchamp-kernel
      |
      +-- vendor/wear
             |
             +-- wear_duchamp product
             +-- future WeaR components

## Design rule

Hardware bring-up and ROM customization are separate layers.

A hardware change belongs in the device tree, vendor integration, HAL, sepolicy, or kernel repository that owns it. A WeaR feature belongs in this repository or in the upstream component that the feature actually modifies.

This prevents performance tweaks from being mixed with hardware fixes and makes regression analysis possible.

## Build stages

### Stage B0 — source integrity

The manifest resolves the required dependency projects and exact revision locks.

### Stage B1 — blob completeness

Required proprietary files are extracted from an authorized stock source.

### Stage B2 — baseline build

Build lineage_duchamp-userdebug before changing the WeaR product.

### Stage B3 — WeaR build

Build wear_duchamp-userdebug after the baseline is known-good.

### Stage B4 — feature development

Introduce one subsystem at a time:

1. product identity
2. overlays
3. Settings/SystemUI
4. performance service
5. power and thermal policy
6. kernel changes

Every stage keeps a reproducible rollback point.
