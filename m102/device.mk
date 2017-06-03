#
# Copyright (C) 2013 The Android Open-Source Project
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

PRODUCT_COPY_FILES += \
    device/amlogic/common/products/tablet/init.amlogic.rc:root/init.amlogic.rc \
    device/amlogic/m102/init.amlogic.board.rc:root/init.amlogic.board.rc \
    device/amlogic/m102/init.amlogic.usb.rc:root/init.amlogic.usb.rc \
    device/amlogic/common/products/tablet/ueventd.amlogic.rc:root/ueventd.amlogic.rc

PRODUCT_COPY_FILES += \
    device/amlogic/m102/files/media_profiles.xml:system/etc/media_profiles.xml \
    device/amlogic/m102/files/audio_policy.conf:system/etc/audio_policy.conf \
    device/amlogic/m102/files/media_codecs.xml:system/etc/media_codecs.xml \
    device/amlogic/m102/files/mixer_paths.xml:system/etc/mixer_paths.xml \


PRODUCT_COPY_FILES += \
    device/amlogic/m102/touch/gsl3670_m102.cfg:system/etc/touch/gsl3670_m102.cfg \
    device/amlogic/m102/touch/gsl3670_m102.fw:system/etc/touch/gsl3670_m102.fw \
    device/amlogic/m102/files/Vendor_0001_Product_0001.kl:/system/usr/keylayout/Vendor_0001_Product_0001.kl

ifeq ($(BUILD_WITH_LOWMEM_COMMON_CONFIG),false)
PRODUCT_COPY_FILES += \
    device/amlogic/m102/files/lowmemorykiller.txt:/system/etc/lowmemorykiller.txt
endif

#light HAL
PRODUCT_PACKAGES += \
    lights.amlogic

#permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml

PRODUCT_AAPT_CONFIG := xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_CHARACTERISTICS := tablet,nosdcard

DEVICE_PACKAGE_OVERLAYS := \
    device/amlogic/m102/overlay

PRODUCT_TAGS += dalvik.gc.type-precise


# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

