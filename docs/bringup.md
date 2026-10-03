# WeaR OS Bring-up Procedure

## Scope

The first engineering milestone is not a performance ROM. It is a reproducible, bootable duchamp baseline.

### Milestone B0 — Source integrity

Confirm:

- LineageOS source is on `lineage-23.1`.
- `device/xiaomi/duchamp` resolves to the pinned Snapboss commit.
- Kernel, vendor, MediaTek, Xiaomi, Dolby, and Aperture projects resolve to the SHAs in `manifests/duchamp-lineage-23.1.xml`.
- No proprietary blobs are committed to the WeaR OS repository.

### Milestone B1 — Blob completeness

Run `scripts/extract-blobs.sh` against an authorized duchamp installation or otherwise populate the vendor tree through the supported extraction workflow.

Do not proceed to tuning until extraction completes without missing mandatory files.

### Milestone B2 — Baseline compilation

Run:

    scripts/build.sh

Expected initial target:

    lineage_duchamp-userdebug

The baseline must be built before introducing WeaR-specific framework, SystemUI, kernel, thermal, or scheduler changes.

### Milestone B3 — Hardware validation

Record the following after first boot:

| Subsystem | Required result |
| --- | --- |
| Boot / ADB | PASS |
| Display / touch | PASS |
| Audio / microphone | PASS |
| Wi-Fi | PASS |
| Bluetooth | PASS |
| Cellular / IMS | PASS |
| Camera | PASS |
| Fingerprint / UDFPS | PASS |
| NFC | PASS |
| Sensors | PASS |
| USB / OTG | PASS |
| Charging | PASS |
| Thermal behavior | PASS |
| Sleep / wake | PASS |

Any failed subsystem becomes a tracked issue before performance work begins.

## Version compatibility note

The supplied Snapboss device tree is a LineageOS 23.1 tree. At the time this project was initialized, the public duchamp kernel/vendor repositories used by the community exposed newer 23.2-era revisions. The manifest therefore pins exact commits and treats cross-component compatibility as an engineering item to verify, rather than assuming it.

A build is not considered release-ready merely because it compiles.

## WeaR customization rule

Once B0–B3 pass, changes are introduced one layer at a time:

1. Product identity.
2. Resource overlays.
3. Settings/SystemUI features.
4. Performance service and profiles.
5. Power/thermal changes.
6. Kernel changes.

Every layer must have a before/after test result and a clean rollback path.
