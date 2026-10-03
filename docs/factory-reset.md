# WeaR OS Factory Reset Record

Reset date: 2026-10-03

The previous experimental WeaR-OS project state was archived before the reset in:

    archive/pre-factory-reset-2026-10-03

The `main` branch has been rebuilt as a clean foundation whose device source
is explicitly anchored to the supplied Snapboss duchamp LineageOS tree.

## Removed from the active design

- mixed 23.1/23.2 primary stacks
- speculative device-tree replacement
- duplicated nested vendor/wear product tree
- self-generated dependency assumptions not derived from the reference tree
- performance tweaks before first boot
- placeholder implementation code

## Active design

- LineageOS 23.1 base
- Snapboss duchamp device tree as source of truth
- exact dependency revisions recorded in the local manifest
- WeaR product inherits the reference product for first bring-up
- WeaR-specific implementation will be introduced after the baseline builds and boots
