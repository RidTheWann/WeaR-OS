# WeaR OS GitHub Actions

## Workflows

`validate.yml` runs on pushes and pull requests and only performs repository checks.

`rom-build.yml` is manual-only and targets a dedicated self-hosted runner labeled:

    wearos-build

The full label set is:

    self-hosted
    linux
    x64
    wearos-build

## Why a dedicated runner

A full Android build needs substantially more persistent storage and memory than the standard hosted GitHub runner provides. The self-hosted runner should be dedicated to trusted ROM builds and must not execute untrusted pull-request code.

## First ROM build

Run the workflow manually with:

    build_product = lineage_duchamp-userdebug
    lineage_ref = 7d408383a8f199ba9a72e8a3b4314c6d848b459c
    wear_ref = <exact WeaR commit SHA>
    jobs = 1 or 2 on a 16 GiB host
    clean_build = false
    publish_release = false

After the reference product builds and boots, build:

    build_product = wear_duchamp-userdebug

## Incremental builds

The runner keeps its Android source and `out/` directory between jobs. A timeout therefore does not require deleting the build tree. Re-run with the same source revisions and `clean_build=false`.

GitHub Actions currently caps a single job at 360 minutes; WeaR uses a 350-minute timeout.

## Proprietary source

WeaR does not store extracted Xiaomi/MediaTek blobs or release signing keys in this repository.

## Release publication

Release publication is an explicit manual input. The workflow publishes the ROM ZIP together with `SHA256SUMS` and the complete resolved repo manifest.
