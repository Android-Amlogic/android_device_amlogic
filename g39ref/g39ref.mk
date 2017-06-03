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

# Inherit from those products. Most specific first.
$(call inherit-product, device/amlogic/common/mid_amlogic.mk)
#$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

include frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk

# Discard inherited values and use our own instead.
PRODUCT_NAME := g39ref
PRODUCT_MANUFACTURER := MID
PRODUCT_DEVICE := g39ref
PRODUCT_MODEL := AML-MX REF
PRODUCT_CHARACTERISTICS := tablet

#########################################################################
#
#                                                Audio
#
#########################################################################

#possible options: 1 tiny 2 legacy
BOARD_ALSA_AUDIO := tiny
BOARD_AUDIO_CODEC := rt5631

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

WIFI_MODULE := bcm40181
WIFI_AP6xxx_MODULE := AP6476
include device/amlogic/common/wifi.mk

# Change this to match target country
# 11 North America; 14 Japan; 13 rest of world
PRODUCT_DEFAULT_WIFI_CHANNELS := 11


#########################################################################
#
#                                                Bluetooth
#
#########################################################################
BOARD_HAVE_BLUETOOTH := true
BLUETOOTH_MODULE := AP6476
BLUETOOTH_USE_BPLUS := true

include device/amlogic/common/bluetooth.mk

#########################################################################
#
#                                                GPS
#
#########################################################################

GPS_MODULE :=AP6476
include device/amlogic/common/gps.mk

#########################################################################
#
#                                                Camera
#
#########################################################################
BOARD_HAVE_FRONT_CAM :=true
BOARD_HAVE_BACK_CAM :=true

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml
#	frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml
	
PRODUCT_PROPERTY_OVERRIDES += \
	hw.cameras=2

# Camera Orientation
PRODUCT_PROPERTY_OVERRIDES += \
	ro.camera.orientation.front=0 \
	ro.camera.orientation.back=0

#########################################################################
#
#                                                Sensor
#
#########################################################################

#define gsensor install position, this value is 4-bit number, bit0:xy swap;bit1:Z direction;bit2:y direction;bit3:z direction	
PRODUCT_PROPERTY_OVERRIDES += \
	rw.sensors.gsensor.installdir=1100

# uncomment features file copy if board have some sensor
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml
#	frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
#	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
#	frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
#	frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \


#########################################################################
#
#                                                Init.rc
#
#########################################################################

PRODUCT_COPY_FILES += \
	device/amlogic/common/init/tablet/init.amlogic.rc:root/init.amlogic.rc \
	$(LOCAL_PATH)/init.amlogic.usb.rc:root/init.amlogic.usb.rc \
	$(LOCAL_PATH)/init.amlogic.board.rc:root/init.amlogic.board.rc \
	device/amlogic/common/init/tablet/ueventd.amlogic.rc:root/ueventd.amlogic.rc


#########################################################################
#
#                                                languages
#
#########################################################################

# For all locales, $(call inherit-product, build/target/product/languages_full.mk)
PRODUCT_LOCALES := en_US fr_FR it_IT es_ES de_DE nl_NL cs_CZ pl_PL ja_JP zh_TW zh_CN ru_RU \
   ko_KR nb_NO es_US da_DK el_GR tr_TR pt_PT pt_BR rm_CH sv_SE bg_BG ca_ES en_GB fi_FI hi_IN \
   hr_HR hu_HU in_ID iw_IL lt_LT lv_LV ro_RO sk_SK sl_SI sr_RS uk_UA vi_VN tl_PH ar_EG fa_IR \
   th_TH sw_TZ ms_MY af_ZA zu_ZA am_ET hi_IN


#########################################################################
#
#                                                Software features
#
#########################################################################

BUILD_WITH_AMLOGIC_PLAYER := true
BUILD_WITH_APP_OPTIMIZATION := true
BUILD_WITH_WIDEVINE_DRM := true
BUILD_WITH_FLASH_PLAYER := true
BUILD_WITH_EREADER := true 
# facelock enable, board should has front camera
BUILD_WITH_FACE_UNLOCK := true

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
	lights.amlogic \
	FileBrowser \
	AppInstaller \
	VideoPlayer \
	HdmiSwitch \
	fw_env

# Device specific system feature description
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml


# This only for m3
# Battery icons shown from uboot
#PRODUCT_COPY_FILES += \
#	device/amlogic/common/res/battery/0.rot270.bmp:system/resource/battery_pic/0.bmp \
#	device/amlogic/common/res/battery/1.rot270.bmp:system/resource/battery_pic/1.bmp \
#	device/amlogic/common/res/battery/2.rot270.bmp:system/resource/battery_pic/2.bmp \
#	device/amlogic/common/res/battery/3.rot270.bmp:system/resource/battery_pic/3.bmp \
#	device/amlogic/common/res/battery/4.rot270.bmp:system/resource/battery_pic/4.bmp \
#	device/amlogic/common/res/battery/power_low.rot270.bmp:system/resource/battery_pic/power_low.bmp


PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/alarm_blacklist.txt:/system/etc/alarm_blacklist.txt
#	$(LOCAL_PATH)/bootanimation.zip:system/media/bootanimation.zip \


PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/u-boot.bin:u-boot.bin


# inherit from the non-open-source side, if present
$(call inherit-product-if-exists, vendor/amlogic/g39ref/device-vendor.mk)
