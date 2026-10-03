# SPDX-License-Identifier: Apache-2.0
#
# WeaR OS product for Xiaomi/POCO duchamp.
#
# This product definition lives in the device tree itself, following the
# conventional LineageOS device-repository layout.

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

WITH_GMS := true

$(call inherit-product, device/xiaomi/duchamp/device.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

TARGET_ENABLE_BLUR := true

PRODUCT_NAME := wear_duchamp
PRODUCT_DEVICE := duchamp
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 2311DRK48G
PRODUCT_SYSTEM_NAME := duchamp_global
PRODUCT_CHARACTERISTICS := nosdcard
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="missi-user 16 BP3A.250905.031.A3 OS2.0.206.0.VNLMIXM release-keys" \
    BuildFingerprint=POCO/duchamp_global/duchamp:14/UP1A.230905.011/OS2.0.206.0.VNLMIXM:user/release-keys \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME)

WEAR_OS_NAME := WeaR OS
WEAR_OS_VERSION := 0.1.0-alpha1
WEAR_OS_BUILD_TYPE := UNOFFICIAL
WEAR_OS_DEVICE := duchamp

PRODUCT_SYSTEM_PROPERTIES += \
    ro.wearos.name=WeaR_OS \
    ro.wearos.version=$(WEAR_OS_VERSION) \
    ro.wearos.build_type=$(WEAR_OS_BUILD_TYPE)
