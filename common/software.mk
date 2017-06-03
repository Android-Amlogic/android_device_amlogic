ifeq ($(BOARD_SUPPORT_INSTABOOT), true)

PRODUCT_PROPERTY_OVERRIDES += \
    config.disable_instaboot=false

instaboot_config_file := $(wildcard $(LOCAL_PATH)/instaboot_config.xml)

PRODUCT_COPY_FILES += \
    $(instaboot_config_file):system/etc/instaboot_config.xml

instaboot_rc := $(wildcard $(LOCAL_PATH)/instaboot.rc)
ifeq ($(instaboot_rc),)
instaboot_rc := device/amlogic/common/instaboot.rc
endif

PRODUCT_COPY_FILES += \
    $(instaboot_rc):root/instaboot.rc

user_variant := $(filter user userdebug,$(TARGET_BUILD_VARIANT))
ifneq (,$(user_variant))
WITH_DEXPREOPT := true
WITH_DEXPREOPT_PIC := true
endif

PRODUCT_PACKAGES += instabootserver
endif


ifeq ($(TARGET_BUILD_CTS), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.app.rotation=original

WITH_DEXPREOPT := true
WITH_DEXPREOPT_PIC := true

PRODUCT_PACKAGES += \
    Contacts \
    DownloadProviderUi \
    Calendar \
    QuickSearchBox

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml
endif
