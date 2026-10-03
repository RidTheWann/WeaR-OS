# WeaR OS Dependency Audit

## Source of truth

Primary device source:

    https://github.com/snapboss/device_xiaomi_duchamp.git

Branch: `lineage-23.1`
Commit: `50f301982df14af45af137ba87c565a459a7e65c`

## Dependencies observed directly from the reference tree

The Snapboss tree explicitly references these source paths in BoardConfig.mk, device.mk, Android.bp, and its overlays:

| Path | Role | Selected source |
| --- | --- | --- |
| device/xiaomi/duchamp | Device implementation | snapboss/device_xiaomi_duchamp @ 50f301... |
| device/xiaomi/duchamp-kernel | Prebuilt kernel/modules/DTB | mt6897-devs/device_xiaomi_duchamp-kernel @ 3377ea... |
| vendor/xiaomi/duchamp | Proprietary vendor integration | snapboss/vendor_xiaomi_duchamp @ b9dbdd... |
| hardware/xiaomi | Xiaomi HAL/config support | snapboss/hardware_xiaomi @ d41da4... |
| hardware/mediatek | MediaTek platform support | snapboss/hardware_mediatek @ 72bf36... |
| device/mediatek/sepolicy_vndr | MediaTek vendor SELinux policy | snapboss/device_mediatek_sepolicy_vndr @ 1c63d2... |
| hardware/lineage/interfaces | power-libperfmgr support | LineageOS/android_hardware_lineage_interfaces @ f53e60... |
| hardware/dolby | Dolby product integration | snapboss/hardware_dolby @ 406f38... |
| vendor/qcom/opensource/vibrator | QTI vibrator AIDL service | LineageOS/android_vendor_qcom_opensource_vibrator @ 411ec4... |
| packages/apps/Aperture | target of device Aperture overlay | snapboss/android_packages_apps_Aperture @ 245d64... |

These are pinned in `manifests/duchamp-lineage-23.1.xml` for reproducible bring-up.

## Optional reference dependency

The device tree conditionally includes `device/xiaomi/duchamp-miuicamera`. It is intentionally not part of Alpha 0.1. The build can therefore be tested without making the optional MIUI camera integration another failure point.

## LineageOS base

The primary base manifest is LineageOS `lineage-23.1`, pinned to `7d408383a8f199ba9a72e8a3b4314c6d848b459c` for the initial reproducible source state.

## Important compatibility note

The selected kernel/vendor projects come from the same duchamp development ecosystem but are not inferred to be compatible merely from project names. The first build is the compatibility test. Any failure is recorded before dependency versions are changed.
