#
# Copyright (C) 2012 The Android Open Source Project
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

#Support moduels:
#                bcm40183
#                bcm40181
#                rtl8192cu
#                rtl8188eu
#                rt5370
#								 mt7601
#								 mt5931

PRODUCT_PACKAGES += wpa_supplicant.conf
PRODUCT_PACKAGES += hostapd_wps

PRODUCT_COPY_FILES += \
	device/amlogic/common/tools/wififix.sh:system/bin/wififix.sh
	
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml

PRODUCT_PROPERTY_OVERRIDES += \
	ro.carrier=wifi-only

################################################################################## bcm40183
ifeq ($(WIFI_MODULE),bcm40183)

WIFI_DRIVER := bcm40183
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/40183/fw_bcm40183b2.bin nvram_path=/etc/wifi/40183/nvram.txt"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/40183/fw_bcm40183b2.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/40183/fw_bcm40183b2_apsta.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/40183/fw_bcm40183b2_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd

PRODUCT_PACKAGES += \
	40183/nvram.txt \
	40183/fw_bcm40183b2.bin \
	40183/fw_bcm40183b2_apsta.bin \
	40183/fw_bcm40183b2_p2p.bin \
	wl \
	dhd

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

endif

################################################################################## bcm40181
ifeq ($(WIFI_MODULE),bcm40181)
WIFI_DRIVER := bcm40181
WIFI_DRIVER_MODULE_PATH := /system/lib/dhd.ko
WIFI_DRIVER_MODULE_NAME := dhd
WIFI_DRIVER_MODULE_ARG  := "firmware_path=/etc/wifi/40181/fw_bcm40181a2.bin nvram_path=/etc/wifi/40181/nvram.txt"
WIFI_DRIVER_FW_PATH_STA :=/etc/wifi/40181/fw_bcm40181a2.bin
WIFI_DRIVER_FW_PATH_AP  :=/etc/wifi/40181/fw_bcm40181a2_apsta.bin
WIFI_DRIVER_FW_PATH_P2P :=/etc/wifi/40181/fw_bcm40181a2_p2p.bin

BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"

WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd

PRODUCT_PACKAGES += \
	40181/nvram.txt \
	40181/fw_bcm40181a0.bin \
	40181/fw_bcm40181a0_apsta.bin \
	40181/fw_bcm40181a2.bin \
	40181/fw_bcm40181a2_apsta.bin \
	40181/fw_bcm40181a2_p2p.bin \
	wl \
	dhd 

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/dhd.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/dhd.ko:system/lib/dhd.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
	
endif
################################################################################## rtl8192cu
ifeq ($(WIFI_MODULE),rtl8192cu)

WIFI_DRIVER             := rtl8192cu
BOARD_WIFI_VENDOR       := realtek
WIFI_DRIVER_MODULE_PATH := /system/lib/8192cu.ko
WIFI_DRIVER_MODULE_NAME := 8192cu
WIFI_DRIVER_FW_PATH_STA := none
WIFI_DRIVER_MODULE_ARG  := "ifname=wlan0 if2name=p2p0"

WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
CONFIG_DRIVER_WEXT               :=y
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_nl80211
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_nl80211

BOARD_WLAN_DEVICE := rtl8192cu

WIFI_FIRMWARE_LOADER      := ""
WIFI_DRIVER_FW_PATH_STA   := ""
WIFI_DRIVER_FW_PATH_AP    := ""
WIFI_DRIVER_FW_PATH_P2P   := ""
WIFI_DRIVER_FW_PATH_PARAM := ""

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/8192cu.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/8192cu.ko:system/lib/8192cu.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
	
endif
################################################################################## rtl8188eu
ifeq ($(WIFI_MODULE),rtl8188eu)

PRODUCT_COPY_FILESWIFI_DRIVER             := rtl8188eu
BOARD_WIFI_VENDOR       := realtek
WIFI_DRIVER_MODULE_PATH := /system/lib/8188eu.ko
WIFI_DRIVER_MODULE_NAME := 8188eu

WIFI_DRIVER_FW_PATH_STA          := none
WIFI_DRIVER_MODULE_ARG           := "ifname=wlan0 if2name=p2p0"

WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
CONFIG_DRIVER_WEXT               :=y
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_nl80211
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_nl80211

BOARD_WLAN_DEVICE := rtl8189es

WIFI_FIRMWARE_LOADER      := ""
WIFI_DRIVER_FW_PATH_STA   := ""
WIFI_DRIVER_FW_PATH_AP    := ""
WIFI_DRIVER_FW_PATH_P2P   := ""
WIFI_DRIVER_FW_PATH_PARAM := ""

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml


ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/8188eu.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/8188eu.ko:system/lib/8188eu.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
	
endif
################################################################################## rt5370
ifeq ($(WIFI_MODULE),rt5370)

WIFI_DRIVER             := rt5370
WIFI_DRIVER_MODULE_PATH := /system/lib/rt5370sta.ko
WIFI_DRIVER_MODULE_NAME := rt5370sta

WIFI_DRIVER_FW_PATH_STA := none
WPA_SUPPLICANT_VERSION  := VER_0_8_X

