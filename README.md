# WeaR OS — Xiaomi/POCO duchamp

Custom Android ROM device tree for the POCO X6 Pro 5G / Redmi K70E
(codename: duchamp).

This repository follows the conventional LineageOS/AOSP device-tree model and
is intended to be synced by repo into:

    device/xiaomi/duchamp

## Hardware baseline

Primary reference:

    https://github.com/snapboss/device_xiaomi_duchamp.git

Pinned reference:

    lineage-23.1
    50f301982df14af45af137ba87c565a459a7e65c

The baseline provides the device board configuration, kernel interface,
partition/AVB layout, VINTF declarations, rootdir, SELinux policy, overlays,
power/thermal integration, UDFPS, native shims, XiaomiParts, and extraction
manifests.

## WeaR product

WeaR OS is registered directly as:

    wear_duchamp-userdebug

The product definition is:

    wear_duchamp.mk

There is no vendor/wear wrapper and no nested AOSP source tree in this
repository.

## Engineering reference

LineageOS-style duchamp reference:

    https://github.com/Saikrishna1504/device_xiaomi_duchamp.git

That repository is consulted for device-side implementation patterns. WeaR OS
does not blindly mix ROM-specific branches, vendor baselines or unrelated
device-tree revisions.

## Repository policy

Keep proprietary blobs, firmware payloads, signing keys, generated images and
build output outside this repository. Extraction manifests are source
descriptions, not payload storage.
