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
    device/amlogic/common/products/mbox/init.amlogic.rc:root/init.amlogic.rc \
    device/amlogic/gxtvbb_skt/init.amlogic.board.rc:root/init.amlogic.board.rc \
    device/amlogic/gxtvbb_skt/init.amlogic.usb.rc:root/init.amlogic.usb.rc \
    device/amlogic/common/products/mbox/ueventd.amlogic.rc:root/ueventd.amlogic.rc

PRODUCT_COPY_FILES += \
    device/amlogic/gxtvbb_skt/files/media_profiles.xml:system/etc/media_profiles.xml \
    device/amlogic/gxtvbb_skt/files/audio_policy.conf:system/etc/audio_policy.conf \
    device/amlogic/gxtvbb_skt/files/media_codecs.xml:system/etc/media_codecs.xml \
    device/amlogic/gxtvbb_skt/files/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/amlogic/gxtvbb_skt/files/mesondisplay.cfg:system/etc/mesondisplay.cfg

# remote IME config file
PRODUCT_COPY_FILES += \
    device/amlogic/gxtvbb_skt/files/remote.conf:system/etc/remote.conf \
    device/amlogic/gxtvbb_skt/files/Vendor_0001_Product_0001.kl:/system/usr/keylayout/Vendor_0001_Product_0001.kl

PRODUCT_AAPT_CONFIG := xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_CHARACTERISTICS := mbx,nosdcard

DEVICE_PACKAGE_OVERLAYS := \
    device/amlogic/gxtvbb_skt/overlay

PRODUCT_TAGS += dalvik.gc.type-precise


# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp
