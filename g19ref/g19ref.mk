# Copyright (C) 2011 Amlogic Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file is the build configuration for a full Android
# build for MX reference board. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps).
#

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
        persist.sys.usb.config=mtp,adb
# Inherit from those products. Most specific first.
$(call inherit-product, device/amlogic/common/mbx_dongle_amlogic.mk)
#$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Replace definitions used by tablet in mid_amlogic.mk above
# Overrides
PRODUCT_BRAND := MBX
PRODUCT_DEVICE := Android Reference Device
PRODUCT_NAME := Android Reference Design
PRODUCT_CHARACTERISTICS := mbx

include frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk

# Discard inherited values and use our own instead.
PRODUCT_NAME := g19ref
PRODUCT_MANUFACTURER := MBX
PRODUCT_DEVICE := g19ref
PRODUCT_MODEL := MBX reference board (g19ref)
# PRODUCT_CHARACTERISTICS := tablet,nosdcard

#########################################################################
#
#                                                Audio
#
#########################################################################

#possible options: 1 tiny 2 legacy
BOARD_ALSA_AUDIO := tiny
BOARD_AUDIO_CODEC := dummy
BOARD_USE_USB_AUDIO := true

ifneq ($(strip $(wildcard $(LOCAL_PATH)/mixer_paths.xml)),)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/mixer_paths.xml:system/etc/mixer_paths.xml
endif

include device/amlogic/common/audio.mk

ifeq ($(BOARD_ALSA_AUDIO),legacy)
PRODUCT_PROPERTY_OVERRIDES += \
    alsa.mixer.capture.master=Digital \
    alsa.mixer.capture.headset=Digital \
    alsa.mixer.capture.earpiece=Digital
endif

#########################################################################
#
#                                                USB
#
#########################################################################

BOARD_USES_USB_PM := true
	
#########################################################################
#
#                                                WiFi
#
#########################################################################

WIFI_MODULE := bcm40183
WIFI_AP6xxx_MODULE := AP6330
include device/amlogic/common/wifi.mk

# Change this to match target country
# 11 North America; 14 Japan; 13 rest of world
PRODUCT_DEFAULT_WIFI_CHANNELS := 14

#########################################################################
#
#                                                Bluetooth
#
#########################################################################
BOARD_HAVE_BLUETOOTH := true
BLUETOOTH_MODULE := AP6330
BLUETOOTH_USE_BPLUS := true
BCM_BLUETOOTH_LPM_ENABLE := true

include device/amlogic/common/bluetooth.mk

#########################################################################
#
#                                                Init.rc
#
#########################################################################

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.amlogic.rc:root/init.amlogic.rc \
	$(LOCAL_PATH)/init.amlogic.usb.rc:root/init.amlogic.usb.rc \
	$(LOCAL_PATH)/init.amlogic.board.rc:root/init.amlogic.board.rc \
	device/amlogic/common/init/mbx/ueventd.amlogic.rc:root/ueventd.amlogic.rc


#########################################################################
#
#                                                languages
#
#########################################################################

# For all locales, $(call inherit-product, build/target/product/languages_full.mk)
PRODUCT_LOCALES := zh_CN en_US


#########################################################################
#
#                                                Software features
#
#########################################################################

BUILD_WITH_AMLOGIC_PLAYER := true
BUILD_WITH_APP_OPTIMIZATION := true
BUILD_WITH_WIDEVINE_DRM := true
BUILD_WITH_FLASH_PLAYER := false
BUILD_WITH_EREADER := false
BUILD_WITH_MIRACAST := true
# facelock enable, board should has front camera
BUILD_WITH_FACE_UNLOCK := false

include device/amlogic/common/software.mk

#########################################################################
#
#                                                Misc
#
#########################################################################


# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=131072


PRODUCT_PACKAGES += \
	FileBrowser \
	AppInstaller \
	VideoPlayer \
	RemoteIME \
	remotecfg \
	PicturePlayer \
	MusicPlayer \
	AmlSettings \
	DLNA \
	OTAUpgrade

# Device specific system feature description
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml




PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/alarm_blacklist.txt:/system/etc/alarm_blacklist.txt \
	$(LOCAL_PATH)/initlogo-robot-1280x720.rle:root/initlogo.720p.rle \
	$(LOCAL_PATH)/remote.conf:system/etc/remote.conf
	
#	$(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip \


PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/u-boot.bin:u-boot.bin

# App optimization
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/liboptimization.so:system/lib/liboptimization.so \
	$(LOCAL_PATH)/config:system/etc/config

# inherit from the non-open-source side, if present
$(call inherit-product-if-exists, vendor/amlogic/g19ref/device-vendor.mk)
