# WeaR OS Build Host

## Recommended host

Current LineageOS device build guidance for newer Android generations expects a capable x86_64 host. Published LineageOS guidance lists 64 GiB RAM and roughly 400 GiB free storage for Lineage 21 and newer.

For local development:

- 64 GiB RAM: preferred
- 32 GiB RAM: workable with conservative parallelism
- 16 GiB RAM: possible for experimentation but likely memory constrained
- 400 GiB+ free SSD space: preferred
- Linux x86_64: recommended

Run:

    bash scripts/host-check.sh

The check is informational and does not prevent building.

## Low-memory strategy

scripts/build.sh automatically chooses conservative parallelism when JOBS is not specified:

- 64 GiB+: use available CPU threads
- 32-63 GiB: cap at 8 jobs
- 16-31 GiB: 2 jobs
- below 16 GiB: 1 job

Override explicitly when necessary:

    JOBS=1 BUILD_PRODUCT=wear_duchamp-userdebug bash scripts/build.sh

Swap or zram can reduce out-of-memory failures, but cannot substitute for physical RAM indefinitely.

## Build source location

The WeaR repository may live beside the Android source tree or be repo-synced under vendor/wear. The project scripts detect both layouts.
