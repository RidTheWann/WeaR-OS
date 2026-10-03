# WeaR OS Bring-up

## B0 — Device-tree integrity

The repository must contain a conventional duchamp device tree with valid
Android build metadata, VINTF XML, extraction manifests and Python helpers.

Validation is performed by GitHub Actions on every push and pull request.

## B1 — Android source synchronization

Initialize the LineageOS 23.1 source outside this repository and add this
repository as the device/xiaomi/duchamp project through the local manifest.

The selected dependency revisions must be verified before compilation.

## B2 — First compile

Build the device product:

    wear_duchamp-userdebug

The first compile is a compatibility test. Record Soong, Make, VINTF, SELinux,
linker, vendor and kernel-interface failures before changing the source stack.

## B3 — Device validation

After flashing, validate boot, ADB, display, touch, audio, camera, Wi-Fi,
Bluetooth, cellular/IMS, sensors, NFC, USB/OTG, UDFPS, charging, thermal
behavior and sleep/wake.

## B4 — WeaR feature layer

Only after the hardware baseline is boot-verified should WeaR-specific
framework, SystemUI, Settings, performance and game-mode features be added.

Changes should be isolated by subsystem so failures can be bisected cleanly.
