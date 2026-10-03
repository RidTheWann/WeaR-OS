# SPDX-License-Identifier: Apache-2.0
#
# WeaR OS product definition for Xiaomi/POCO duchamp.
#
# Keep the first product delta intentionally small: the validated LineageOS
# device product remains the hardware baseline, while WeaR owns product identity.

$(call inherit-product, device/xiaomi/duchamp/lineage_duchamp.mk)

PRODUCT_NAME := wear_duchamp
PRODUCT_DEVICE := duchamp
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 2311DRK48G
PRODUCT_SYSTEM_NAME := duchamp_global

# The device configuration uses this flag to select the stock-compatible
# dynamic-partition filesystem configuration. It does not add Google apps.
WITH_GMS := true

PRODUCT_SOONG_NAMESPACES += \
    vendor/wear

# WeaR build identity. These values are consumed by later WeaR framework work.
WEAR_OS_VERSION := 0.1.0-alpha
WEAR_OS_BUILD_TYPE := UNOFFICIAL
WEAR_OS_DEVICE := duchamp

PRODUCT_SYSTEM_PROPERTIES += \
    ro.wearos.name=WeaR_OS \
    ro.wearos.version=$(WEAR_OS_VERSION) \
    ro.wearos.build_type=$(WEAR_OS_BUILD_TYPE)
