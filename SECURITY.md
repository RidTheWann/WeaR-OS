# Security

## Reporting

Do not publish signing keys, proprietary blobs, private access tokens, or
device-identifying dumps in issues or pull requests.

Security-sensitive issues should be reported privately to the repository owner
until a fix is available.

## Build runner

The full ROM build workflow is manual-only and executes on a dedicated
self-hosted runner labelled wearos-build.

Pull-request code is never scheduled on that runner. Release artifacts must be
built from an immutable WeaR OS commit rather than a moving branch.
