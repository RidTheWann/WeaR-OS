# WeaR OS Engineering Audit

Audit date: 2026-10-03

## Current state

The repository is now a valid project layer rather than a placeholder repository. It contains a repo manifest, product registration, source verification, build helpers, extraction tooling, documentation, and CI validation.

## Findings and remediation

### A1 — Product registration location

**Finding:** AndroidProducts.mk was nested under vendor/wear/products.

**Risk:** Current Android build-system conventions place AndroidProducts.mk at the project root, while the product makefile can live in a subdirectory.

**Remediation:** AndroidProducts.mk and Android.bp are now at the WeaR project root. The product makefile remains at vendor/wear/products/wear_duchamp.mk.

### A2 — Upstream product contamination

**Finding:** The first product definition inherited device/xiaomi/duchamp/lineage_duchamp.mk, which also carries upstream project-specific identity settings.

**Risk:** Unrelated maintainer/branding/fingerprint configuration can leak into a custom ROM.

**Remediation:** WeaR now inherits the AOSP product foundations, duchamp device.mk, and Lineage common configuration directly. WeaR owns its product identity.

### A3 — Filesystem-mode dependency

**Finding:** The duchamp device.mk uses WITH_GMS as a selector for its EROFS + Virtual A/B configuration path.

**Remediation:** WeaR explicitly sets WITH_GMS=true and documents that this flag is being used as a device configuration selector, not as a Google-app inclusion switch.

### A4 — Source compatibility boundary

**Finding:** The supplied Snapboss device tree is an older LineageOS 23.1 snapshot, while the public duchamp kernel/vendor projects also expose newer 23.2-era revisions.

**Risk:** Build-time ABI/API or runtime VINTF/module mismatches are possible.

**Remediation:** Dependency revisions are locked to exact commits and the condition is documented. The project does not claim hardware compatibility until compilation and device validation pass.

**Next engineering action:** Build the exact locked stack. If incompatibilities occur, resolve the dependency set as a coordinated change rather than updating one repository independently.

### A5 — Reproducibility

**Finding:** The development manifest references the WeaR repository's main branch.

**Risk:** A future sync can change the WeaR layer without changing the Android source revision.

**Remediation:** Development keeps main for rapid iteration. Release procedures must pin the WeaR repository to the exact release commit before publishing a build.

### A6 — Validation coverage

**Finding:** The original repository had no automated syntax or structure checks.

**Remediation:** scripts/validate.sh and GitHub Actions now validate shell syntax, manifest XML, product registration, and required manifest references on every push and pull request.

### A7 — Proprietary source handling

**Finding:** Device functionality depends on proprietary Xiaomi/MediaTek components.

**Remediation:** The WeaR repository does not redistribute proprietary blobs. Extraction remains an external build step using an authorized source.

## Release gate

A WeaR OS release is not considered ready until all of the following are true:

- source validation passes
- exact dependency revisions are recorded
- proprietary extraction succeeds
- baseline build succeeds
- WeaR build succeeds
- first boot succeeds
- hardware validation passes
- OTA packaging and signing are tested
- a clean rollback path exists

## Explicit non-goals for Alpha 0.1

- kernel overclocking
- undocumented scheduler hacks
- aggressive thermal disabling
- fake benchmark optimizations
- Play Integrity bypass logic

Those can be evaluated later only with evidence, hardware validation, and a clearly documented trade-off.
