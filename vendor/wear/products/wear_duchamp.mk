# SPDX-License-Identifier: Apache-2.0
#
# WeaR OS product definition for Xiaomi/POCO duchamp.
#
# Keep the hardware stack independent from the upstream Lineage product file.
# This prevents unrelated maintainer/branding/fingerprint settings from being
# inherited into WeaR OS.

# AOSP product foundations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# duchamp hardware configuration
$(call inherit-product, device/xiaomi/duchamp/device.mk)

# LineageOS common services/features
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# The duchamp device configuration uses WITH_GMS to select the stock-compatible
# EROFS + Virtual A/B path. This flag does not add Google applications by itself.
WITH_GMS := true

PRODUCT_NAME := wear_duchamp
PRODUCT_DEVICE := duchamp
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 2311DRK48G
PRODUCT_SYSTEM_NAME := duchamp_global
PRODUCT_CHARACTERISTICS := nosdcard

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# WeaR build identity.
WEAR_OS_VERSION := 0.1.0-alpha
WEAR_OS_BUILD_TYPE := UNOFFICIAL
WEAR_OS_DEVICE := duchamp

PRODUCT_SYSTEM_PROPERTIES += \
    ro.wearos.name=WeaR_OS \
    ro.wearos.version=$(WEAR_OS_VERSION) \
    ro.wearos.build_type=$(WEAR_OS_BUILD_TYPE)

# Make WeaR's future Soong modules visible without modifying the device tree.
PRODUCT_SOONG_NAMESPACES += \
    vendor/wear
