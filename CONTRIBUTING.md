# Contributing to WeaR OS

## Repository model

This repository is the actual device/xiaomi/duchamp device tree. Keep device
hardware integration here and add ROM/framework features only at the Android
component that owns them.

## Rules

- Preserve the pinned Snapboss duchamp hardware baseline unless a subsystem
  change is explicitly reviewed.
- Use the Saikrishna duchamp tree as an engineering reference when comparing
  LineageOS-style implementations; do not mix unrelated ROM branches blindly.
- Do not add proprietary blobs, firmware payloads, signing keys or generated
  images to this repository.
- Keep commits focused on one subsystem.
- Validate XML/Python sources before submitting changes.
- Record the exact build/test performed for functional changes.
- Do not tune kernel, thermal or performance behavior before the baseline
  device path is boot-verified.

## Validation

The repository validation workflow runs on every push and pull request.

For local validation:

    python3 -m py_compile extract-files.py setup-makefiles.py

    python3 - <<'PY'
    from pathlib import Path
    import xml.etree.ElementTree as ET
    for path in Path(".").rglob("*.xml"):
        ET.parse(path)
    print("XML validation passed.")
    PY

## Commit prefixes

Use prefixes such as:

    device:
    product:
    framework:
    systemui:
    settings:
    performance:
    kernel:
    build:
    ci:
    docs:
