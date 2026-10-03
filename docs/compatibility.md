# WeaR OS Compatibility Matrix

Audit date: 2026-10-03

## Primary bring-up stack

The primary stack is **23.1-snapboss**, because the project's device-source baseline is the Snapboss LineageOS tree supplied for this project. It uses the current public duchamp device tree together with the matching 23.2-era kernel/vendor integration.

| Layer | Project | Selected revision | Status |
| --- | --- | --- | --- |
| Base | LineageOS | lineage-23.2 / current branch head eabe68377217a88c81fa933db0136ea4146ff369 | Primary |
| Device tree | mt6897-devs/device_xiaomi_duchamp | 6a2cf3be024e42cea0c22cbae7bf16f5def1309d | Primary |
| Kernel outputs | mt6897-devs/device_xiaomi_duchamp-kernel | a2fd5cb97fd76a4eb61fcfe11af03ae74bd57416 | Primary |
| Vendor | mt6897-devs/vendor_xiaomi_duchamp | 38c572c3914d90970dce609fef9186cd6decf1db | Primary |
| MediaTek sepolicy | LineageOS/android_device_mediatek_sepolicy_vndr | 1b12039600b2ad9b1a435682bc8f61fd1f0b111d | Locked |
| MediaTek hardware | LineageOS/android_hardware_mediatek | 68f9be72a32bca66e7c63d69e9739b18f13c8b48 | Locked |
| Xiaomi hardware | mt6897-devs/hardware_xiaomi | 37fe5e4a6acbce4ca3d91e059fd7bd60a0890540 | Locked |
| Dolby | Pong-Development/hardware_dolby | 6300a4e30757d5810d62b2df0cff973ec438a70f | Locked |
| Camera app | Nothing-2A/android_packages_apps_Aperture | fff44683f5939a33eece44a8fc7611d1a60ad841 | Lineage 23.2 |

The current duchamp device tree was updated against HyperOS OS3.0.9.0.WNLMIXM in September 2026 and contains fixes/features newer than the supplied Snapboss snapshot, including updated blobs/firmware references, touch AIDL integration, sensor fixes, and power-off alarm configuration.

## Experimental compatibility stack

A separately maintained **23.2-experimental** profile is retained for compatibility research:

| Layer | Project | Selected revision |
| --- | --- | --- |
| Base | LineageOS | lineage-23.1 branch |
| Device tree | snapboss/device_xiaomi_duchamp | 50f301982df14af45af137ba87c565a459a7e65c |
| Kernel outputs | mt6897-devs/device_xiaomi_duchamp-kernel | a2fd5cb97fd76a4eb61fcfe11af03ae74bd57416 |
| Vendor | mt6897-devs/vendor_xiaomi_duchamp | 38c572c3914d90970dce609fef9186cd6decf1db |

This profile is experimental and must not replace the Snapboss source-of-truth until its complete dependency set is verified and boot-tested.

## Why the split exists

The Snapboss tree is a LineageOS 23.1 snapshot, while the kernel and vendor revisions selected for the project are from the 23.2-era duchamp stack. Using the current 23.2 device tree aligns the device configuration with those revisions and includes later device-specific fixes.

No compatibility claim is made merely from matching branch names. The exact stack must compile, boot, and pass the hardware checklist before it becomes a release candidate.

## Validation order

When changing a dependency:

1. change the dependency reference
2. run repository validation
3. sync the exact stack
4. verify every project revision
5. build
6. capture compiler/VINTF/runtime failures
7. boot-test
8. validate hardware before changing another dependency

Never update device tree, kernel, and vendor independently while diagnosing a failure.

## Security patch provenance

Do not increase the reported security patch level by changing properties alone. The patch level must come from the matching source/firmware baseline and must be verified in the built images and runtime properties.

## Source records

The exact source state used by a build is preserved in `source-manifest.xml` and `build-info.txt`.
