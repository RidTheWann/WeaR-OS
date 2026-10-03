# WeaR OS Engineering Audit

Audit date: 2026-10-03

## Executive status

The repository has moved from a placeholder into a structured ROM project layer. Product registration, source manifests, validation tooling, documentation, licensing, and CI are present.

The project is **not yet a boot-verified ROM**. The main engineering risk is dependency compatibility between the supplied Snapboss LineageOS 23.1 device tree and the newer public duchamp kernel/vendor revisions.

## Findings and remediation

### A1 — Product registration

The WeaR product is registered through root-level `AndroidProducts.mk` and `Android.bp`, with the actual product definition in `vendor/wear/products/wear_duchamp.mk`.

This mirrors the Android/Lineage product-discovery model: the build system collects product definitions from `AndroidProducts.mk` files and resolves their `PRODUCT_MAKEFILES` entries. The root placement keeps discovery deterministic. 

### A2 — Upstream product contamination

The initial implementation inherited `device/xiaomi/duchamp/lineage_duchamp.mk`, which also contained project-specific maintainer, blur, fingerprint, and branding values.

WeaR now inherits:

- AOSP 64-bit phone foundations
- `device/xiaomi/duchamp/device.mk`
- LineageOS common phone configuration

and owns its own `PRODUCT_NAME`, model, build identity, and future feature layer.

This avoids silently inheriting unrelated upstream ROM policy.

### A3 — WITH_GMS evaluation order

The duchamp `device.mk` evaluates `WITH_GMS` while it is being included. In the supplied tree, this flag selects the EROFS + Virtual A/B path when true.

WeaR therefore defines `WITH_GMS := true` **before** inheriting `device.mk`.

This does not by itself add a Google package set; Lineage's GMS handling is conditional on the corresponding partner-GMS source being present.

### A4 — Source compatibility boundary

The user-supplied Snapboss tree is a LineageOS 23.1 snapshot. The public duchamp ecosystem also exposes newer 23.0/23.2-era kernel and vendor branches and later device-tree revisions.

The current manifest therefore pins exact revisions instead of following branch tips automatically.

Compatibility is explicitly unverified until the exact stack:

1. compiles,
2. boots,
3. passes hardware validation.

A build failure should be debugged as a coordinated dependency-set problem, not by updating one repository at random.

### A5 — Reproducibility

All device/platform dependencies are pinned to immutable commits.

The WeaR project itself is a development dependency and the manifest template uses `main`. `scripts/sync.sh` accepts `WEAR_REF` and renders that exact revision into the local manifest.

Recommended release pattern:

    WEAR_REF=<immutable WeaR commit SHA> bash scripts/sync.sh

This makes the final source state reproducible.

### A6 — Source integrity

`scripts/verify-source.sh` checks:

- exact Git commit IDs
- presence of all expected Git projects
- clean worktrees
- optional exact WeaR revision through `WEAR_REF`

This catches accidental local edits and dependency drift before a release build.

### A7 — Repository validation

`scripts/validate.sh` checks shell syntax, manifest XML, product registration, and required manifest entries. GitHub Actions runs the validation script on pushes and pull requests.

This is intentionally lightweight: it validates repository structure without pretending that GitHub CI can replace a full Android build and device boot test.

### A8 — Security patch provenance

The supplied Snapboss tree advertises an older boot/vendor security-patch level than the latest public duchamp tree.

WeaR must not simply change the property to a newer date. The correct approach is to update the device/vendor source from a matching firmware base and then verify the resulting image and runtime patch levels.

### A9 — Release signing

The supplied device tree uses AOSP test AVB keys during development.

Test keys are suitable for local bring-up only. A public release needs project-controlled signing keys kept outside the repository, with AVB, target-files, and OTA signing performed in a controlled release environment.

### A10 — Proprietary blobs

The device depends on Xiaomi/MediaTek proprietary components.

WeaR does not redistribute those blobs in its own repository. Extraction remains an external build step from an authorized device/firmware source.

### A11 — GitHub language classification

The Android repo layout places WeaR source under `vendor/wear`, which GitHub Linguist may otherwise classify as vendored.

`.gitattributes` explicitly marks `vendor/wear/**` as non-vendored. This only changes GitHub language statistics; it does not alter the Android build graph.

### A12 — Product identity and fingerprint

WeaR intentionally does not inherit the Snapboss fingerprint override from its `lineage_duchamp.mk`.

A production fingerprint must be selected only after deciding the ROM's compatibility/certification strategy and validating the resulting properties. We should not copy a stock fingerprint merely to make the build appear certified.

## Current release gate

A WeaR OS build is not release-ready until all of the following pass:

- source validation
- proprietary extraction/completeness
- baseline compilation
- WeaR compilation
- first boot
- hardware validation
- OTA generation
- AVB/OTA signing with release keys
- clean-install and upgrade testing
- rollback testing
- source-manifest and checksum publication

## Alpha 0.1 non-goals

- kernel overclocking
- undocumented scheduler hacks
- disabling thermal safety mechanisms
- fake benchmark optimizations
- Play Integrity bypass logic

Performance engineering begins only after the hardware baseline is stable and measurable.
