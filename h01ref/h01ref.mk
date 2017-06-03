# Copyright (C) 2010 Amlogic Inc
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
# build for Meson reference board. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps).
#

# Inherit from those products. Most specific first.
$(call inherit-product, device/amlogic/common/tv_amlogic.mk)

include frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk

# Discard inherited values and use our own instead.
PRODUCT_NAME := h01ref 
PRODUCT_MANUFACTURER := TV
PRODUCT_DEVICE := h01ref
PRODUCT_MODEL := TV DVBC/ATSC reference board (h01ref)

#don't copy ringtons files to system
NEED_NO_RINGTONES := true

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

WIFI_MODULE := rtl8192cu
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
BLUETOOTH_MODULE := bcm40183

include device/amlogic/common/bluetooth.mk

#########################################################################
#
#                                                GPS
#
#########################################################################

GPS_MODULE :=
include device/amlogic/common/gps.mk

#########################################################################
#
#                                                Camera
#
#########################################################################
BOARD_HAVE_FRONT_CAM :=false
BOARD_HAVE_BACK_CAM :=false

#########################################################################
#
#                                                Sensor
#
#########################################################################

#########################################################################
#
#                                                Init.rc
#
#########################################################################

PRODUCT_COPY_FILES += \
	device/amlogic/common/init/tv/init.amlogic.rc:root/init.amlogic.rc \
	$(LOCAL_PATH)/init.amlogic.usb.rc:root/init.amlogic.usb.rc \
	$(LOCAL_PATH)/init.amlogic.board.rc:root/init.amlogic.board.rc \
	device/amlogic/common/init/tv/ueventd.amlogic.rc:root/ueventd.amlogic.rc


#########################################################################
#
#                                                languages
#
#########################################################################

# For all locales, $(call inherit-product, build/target/product/languages_full.mk)
PRODUCT_LOCALES := zh_CN \
        en_US


#########################################################################
#
#                                                Software features
#
#########################################################################

BUILD_WITH_AMLOGIC_PLAYER := true
BUILD_WITH_APP_OPTIMIZATION := false
BUILD_WITH_WIDEVINE_DRM := true
BUILD_WITH_FLASH_PLAYER := true
BUILD_WITH_EREADER := false
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
	lights.amlogic \
	FileBrowser \
	AppInstaller \
	VideoPlayer \
	HdmiSwitch \
	fw_env




PRODUCT_PACKAGES += \
        amlpictureKit \
        libamlpicjni \
        libpickit \
        libamljpg \
        libamplayer \
        camera.amlogic \
        RealPlayer \
        libhpeq.so \
        libsrs.so
        
# upgrade
PRODUCT_PACKAGES += \
        Update 

# Remote	
PRODUCT_PACKAGES += remotecfg

# DTV
BOARD_HAVE_DTV := true

ifeq ($(BOARD_HAVE_DTV), true)
PRODUCT_PACKAGES += \
	libam_adp \
	libam_mw \
	libjnitvdatabase \
	libjnitvsubtitle \
	libjnitvdevice \
	libjnitvscanner \
	libjnitvepgscanner \
	libjnitvmboxdevice \
	libjnidvbplayer \
	libjnidvr \
	libjnifrontend \
	libjnidmx \
	libjnidsc \
	libjnifilter \
	libjniosd \
	libjniamsmc \
	libjnidvbdatabase \
	libjnidvbscanner \
	libjnidvbepgscanner \
	libjnidvbrecorder \
	libjnidvbclientsubtitle \
	bookplay_package \
	dvbepg \
	DVBPlayer \
	dvbsearch \
	DVBService \
	progmanager
endif

# ATV
BOARD_HAVE_ATV := true

ifeq ($(BOARD_HAVE_ATV), true)
PRODUCT_PACKAGES += \
        tvin_common \
        tvin_vdin \
        tvin_afe \
        tvin_hdmirx \
        ppmgr \
        libzvbi \
        libntsc_decode \
        libtv_client \
        tv \
        libtv_jni \
        libtvservice \
        libtvnative \
        libtvsnapscreen \
        tvserver \
        ATVService \
        TvTestMenu \
        TvSetup \
        TVService \
        TvScreen \
        TvSearch \
        newLauncher\
        LaunchWidget \
        TvLibRelease \
        TvPackageRelease \
        libkeycode_set_jni	\
        MediaFileBrowser \
        PictureShow \
        AmMusicPlay \
        TextReader \
        VideoPlayer2 \
        AtvScreen \
        libsmbbase \
        libsmbmnt \
        smbtree \
        smbd \
        smbc \
        TVSETTING 
endif

