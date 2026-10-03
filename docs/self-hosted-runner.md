# WeaR OS Self-Hosted Runner Setup

## Purpose

This runner is dedicated to full Android/WeaR OS compilation. It should not be used for ordinary repository CI, pull requests, or unrelated untrusted workloads.

GitHub's security guidance strongly cautions against using self-hosted runners with public repositories because untrusted workflow code can persistently compromise the runner.

## Register the runner

On the repository page:

    Settings -> Actions -> Runners -> New self-hosted runner

Choose Linux and x64, then copy the registration commands GitHub provides. During configuration, add the custom label:

    wearos-build

GitHub automatically supplies the `self-hosted`, operating-system, and architecture labels unless default labels are disabled. The WeaR workflow requires all of:

    self-hosted
    linux
    x64
    wearos-build

## Runner software

Install the Android/LineageOS build dependencies appropriate for the selected branch before starting the runner.

The WeaR workflow explicitly checks for:

    git
    repo
    git-lfs
    python3
    curl
    zip
    unzip
    rsync
    ccache
    sha256sum

The Android source build itself may require additional packages such as compilers, development libraries, OpenJDK, image tools, and Android build utilities.

## Persistent storage

Keep the runner workspace on an SSD with enough room for:

- the LineageOS source tree
- `.repo` metadata
- `out/` build output
- downloaded proprietary/vendor content
- ccache
- temporary packaging files

The workflow uses:

    $RUNNER_WORKSPACE/android-source

for the Android source tree and:

    $HOME/.cache/ccache-wear

for persistent ccache.

## Service mode

For an unattended build server, install the GitHub Actions runner as a service using the `svc.sh` commands supplied with the runner package.

Do not run the runner as root unless there is a specific administrative requirement. A dedicated unprivileged build account is preferable.

## Security checklist

- Use a dedicated machine or VM.
- Do not store personal credentials on the runner.
- Do not expose SSH private keys to workflow steps.
- Do not run ROM builds from `pull_request_target` or `workflow_run`.
- Keep the ROM workflow manual-only.
- Review changes to `.github/workflows/` before executing a build.
- Rotate runner registration credentials by removing/re-registering the runner when the machine is retired.

## First test

After the runner is online:

1. Run `WeaR OS ROM Build` manually.
2. Select `lineage_duchamp-userdebug`.
3. Use the exact Lineage and WeaR revisions you intend to test.
4. Set `jobs` to 1 or 2 on a 16 GiB machine.
5. Keep `clean_build=false` on subsequent attempts so an interrupted build can resume from persistent output.

## Six-hour job limit

GitHub Actions currently caps a job at 360 minutes. The WeaR workflow uses a 350-minute timeout.

If compilation is interrupted by the limit, do not delete `out/`. Re-run the workflow with the same source revisions and `clean_build=false` so the Android build can continue incrementally.
