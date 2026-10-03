# WeaR OS

WeaR OS is a custom AOSP/LineageOS-based operating system for the Xiaomi/POCO duchamp platform.

## Project status

**Stage:** Bring-up / source integration

The first development milestone intentionally stays close to the LineageOS 23.1 base. Device-specific repositories are consumed as independent Git projects so upstream changes remain traceable and proprietary blobs are not vendored into this repository.

## Target device

- Device: POCO X6 Pro 5G / Redmi K70E
- Codename: duchamp
- Platform: MediaTek MT6897
- Architecture: arm64 / ARMv9-A

## Source policy

WeaR OS does not redistribute proprietary Xiaomi/MediaTek blobs in this repository. The build manifest references the required source repositories and the device extraction workflow is expected to be performed from legally obtained stock firmware or an existing device installation.

## Initial target

1. Reproduce a clean LineageOS 23.1 duchamp build.
2. Verify the full hardware bring-up.
3. Establish the WeaR product identity.
4. Introduce custom features only after the baseline is known-good.

## License

The licensing of each upstream component remains with its respective copyright holder. WeaR-specific source files will use SPDX identifiers and will document their applicable license.

## Credits

WeaR OS builds on the Android Open Source Project and LineageOS ecosystems and relies on the duchamp community's device, kernel, vendor, and MediaTek integration work.
