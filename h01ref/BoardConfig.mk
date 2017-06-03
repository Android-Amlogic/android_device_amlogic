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

# config.mk
#
# Product-specific compile-time definitions.
#

##################################################### CPU
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true


##################################################### release package
TARGET_BOOTLOADER_BOARD_NAME := h01ref
TARGET_BOARD_PLATFORM := meson6
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_SIMULATOR := false

TARGET_NO_KERNEL := true
include device/amlogic/$(TARGET_PRODUCT)/Kernel.mk
TARGET_AMLOGIC_KERNEL := $(PRODUCT_OUT)/uImage
TARGET_AMLOGIC_RECOVERY_KERNEL := $(PRODUCT_OUT)/uImage_recovery

TARGET_BUILD_WIPE_USERDATA := false
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1073741824
BOARD_FLASH_BLOCK_SIZE := 2048


USE_OPENGL_RENDERER := true



# TV
BOARD_HAVE_TV := true

#fast booting of special function for tv
TV_FASTBOOTING_FUNCTION :=true

TARGET_AMLOGIC_PARAM := device/amlogic/h01ref/param
INSTALLED_AML_LOGO := device/amlogic/h01ref/logo.bmp
TARGET_CP_H01REF_ROOT_FILES := true

GET_INIT_BOOTARGSCHECK := true

MALI_PP_NUMBER :=4

include device/amlogic/$(TARGET_PRODUCT)/recovery/Recovery.mk
