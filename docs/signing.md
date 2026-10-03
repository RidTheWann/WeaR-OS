# WeaR OS Signing

## Development

The supplied duchamp device tree uses the standard AOSP test AVB keys during development. This is acceptable for local bring-up only.

Never publish a release using test keys.

## Release requirements

A release build should use project-controlled signing keys for:

- AVB / vbmeta
- target-files signing
- OTA package signing
- release APK certificates where the project requires custom certificates

Keep private keys outside the repository. The repository .gitignore intentionally excludes common private-key file types.

## Release procedure

Before a release:

1. Build and test with the exact source lock.
2. Prepare a secure signing environment outside the Git checkout.
3. Generate signed target files and OTA artifacts using the Lineage/AOSP release tooling for the selected branch.
4. Verify AVB descriptors and signatures.
5. Verify the package can be installed on the intended firmware/bootloader configuration.
6. Publish checksums and the exact source manifest revision.

## Key rotation

Treat signing-key changes as a security-sensitive migration. Document the new key set and the installation/rollback implications before publishing it.
