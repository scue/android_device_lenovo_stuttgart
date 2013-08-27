# Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := stuttgart

# Boot animation
TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/lenovo/stuttgart/full_stuttgart.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := stuttgart
PRODUCT_NAME := cm_stuttgart
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := Stuttgart
PRODUCT_MANUFACTURER := Lenovo

#CM_RELEASE := true
#CM_BUILDTYPE := NIGHTLY
CM_EXTRAVERSION := scue
PRODUCT_VERSION_DEVICE_SPECIFIC := scue

# Set build fingerprint / ID / Product Name ect.
#PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=$(PRODUCT_MODEL) TARGET_DEVICE=$(PRODUCT_DEVICE) BUILD_FINGERPRINT="LENOVO/full_stuttgart/stuttgart:4.2.2/JDQ39E/eng.scue.20130701.143818:user/release-keys" PRIVATE_BUILD_DESC="stuttgart-user 4.1.1 JRO03L K860i_1_S_2_002_0005_121019 release-keys"
