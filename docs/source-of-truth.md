# WeaR OS Source of Truth

Reference repository:
https://github.com/snapboss/device_xiaomi_duchamp

Branch: lineage-23.1
Commit: 50f301982df14af45af137ba87c565a459a7e65c
Date: 2026-02-07

This commit is the authoritative duchamp device implementation for the initial WeaR OS bring-up.

Observed device-tree responsibilities include BoardConfig, device configuration, HAL/VINTF manifests, native shims, UDFPS, vibrator, overlays, SELinux policy, power, thermal configuration, extraction metadata and vendor integration.

WeaR OS does not replace these implementations. The first custom change is isolated to product registration and identity through an explicit patch.

Compatibility changes must be motivated by a concrete build/runtime failure and recorded as a separate change.