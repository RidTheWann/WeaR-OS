# WeaR OS GitHub Actions

## CI model

WeaR OS uses two execution classes:

1. GitHub-hosted CI for repository validation.
2. A dedicated self-hosted runner for full Android compilation.

The ROM build workflow is manual-only. It intentionally does not run on pull requests or ordinary pushes.

GitHub warns that self-hosted runners are persistent machines and should almost never be used for public repositories because untrusted pull requests can execute code on the runner. Keep the ROM build workflow manual and restrict repository write access appropriately.

## Runner labels

Register the build machine with these labels:

    self-hosted
    linux
    x64
    wearos-build

GitHub routes the job only to a runner matching all requested labels.

## Runner setup

1. Open the repository Settings -> Actions -> Runners.
2. Choose New self-hosted runner and select Linux x64.
3. Follow the exact registration commands GitHub displays for the runner.
4. During runner configuration, add the custom label `wearos-build`.
5. Install the runner as a service on a dedicated build machine if it is intended to run unattended.

Do not place personal files, SSH keys, browser profiles, or unrelated secrets on this runner.

## Host requirements

Recommended development target:

- Linux x86_64
- 64 GiB RAM preferred for modern LineageOS source builds
- 400 GiB or more free SSD space preferred
- persistent ccache storage
- git, repo, Git LFS, Python 3, zip/unzip, rsync, curl, ccache and Android build dependencies

Run `bash scripts/host-check.sh` before the first build.

## Build workflow

Run **WeaR OS ROM Build** manually from the Actions tab.

Inputs:

- `build_product`: `lineage_duchamp-userdebug` for the hardware baseline or `wear_duchamp-userdebug` for WeaR OS.
- `lineage_ref`: branch such as `lineage-23.1` during development, or an immutable Lineage manifest SHA for reproducible builds.
- `wear_ref`: `main` during development, or an immutable WeaR commit SHA for reproducible builds.
- `jobs`: build parallelism. Use 1-2 on a 16 GiB host.
- `clean_build`: clear the persistent `out/` tree.
- `publish_release`: publish the flashable OTA ZIP as a GitHub Release asset.
- `release_tag`: required only for a release publication.

## Six-hour execution boundary

GitHub Actions job execution has a maximum of 360 minutes. The ROM workflow uses a 350-minute timeout to leave a small margin for final packaging.

A large Android build may exceed one job on a low-memory or low-core machine. The Android source and `out/` directory live on the persistent self-hosted workspace, so a later manual run with `clean_build=false` can continue incrementally from the existing build state.

Do not expect the GitHub Actions token to remain valid beyond 24 hours; the workflow therefore does not try to run a multi-day job.

## Ccache

The workflow uses a persistent ccache directory under the runner user's home directory and caps it at 40 GiB. This is intentionally stored on the runner rather than GitHub Actions cache because Android source/build state is much larger than the default hosted cache allowance.

## Distribution

Actions artifacts contain only small build metadata. The ROM ZIP is distributed through GitHub Releases when explicitly requested.

GitHub currently permits individual release assets below 2 GiB and has no total release-size or bandwidth limit. The workflow checks the ROM size before uploading.

## Security

Do not put Xiaomi/MediaTek proprietary blobs or signing private keys into the repository or Actions artifacts.
Do not use `pull_request_target` or `workflow_run` to execute forked code on the ROM runner.
Keep release signing as a separate protected step once WeaR reaches release status.

## Release reproducibility

For a release, record all of these in the release metadata:

    Lineage manifest SHA
    WeaR commit SHA
    device tree SHA
    kernel SHA
    vendor SHA
    generated ZIP SHA256

The workflow already preserves the rendered local source manifest and a SHA256SUMS file.
