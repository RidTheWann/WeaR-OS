# Contributing to WeaR OS

## Development rule

Keep hardware bring-up separate from WeaR feature development.

Before submitting a change:

1. Run scripts/validate.sh.
2. Confirm the affected source revision and dependency assumptions.
3. Describe the test performed.
4. Keep commits focused on one logical change.

## Commit convention

Use prefixes such as:

- build:
- device:
- framework:
- systemui:
- settings:
- performance:
- kernel:
- docs:
- ci:

## Regression policy

A performance change is not accepted solely because a benchmark number changed. It must also be checked for stability, thermal behavior, battery impact, and affected hardware functions.

## Proprietary code

Do not commit extracted Xiaomi/MediaTek proprietary blobs unless the relevant license explicitly permits redistribution.
