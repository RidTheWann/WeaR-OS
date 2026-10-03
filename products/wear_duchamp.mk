# SPDX-License-Identifier: Apache-2.0
#
# WeaR OS product for Xiaomi/POCO duchamp.
#
# The first product deliberately inherits the complete Snapboss LineageOS
# product definition. Only ROM identity is overridden here. This keeps the
# hardware bring-up path identical to the supplied reference before custom
# framework/features are introduced.

$(call inherit-product, device/xiaomi/duchamp/lineage_duchamp.mk)

# Remove the reference ROM's project-specific maintainer identity.
LUMINE_MAINTAINER :=

# WeaR product identity.
PRODUCT_NAME := wear_duchamp
PRODUCT_DEVICE := duchamp
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 2311DRK48G
PRODUCT_SYSTEM_NAME := duchamp_global

# Keep the stock-compatible build description/fingerprint baseline for Alpha
# bring-up. This is not treated as an integrity/certification bypass.
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="missi-user 16 BP3A.250905.031.A3 OS2.0.206.0.VNLMIXM release-keys" \
    BuildFingerprint=POCO/duchamp_global/duchamp:14/UP1A.230905.011/OS2.0.206.0.VNLMIXM:user/release-keys \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME)

# WeaR build metadata.
WEAR_OS_NAME := WeaR OS
WEAR_OS_VERSION := 0.1.0-alpha1
WEAR_OS_BUILD_TYPE := UNOFFICIAL
WEAR_OS_DEVICE := duchamp

PRODUCT_SYSTEM_PROPERTIES += \
    ro.wearos.name=WeaR_OS \
    ro.wearos.version=$(WEAR_OS_VERSION) \
    ro.wearos.build_type=$(WEAR_OS_BUILD_TYPE)
