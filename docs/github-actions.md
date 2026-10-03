# WeaR OS GitHub Actions

## CI model

WeaR OS uses two different execution classes:

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

The workflow routes only to runners carrying all four labels.

## Host requirements

Recommended development target:

- Linux x86_64
- 64 GiB RAM preferred for modern LineageOS source builds
- 400 GiB or more free SSD space preferred
- persistent ccache storage
- git, repo, Python 3, zip/unzip, rsync, curl, ccache and Android build dependencies

Run `bash scripts/host-check.sh` before the first build.

## First build

Open GitHub Actions and run **WeaR OS ROM Build** manually.

Recommended first target:

    build_product = lineage_duchamp-userdebug
    wear_ref = <the exact WeaR OS commit to test>
    jobs = 1 or 2 on a 16 GiB machine
    clean_build = false
    publish_release = false

Reproduce the upstream hardware baseline before relying on the custom WeaR product.

## WeaR build

After the baseline is known-good:

    build_product = wear_duchamp-userdebug

Use an immutable WeaR commit for reproducible builds instead of `main`.

## Persistent source directory

The workflow keeps the Android source under:

    $RUNNER_WORKSPACE/android-source

on the self-hosted runner. This allows repo history and ccache to persist across jobs. Do not share this runner with unrelated untrusted workloads.

## Artifacts and releases

Small metadata is uploaded as an Actions artifact. The flashable ROM itself is published as a GitHub Release asset only when `publish_release` is explicitly enabled.

GitHub's current public-plan Actions artifact storage is small compared with an Android ROM build, while GitHub Releases permit individual release assets below 2 GiB and have no total release-size or bandwidth limit. Therefore the ROM distribution path is Releases, not the Actions artifact store.

## Security

Do not put Xiaomi/MediaTek proprietary blobs or signing private keys into the repository or Actions artifacts.
Do not use `pull_request_target` or `workflow_run` to execute forked code on the ROM runner.
Keep release signing as a separate protected step once WeaR reaches release status.
