# WeaR OS Source Provenance

## Bring-up lock

The initial duchamp bring-up is tied to these exact revisions:

| Component | Path | Revision |
| --- | --- | --- |
| Device tree | device/xiaomi/duchamp | snapboss/device_xiaomi_duchamp @ 50f301982df14af45af137ba87c565a459a7e65c |
| Kernel outputs | device/xiaomi/duchamp-kernel | mt6897-devs/device_xiaomi_duchamp-kernel @ a2fd5cb97fd76a4eb61fcfe11af03ae74bd57416 |
| Vendor | vendor/xiaomi/duchamp | mt6897-devs/vendor_xiaomi_duchamp @ 38c572c3914d90970dce609fef9186cd6decf1db |
| MediaTek sepolicy | device/mediatek/sepolicy_vndr | LineageOS/android_device_mediatek_sepolicy_vndr @ 1b12039600b2ad9b1a435682bc8f61fd1f0b111d |
| MediaTek hardware | hardware/mediatek | LineageOS/android_hardware_mediatek @ 68f9be72a32bca66e7c63d69e9739b18f13c8b48 |
| Xiaomi hardware | hardware/xiaomi | mt6897-devs/hardware_xiaomi @ 37fe5e4a6acbce4ca3d91e059fd7bd60a0890540 |
| Dolby integration | hardware/dolby | Pong-Development/hardware_dolby @ 6300a4e30757d5810d62b2df0cff973ec438a70f |
| Aperture | packages/apps/Aperture | Nothing-2A/android_packages_apps_Aperture @ a4c34aa57ed56de60f29349a1e6d20cf8160ca15 |

## Compatibility status

The supplied Snapboss device tree is a LineageOS 23.1 tree. The public duchamp kernel and vendor repositories exposed newer 23.2-era revisions at project initialization.

That is recorded as a compatibility condition, not treated as proven compatibility. The source lock becomes a release candidate only after compilation and hardware validation.

## Required gates

1. Source verification passes.
2. Baseline compilation succeeds.
3. First boot succeeds.
4. Hardware validation passes.
5. WeaR-specific changes are tested independently from the baseline.

## Proprietary components

The WeaR OS repository does not redistribute Xiaomi or MediaTek proprietary blobs. Use the supported extraction workflow with firmware or a device installation you are authorized to use.
