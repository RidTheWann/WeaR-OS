# WeaR OS Source Reference

## Authoritative device tree

WeaR OS is derived from the LineageOS device tree supplied for this project:

    https://github.com/snapboss/device_xiaomi_duchamp.git

Branch:

    lineage-23.1

Pinned device-tree commit:

    50f301982df14af45af137ba87c565a459a7e65c

That repository is the device implementation reference. We do not replace it
with another duchamp device tree without an explicit project decision.

## What the reference supplies

The Snapboss tree includes the complete duchamp device integration used by
WeaR OS, including device/product build files, native shims, UDFPS handling,
vibrator implementation, overlays, SELinux policy, power/thermal configuration,
audio/media configuration, VINTF manifests/matrices, init/rootdir files, and
proprietary extraction definitions.

## Reference-derived product strategy

Alpha bring-up inherits the reference `lineage_duchamp.mk` so that the hardware
configuration remains as close as possible to the known reference build.
WeaR overrides only the ROM identity. This is intentional: the first milestone
is to prove the reference hardware path before introducing invasive changes.

## Proprietary baseline

The reference tree's proprietary-files definition is based on:

    duchamp_global-user
    Android 15
    AP3A.240905.015.A2
    OS2.0.206.0.VNLMIXM
    release-keys

WeaR OS does not copy proprietary blobs into this repository.

## Optional components

The Snapboss tree conditionally includes `device/xiaomi/duchamp-miuicamera`.
We intentionally leave that optional dependency out of the first manifest to keep
the baseline minimal. It can be added later if the build or camera feature set
requires it.
