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
    device/amlogic/common/products/tv/init.amlogic.rc:root/init.amlogic.rc \
    device/amlogic/p300/init.amlogic.board.rc:root/init.amlogic.board.rc \
    device/amlogic/p300/init.amlogic.usb.rc:root/init.amlogic.usb.rc \
    device/amlogic/common/products/tv/ueventd.amlogic.rc:root/ueventd.amlogic.rc

PRODUCT_COPY_FILES += \
    device/amlogic/p300/files/media_profiles.xml:system/etc/media_profiles.xml \
    device/amlogic/p300/files/audio_policy.conf:system/etc/audio_policy.conf \
    device/amlogic/p300/files/media_codecs.xml:system/etc/media_codecs.xml \
    device/amlogic/p300/files/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/amlogic/p300/files/mesondisplay.cfg:system/etc/mesondisplay.cfg

# remote IME config file
PRODUCT_COPY_FILES += \
    device/amlogic/p300/files/remote.conf:system/etc/remote.conf \
    device/amlogic/p300/files/Vendor_0001_Product_0001.kl:/system/usr/keylayout/Vendor_0001_Product_0001.kl

# TV config file
PRODUCT_COPY_FILES += \
    device/amlogic/p300/files/tv/tvconfig.conf:system/etc/tvconfig.conf \
	device/amlogic/p300/files/tv/tv_default.cfg:system/etc/tv_default.cfg \
	device/amlogic/p300/files/tv/tv_default.xml:system/etc/tv_default.xml \
	device/amlogic/p300/files/tv/tv_setting_config.cfg:system/etc/tv_setting_config.cfg \
	device/amlogic/p300/files/tv/pq.db:system/etc/pq.db \
	device/amlogic/p300/files/tv/tvcp.sh:system/bin/tvcp.sh

#TV tuner
PRODUCT_COPY_FILES += \
    device/amlogic/p300/files/tv/mxl661_fe.ko:system/lib/mxl661_fe.ko

PRODUCT_AAPT_CONFIG := xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_CHARACTERISTICS := mbx,nosdcard

DEVICE_PACKAGE_OVERLAYS := \
    device/amlogic/p300/overlay

PRODUCT_TAGS += dalvik.gc.type-precise


# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp
