# WeaR OS

WeaR OS is a custom AOSP/LineageOS-based operating system for the Xiaomi/POCO duchamp platform.

## Project status

**Stage:** Bring-up / source integration

The first milestone intentionally stays close to the supplied LineageOS 23.1 duchamp device tree. WeaR-specific features are introduced only after the hardware baseline is compiled and boot-verified.

## Target device

- Device: POCO X6 Pro 5G / Redmi K70E
- Codename: duchamp
- Platform: MediaTek MT6897 / Dimensity 8300 Ultra
- Architecture: arm64 / ARMv9-A

## Architecture

The repository is consumed as a repo-managed project under vendor/wear.

~~~text
AOSP
  |
  +-- LineageOS common configuration
  |
  +-- device/xiaomi/duchamp
  |      +-- MediaTek / Xiaomi integration
  |      +-- vendor/xiaomi/duchamp
  |      +-- device/xiaomi/duchamp-kernel
  |
  +-- vendor/wear
         +-- wear_duchamp product
         +-- future WeaR framework / SystemUI / performance features
~~~

Hardware bring-up stays in the component that owns the hardware. WeaR owns product identity and custom ROM features. This separation keeps regressions traceable.

## Source policy

WeaR OS does not redistribute proprietary Xiaomi/MediaTek blobs in this repository. The build manifest references the required source projects, while blob extraction is performed from an authorized source installation or firmware package.

## Build flow

From the Android source tree:

~~~bash
# Initialize/sync the duchamp stack.
bash /path/to/WeaR-OS/scripts/sync.sh

# Validate the synchronized project revisions.
bash /path/to/WeaR-OS/scripts/verify-source.sh

# First reproduce the hardware baseline.
BUILD_PRODUCT=lineage_duchamp-userdebug bash /path/to/WeaR-OS/scripts/build.sh

# Then build WeaR OS.
BUILD_PRODUCT=wear_duchamp-userdebug bash /path/to/WeaR-OS/scripts/build.sh
~~~

Run repository-only checks with:

~~~bash
bash scripts/validate.sh
~~~

## Bring-up gates

A release is not considered ready merely because it compiles. The current engineering gates are:

1. source validation
2. proprietary extraction
3. baseline compilation
4. first boot
5. hardware validation
6. WeaR product compilation
7. OTA packaging and signing
8. regression testing

See docs/bringup.md and docs/audit.md.

## Compatibility note

The supplied Snapboss device tree is a LineageOS 23.1 snapshot. The public duchamp kernel/vendor ecosystem also exposes newer 23.2-era revisions. The manifest therefore locks exact candidate revisions and treats cross-component compatibility as an explicit test item.

## License

WeaR-specific source is licensed under Apache-2.0 unless a file states otherwise. Third-party components retain their original licenses and attribution requirements.

## Credits

WeaR OS builds on the Android Open Source Project and LineageOS ecosystems and relies on the duchamp community's device, kernel, vendor, MediaTek, Xiaomi, and other open-source integration work.