CONFIG_DRIVER_WEXT                :=y
BOARD_WPA_SUPPLICANT_PRIVATE_LIB  := lib_driver_cmd_nl80211
BOARD_WPA_SUPPLICANT_DRIVER       := NL80211

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/rt5370sta.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/rt5370sta.ko:system/lib/rt5370sta.ko
endif

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
	
endif

################################################################################## mt7601u
ifeq ($(WIFI_MODULE),mt7601u)

WIFI_DRIVER             := mt7601u
WIFI_DRIVER_MODULE_PATH := /system/lib/mt7601Usta.ko
WIFI_DRIVER_MODULE_NAME := mt7601Usta

WPA_SUPPLICANT_VERSION  := VER_0_8_X
CONFIG_DRIVER_WEXT                :=y
BOARD_WPA_SUPPLICANT_DRIVER       := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB  := lib_driver_cmd_mtk

PRODUCT_COPY_FILES += device/amlogic/$(TARGET_PRODUCT)/MT7601EEPROM.bin:system/bin/MT7601EEPROM.bin
PRODUCT_COPY_FILES += device/amlogic/$(TARGET_PRODUCT)/RT2870STA.dat:system/etc/Wireless/RT2870STA/RT2870STA.dat

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
	
endif
################################################################################## mt5931
ifeq ($(WIFI_MODULE),mt5931)

MTK_WLAN_SUPPORT				:= true
WIFI_DRIVER             := mt5931
WIFI_DRIVER_MODULE_PATH := /system/lib/wlan.ko
WIFI_DRIVER_MODULE_NAME := wlan
P2P_SUPPLICANT_VERSION  := VER_0_8_X_MTK
BOARD_P2P_SUPPLICANT_DRIVER       := NL80211

 PRODUCT_PACKAGES += \
      p2p_supplicant.conf	

ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/wlan.ko),)
PRODUCT_COPY_FILES += $(TARGET_PRODUCT_DIR)/wlan.ko:system/lib/wlan.ko
endif    

PRODUCT_COPY_FILES += hardware/amlogic/wifi/mt5931/WIFI_RAM_CODE:system/etc/firmware/WIFI_RAM_CODE

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml
	
PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0
	
endif

################################################################################## AP6xxx
ifeq ($(WIFI_AP6xxx_MODULE),AP6181)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6181/Wi-Fi/fw_bcm40181a2.bin:system/etc/wifi/40181/fw_bcm40181a2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6181/Wi-Fi/fw_bcm40181a2_apsta.bin:system/etc/wifi/40181/fw_bcm40181a2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6181/Wi-Fi/fw_bcm40181a2_p2p.bin:system/etc/wifi/40181/fw_bcm40181a2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6181/Wi-Fi/nvram_ap6181.txt:system/etc/wifi/40181/nvram.txt

endif

ifeq ($(WIFI_AP6xxx_MODULE),AP6210)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6210/Wi-Fi/fw_bcm40181a2.bin:system/etc/wifi/40181/fw_bcm40181a2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6210/Wi-Fi/fw_bcm40181a2_apsta.bin:system/etc/wifi/40181/fw_bcm40181a2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6210/Wi-Fi/fw_bcm40181a2_p2p.bin:system/etc/wifi/40181/fw_bcm40181a2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6210/Wi-Fi/nvram_ap6210.txt:system/etc/wifi/40181/nvram.txt

endif

ifeq ($(WIFI_AP6xxx_MODULE),AP6476)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6476/Wi-Fi/fw_bcm40181a2.bin:system/etc/wifi/40181/fw_bcm40181a2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6476/Wi-Fi/fw_bcm40181a2_apsta.bin:system/etc/wifi/40181/fw_bcm40181a2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6476/Wi-Fi/fw_bcm40181a2_p2p.bin:system/etc/wifi/40181/fw_bcm40181a2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6476/Wi-Fi/nvram_ap6476.txt:system/etc/wifi/40181/nvram.txt

endif

ifeq ($(WIFI_AP6xxx_MODULE),AP6493)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6493/Wi-Fi/fw_bcm40183b2.bin:system/etc/wifi/40183/fw_bcm40183b2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6493/Wi-Fi/fw_bcm40183b2_apsta.bin:system/etc/wifi/40183/fw_bcm40183b2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6493/Wi-Fi/fw_bcm40183b2_p2p.bin:system/etc/wifi/40183/fw_bcm40183b2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6493/Wi-Fi/nvram_ap6476.txt:system/etc/wifi/40183/nvram.txt

endif

ifeq ($(WIFI_AP6xxx_MODULE),AP6330)

PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6330/Wi-Fi/fw_bcm40183b2.bin:system/etc/wifi/40183/fw_bcm40183b2.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6330/Wi-Fi/fw_bcm40183b2_apsta.bin:system/etc/wifi/40183/fw_bcm40183b2_apsta.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6330/Wi-Fi/fw_bcm40183b2_p2p.bin:system/etc/wifi/40183/fw_bcm40183b2_p2p.bin
PRODUCT_COPY_FILES += hardware/amlogic/wifi/AP6xxx/AP6330/Wi-Fi/nvram_ap6330.txt:system/etc/wifi/40183/nvram.txt

endif
