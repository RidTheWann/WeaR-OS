# WeaR OS Source Provenance

## Primary stack — 23.1-snapboss

The primary bring-up profile uses the exact Snapboss device tree supplied for this project:

| Component | Path | Revision |
| --- | --- | --- |
| Base manifest | LineageOS/android | 7d408383a8f199ba9a72e8a3b4314c6d848b459c |
| Device tree | device/xiaomi/duchamp | snapboss/device_xiaomi_duchamp @ 50f301982df14af45af137ba87c565a459a7e65c |
| Kernel outputs | device/xiaomi/duchamp-kernel | mt6897-devs/device_xiaomi_duchamp-kernel @ a2fd5cb97fd76a4eb61fcfe11af03ae74bd57416 |
| Vendor | vendor/xiaomi/duchamp | mt6897-devs/vendor_xiaomi_duchamp @ 38c572c3914d90970dce609fef9186cd6decf1db |
| MediaTek sepolicy | device/mediatek/sepolicy_vndr | LineageOS/android_device_mediatek_sepolicy_vndr @ 1b12039600b2ad9b1a435682bc8f61fd1f0b111d |
| MediaTek hardware | hardware/mediatek | LineageOS/android_hardware_mediatek @ 68f9be72a32bca66e7c63d69e9739b18f13c8b48 |
| Xiaomi hardware | hardware/xiaomi | mt6897-devs/hardware_xiaomi @ 37fe5e4a6acbce4ca3d91e059fd7bd60a0890540 |
| Dolby integration | hardware/dolby | Pong-Development/hardware_dolby @ 6300a4e30757d5810d62b2df0cff973ec438a70f |
| Aperture | packages/apps/Aperture | Nothing-2A/android_packages_apps_Aperture @ a4c34aa57ed56de60f29349a1e6d20cf8160ca15 |

The LineageOS 23.1 manifest revision used by the primary profile is 7d408383a8f199ba9a72e8a3b4314c6d848b459c.

## Experimental stack — 23.2

The separately maintained 23.2 profile uses the newer community device tree:

    mt6897-devs/device_xiaomi_duchamp
    6a2cf3be024e42cea0c22cbae7bf16f5def1309d

Its base LineageOS manifest uses the 23.2 branch revision recorded in the experimental manifest.

The 23.2 profile remains experimental.

## Reproducibility rules

A release build must record:

1. the LineageOS manifest revision
2. the selected WeaR OS commit
3. every local-manifest project revision
4. generated ROM SHA256

The rendered `.repo/local_manifests/wear-duchamp.xml` is copied to release metadata as `source-manifest.xml`.

## Proprietary components

The WeaR OS repository does not redistribute Xiaomi or MediaTek proprietary blobs. Extraction remains an external build step from firmware or a device installation the builder is authorized to use.
