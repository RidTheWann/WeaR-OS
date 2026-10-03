# WeaR OS Bring-up

## Gate B0 — Repository integrity

Run:

    bash scripts/validate.sh

Expected result: PASSED.

## Gate B1 — Source synchronization

From the Android source parent directory:

    bash /path/to/WeaR-OS/scripts/sync.sh
    bash /path/to/WeaR-OS/scripts/verify-source.sh

Do not proceed when a project is missing, dirty, or at the wrong revision.

## Gate B2 — First compile

First build the reference product:

    BUILD_PRODUCT=lineage_duchamp-userdebug bash /path/to/WeaR-OS/scripts/build.sh

Then build the custom product:

    BUILD_PRODUCT=wear_duchamp-userdebug bash /path/to/WeaR-OS/scripts/build.sh

The first build is not a performance benchmark. Its purpose is to identify
compiler, Soong, VINTF, sepolicy, module, or vendor compatibility errors.

## Gate B3 — Device validation

After installation/boot, record:

| Function | Required state |
| --- | --- |
| Boot / ADB | PASS |
| Display / touch | PASS |
| Audio / microphone | PASS |
| Wi-Fi | PASS |
| Bluetooth | PASS |
| Cellular / IMS | PASS |
| Camera | PASS |
| UDFPS / fingerprint | PASS |
| NFC | PASS |
| Sensors | PASS |
| USB / OTG | PASS |
| Charging | PASS |
| Thermal | PASS |
| Sleep / wake | PASS |

Any regression blocks performance work.

## Gate B4 — WeaR feature development

Once the hardware baseline is stable, introduce one feature class at a time:

1. branding
2. resource overlays
3. Settings/SystemUI
4. Java/Kotlin services
5. native services
6. power/performance integration
7. kernel changes

Each class must retain a known-good rollback point.
