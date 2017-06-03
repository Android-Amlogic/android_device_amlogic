$(call inherit-product, device/amlogic/common/core_amlogic.mk)

PRODUCT_PACKAGES += \
    imageserver \
    busybox \
    utility_busybox

# DLNA
PRODUCT_PACKAGES += \
    DLNA

PRODUCT_PACKAGES += \
    remotecfg

USE_CUSTOM_AUDIO_POLICY := 1

# NativeImagePlayer
PRODUCT_PACKAGES += \
    NativeImagePlayer

#RemoteControl Service
PRODUCT_PACKAGES += \
    RC_Service

# Camera Hal
PRODUCT_PACKAGES += \
    camera.amlogic

# HDMITX CEC HAL
PRODUCT_PACKAGES += \
    hdmi_cec.amlogic

PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=4

#Tvsettings
PRODUCT_PACKAGES += \
    TvSettings

#MboxLauncher
PRODUCT_PACKAGES += \
    MboxLauncher

#USB PM
PRODUCT_PACKAGES += \
    usbtestpm \
    usbpower

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:system/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:system/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml

# copy lowmem_manage.sh
PRODUCT_COPY_FILES += \
	device/amlogic/common/lowmem_manage.sh:system/bin/lowmem_manage.sh

#copy lowmemorykiller.txt
ifeq ($(BUILD_WITH_LOWMEM_COMMON_CONFIG),true)
PRODUCT_COPY_FILES += \
	device/amlogic/common/config/lowmemorykiller_2G.txt:system/etc/lowmemorykiller_2G.txt \
	device/amlogic/common/config/lowmemorykiller.txt:system/etc/lowmemorykiller.txt \
	device/amlogic/common/config/lowmemorykiller_512M.txt:system/etc/lowmemorykiller_512M.txt
endif

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

custom_keylayouts := $(wildcard device/amlogic/common/keyboards/*.kl)
PRODUCT_COPY_FILES += $(foreach file,$(custom_keylayouts),\
    $(file):system/usr/keylayout/$(notdir $(file)))

# bootanimation
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip

# bootvideo
BUILD_WITH_BOOT_PLAYER:= true
PRODUCT_PACKAGES += \
    libasound \
    libamstreaming \
    bootplayer \
    alsalib-alsaconf \
    alsalib-pcmdefaultconf \
    alsalib-cardsaliasesconf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/mbox.mp4:system/etc/bootvideo

# default wallpaper for mbox to fix bug 106225
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/default_wallpaper.png:system/etc/default_wallpaper.png

ADDITIONAL_BUILD_PROPERTIES += \
    ro.config.wallpaper=/system/etc/default_wallpaper.png

# Include BUILD_NUMBER if defined
VERSION_ID=$(shell find device/*/$(TARGET_PRODUCT) -name version_id.mk)
$(call inherit-product, $(VERSION_ID))

DISPLAY_BUILD_NUMBER := true
