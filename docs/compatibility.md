# WeaR OS Compatibility Matrix

Audit date: 2026-10-03

## Target stack

| Layer | Project | Current WeaR selection | Status |
| --- | --- | --- | --- |
| Base | LineageOS | lineage-23.1 | Required |
| Device tree | snapboss/device_xiaomi_duchamp | 50f301982df14af45af137ba87c565a459a7e65c | Supplied baseline |
| Kernel outputs | mt6897-devs/device_xiaomi_duchamp-kernel | a2fd5cb97fd76a4eb61fcfe11af03ae74bd57416 | Compatibility test required |
| Vendor | mt6897-devs/vendor_xiaomi_duchamp | 38c572c3914d90970dce609fef9186cd6decf1db | Compatibility test required |
| MediaTek sepolicy | LineageOS/android_device_mediatek_sepolicy_vndr | 1b12039600b2ad9b1a435682bc8f61fd1f0b111d | Locked |
| MediaTek hardware | LineageOS/android_hardware_mediatek | 68f9be72a32bca66e7c63d69e9739b18f13c8b48 | Locked |
| Xiaomi hardware | mt6897-devs/hardware_xiaomi | 37fe5e4a6acbce4ca3d91e059fd7bd60a0890540 | Locked |
| Dolby | Pong-Development/hardware_dolby | 6300a4e30757d5810d62b2df0cff973ec438a70f | Compatibility test required |
| Camera app | Nothing-2A/android_packages_apps_Aperture | a4c34aa57ed56de60f29349a1e6d20cf8160ca15 | Required by common phone product |

## Important boundary

The supplied Snapboss device tree is a LineageOS 23.1 branch snapshot. The public duchamp kernel and vendor repositories expose multiple Android 16 / Lineage branches, including 23.0 and 23.2-era lines.

The current WeaR manifest deliberately does not mix-and-match branch tips automatically. It uses fixed revisions so a build failure can be reproduced.

## Validation order

When changing a dependency:

1. Change the dependency reference.
2. Run source validation.
3. Build the baseline.
4. Record build errors and affected interfaces.
5. Boot-test before changing another dependency.

Never update device tree, kernel, and vendor independently while debugging a compatibility failure.

## Security patch boundary

The supplied device tree advertises an older boot/vendor security-patch level than the latest public duchamp tree. Do not raise the reported patch level simply to make the ROM look current. Update the device/vendor source from a matching firmware base first, then verify the resulting patch level from the built images and runtime properties.