#arm audio decoder lib
PRODUCT_COPY_FILES += \
	device/amlogic/common/acodec_lib/libape.so:system/lib/libape.so	\
	device/amlogic/common/acodec_lib/libfaad.so:system/lib/libfaad.so	\
	device/amlogic/common/acodec_lib/libflac.so:system/lib/libflac.so	
	

# Device specific system feature description
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

#audio config files
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/media_profiles.xml:system/etc/media_profiles.xml \
        $(LOCAL_PATH)/media_codecs.xml:system/etc/media_codecs.xml \
	$(LOCAL_PATH)/asound.conf:system/etc/asound.conf \
	$(LOCAL_PATH)/asound.state:system/etc/asound.state \
	$(LOCAL_PATH)/audio_effects.conf:system/etc/audio_effects.conf \
	$(LOCAL_PATH)/mixer_paths.xml:system/etc/mixer_paths.xml
	
#tv ko
PRODUCT_COPY_FILES += $(LOCAL_PATH)/tvin_common.ko:root/boot/tvin_common.ko
PRODUCT_COPY_FILES += $(LOCAL_PATH)/tvin_afe.ko:root/boot/tvin_afe.ko
PRODUCT_COPY_FILES += $(LOCAL_PATH)/tvin_vdin.ko:root/boot/tvin_vdin.ko
PRODUCT_COPY_FILES += $(LOCAL_PATH)/tvin_hdmirx.ko:root/boot/tvin_hdmirx.ko
PRODUCT_COPY_FILES += $(LOCAL_PATH)/tvin_viuin.ko:root/boot/tvin_viuin.ko

#tv dec bin
PRODUCT_COPY_FILES += $(LOCAL_PATH)/dec:system/bin/dec

# USB
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml
	
# Wifi
PRODUCT_COPY_FILES += device/amlogic/h01ref/8192cu.ko:system/lib/8192cu.ko
PRODUCT_COPY_FILES += device/amlogic/h01ref/8192du.ko:system/lib/8192du.ko
PRODUCT_COPY_FILES += device/amlogic/h01ref/rt5370sta.ko:system/lib/rt5370sta.ko
PRODUCT_COPY_FILES += device/amlogic/h01ref/cfg80211.ko:system/lib/cfg80211.ko
PRODUCT_COPY_FILES += device/amlogic/h01ref/compat.ko:system/lib/compat.ko
PRODUCT_COPY_FILES += device/amlogic/h01ref/cfg80211_ath6kl.ko:system/lib/cfg80211_ath6kl.ko
PRODUCT_COPY_FILES += device/amlogic/h01ref/ath6kl_usb.ko:system/lib/ath6kl_usb.ko

PRODUCT_PACKAGES += dhcpcd.conf
#PRODUCT_COPY_FILES += device/amlogic/h01ref/8192cu.ko:system/lib/8192cu.ko
PRODUCT_PACKAGES += wpa_supplicant.conf
PRODUCT_PACKAGES += hostapd_wps
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/set_display_mode.sh:system/bin/set_display_mode.sh \
    $(LOCAL_PATH)/wififix.sh:system/bin/wififix.sh

# DTV
ifeq ($(BOARD_HAVE_DTV), true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/dtv_env.sh:system/bin/dtv_env.sh
endif

# DBCPY
PRODUCT_COPY_FILES += $(LOCAL_PATH)/db.sh:system/bin/db.sh
PRODUCT_COPY_FILES += $(LOCAL_PATH)/param/pq.db:system/etc/pq.db

PRODUCT_COPY_FILES += $(LOCAL_PATH)/initlogo.rle.bak:root/initlogo.rle.bak

#default copy factory channel copy
PRODUCT_COPY_FILES += $(LOCAL_PATH)/default_bootargs.sh:system/bin/default_bootargs.sh
PRODUCT_COPY_FILES += $(LOCAL_PATH)/default_bootargs.args:system/etc/default_bootargs.args

# input config files
PRODUCT_COPY_FILES += $(LOCAL_PATH)/remote.conf:system/etc/remote.conf
PRODUCT_COPY_FILES += $(LOCAL_PATH)/tvconfig.conf:system/etc/tvconfig.conf
PRODUCT_COPY_FILES += $(LOCAL_PATH)/tv_default.cfg:system/etc/tv_default.cfg
PRODUCT_COPY_FILES += $(LOCAL_PATH)/remote_mouse.conf:system/etc/remote_mouse.conf
PRODUCT_COPY_FILES += $(LOCAL_PATH)/Vendor_0001_Product_0001.kl:/system/usr/keylayout/Vendor_0001_Product_0001.kl

