# SPDX-License-Identifier: Apache-2.0
#
# WeaR OS product for Xiaomi/POCO duchamp.
#
# Start from the validated LineageOS duchamp product and override only the
# project identity. Hardware configuration remains in the device tree.

$(call inherit-product, device/xiaomi/duchamp/lineage_duchamp.mk)


PRODUCT_NAME := wear_duchamp
PRODUCT_DEVICE := duchamp
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 2311DRK48G
PRODUCT_SYSTEM_NAME := duchamp_global

WEAR_OS_VERSION := 0.1.0-alpha1
WEAR_OS_BUILD_TYPE := UNOFFICIAL

PRODUCT_SYSTEM_PROPERTIES += \
    ro.wearos.name=WeaR_OS \
    ro.wearos.version=$(WEAR_OS_VERSION) \
    ro.wearos.build_type=$(WEAR_OS_BUILD_TYPE)
