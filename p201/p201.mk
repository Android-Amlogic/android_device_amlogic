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
# build for Meson reference board.
#

# Dynamic enable start/stop zygote_secondary in 64bits
# and 32bit system, default closed
#TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE := true

# Inherit from those products. Most specific first.
ifneq ($(ANDROID_BUILD_TYPE), 32)
ifeq ($(TARGET_DYNAMIC_ZYGOTE_SECONDARY_ENABLE), true)
$(call inherit-product, device/amlogic/common/dynamic_zygote_seondary/dynamic_zygote_64_bit.mk)
else
$(call inherit-product, build/target/product/core_64_bit.mk)
endif
endif

$(call inherit-product, device/amlogic/common/products/mbox/product_mbox.mk)
$(call inherit-product, device/amlogic/p201/device.mk)
$(call inherit-product-if-exists, vendor/google/products/gms.mk)

# p201:

NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

PRODUCT_PROPERTY_OVERRIDES += \
        sys.fb.bits=32

PRODUCT_NAME := p201
PRODUCT_DEVICE := p201
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on p201
PRODUCT_MANUFACTURER := amlogic

WITH_LIBPLAYER_MODULE := false


#########Support compiling out encrypted zip/aml_upgrade_package.img directly
#PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY := true
PRODUCT_AML_SECUREBOOT_USERKEY := ./uboot/board/amlogic/gxb_p201_v1/aml-user-key.sig
PRODUCT_AML_SECUREBOOT_SIGNTOOL := ./uboot/fip/aml_encrypt_gxb
PRODUCT_AML_SECUREBOOT_SIGNBOOTLOADER := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --bootsig \
						--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY) \
						--aeskey enable
PRODUCT_AML_SECUREBOOT_SIGNIMAGE := $(PRODUCT_AML_SECUREBOOT_SIGNTOOL) --imgsig \
					--amluserkey $(PRODUCT_AML_SECUREBOOT_USERKEY)


#########################################################################
#
#                                                Dm-Verity
#
#########################################################################
#BUILD_WITH_DM_VERITY := true
#TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL := true
ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
BUILD_WITH_DM_VERITY := true
endif # ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL), true)
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_COPY_FILES += \
    device/amlogic/p201/fstab.verity.amlogic:root/fstab.amlogic
else
PRODUCT_COPY_FILES += \
    device/amlogic/p201/fstab.amlogic:root/fstab.amlogic
endif # ifeq ($(BUILD_WITH_DM_VERITY), true)

#########################################################################
#
#                                                WiFi
#
#########################################################################

#WIFI_MODULE := rtl8189es
MULTI_WIFI_SUPPORT =true
include device/amlogic/common/wifi.mk

# Change this to match target country
# 11 North America; 14 Japan; 13 rest of world
PRODUCT_DEFAULT_WIFI_CHANNELS := 11


#########################################################################
#
#                                                Bluetooth
#
#########################################################################

BOARD_HAVE_BLUETOOTH := false
#BLUETOOTH_MODULE := AP6234
#include device/amlogic/common/bluetooth.mk


#########################################################################
#
#                                                ConsumerIr
#
#########################################################################

#PRODUCT_PACKAGES += \
#    consumerir.amlogic \
#    SmartRemote
#PRODUCT_COPY_FILES += \
#    frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml


#PRODUCT_PACKAGES += libbt-vendor

ifeq ($(SUPPORT_HDMIIN),true)
PRODUCT_PACKAGES += \
    libhdmiin \
    HdmiIn
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

# Audio
#
BOARD_ALSA_AUDIO=tiny
include device/amlogic/common/audio.mk

#########################################################################
#
#                                                Camera
#
#########################################################################

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml



#########################################################################
#
#                                                PlayReady DRM
#
#########################################################################
#BUILD_WITH_PLAYREADY_DRM := true
ifeq ($(BUILD_WITH_PLAYREADY_DRM), true)
#playready license process in smoothstreaming(default)
BOARD_PLAYREADY_LP_IN_SS := true
#BOARD_PLAYREADY_TVP := true
endif

#########################################################################
#
#                                                Verimatrix DRM
##########################################################################
#verimatrix web
BUILD_WITH_VIEWRIGHT_WEB := false
#verimatrix stb
BUILD_WITH_VIEWRIGHT_STB := false
#########################################################################


#DRM Widevine
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL), 1)
TARGET_USE_OPTEEOS := true
endif

$(call inherit-product, device/amlogic/common/media.mk)

#########################################################################
#
#                                                Languages
#
#########################################################################

# For all locales, $(call inherit-product, build/target/product/languages_full.mk)
PRODUCT_LOCALES := en_US en_AU en_IN fr_FR it_IT es_ES et_EE de_DE nl_NL cs_CZ pl_PL ja_JP \
  zh_TW zh_CN zh_HK ru_RU ko_KR nb_NO es_US da_DK el_GR tr_TR pt_PT pt_BR rm_CH sv_SE bg_BG \
  ca_ES en_GB fi_FI hi_IN hr_HR hu_HU in_ID iw_IL lt_LT lv_LV ro_RO sk_SK sl_SI sr_RS uk_UA \
  vi_VN tl_PH ar_EG fa_IR th_TH sw_TZ ms_MY af_ZA zu_ZA am_ET hi_IN en_XA ar_XB fr_CA km_KH \
  lo_LA ne_NP si_LK mn_MN hy_AM az_AZ ka_GE my_MM mr_IN ml_IN is_IS mk_MK ky_KG eu_ES gl_ES \
  bn_BD ta_IN kn_IN te_IN uz_UZ ur_PK kk_KZ

#################################################################################
#
#                                                PPPOE
#
#################################################################################

BUILD_WITH_PPPOE := true

ifeq ($(BUILD_WITH_PPPOE),true)
PRODUCT_PACKAGES += \
    PPPoE \
    libpppoejni \
    libpppoe \
    pppoe_wrapper \
    pppoe \
    droidlogic.frameworks.pppoe \
    droidlogic.external.pppoe \
    droidlogic.external.pppoe.xml
PRODUCT_PROPERTY_OVERRIDES += \
    ro.platform.has.pppoe=true
endif

#################################################################################
#
#                                                DEFAULT LOWMEMORYKILLER CONFIG
#
#################################################################################
BUILD_WITH_LOWMEM_COMMON_CONFIG := true

BOARD_USES_USB_PM := true
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/Third_party_apk_camera.xml:system/etc/Third_party_apk_camera.xml \

TARGET_BUILD_CTS:= false

#########################################################################
#
#                                                Instaboot
#
#########################################################################

BOARD_SUPPORT_INSTABOOT := true
include device/amlogic/common/software.mk


ifeq ($(BOARD_SUPPORT_INSTABOOT),true)
local_instaboot := $(strip $(wildcard $(LOCAL_PATH)/instabootserver))
ifneq ($(local_instaboot),)
PRODUCT_COPY_FILES += \
  $(LOCAL_PATH)/instabootserver:system/bin/instabootserver
endif
local_instaboot_xml := $(strip $(wildcard $(LOCAL_PATH)/instaboot_config.xml))
ifneq ($(local_instaboot_xml),)
PRODUCT_COPY_FILES += \
  $(LOCAL_PATH)/instaboot_config.xml:system/etc/instaboot_config.xml
endif
endif
