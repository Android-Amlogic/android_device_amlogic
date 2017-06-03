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


# Check Logo Size

BOARD_TVMODE_ALL_SCALE := true
TARGET_CPU_ABI2 := armeabi
# Camera
USE_CAMERA_STUB := false
BOARD_HAVE_FRONT_CAM := false
BOARD_HAVE_BACK_CAM := false
BOARD_USE_USB_CAMERA := true
BOARD_HAVE_FLASHLIGHT := false

BOARD_VOUT_USES_FREESCALE := false
##################################################### CPU
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true

##################################################### release package
TARGET_BOOTLOADER_BOARD_NAME := g19ref
TARGET_BOARD_PLATFORM := meson6
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_SIMULATOR := false

TARGET_NO_KERNEL := false
include device/amlogic/$(TARGET_PRODUCT)/Kernel.mk
TARGET_AMLOGIC_BOOTLOADER := $(PRODUCT_OUT)/u-boot.bin
TARGET_AMLOGIC_LOGO := $(PRODUCT_OUT)/res-package.img
TARGET_AMLOGIC_RES_PACKAGE := device/amlogic/$(TARGET_DEVICE)/res_pack
#TARGET_AMLOGIC_AML_LOGO := device/amlogic/$(TARGET_PRODUCT)/aml_logo.bmp
# Check Logo Size
BOARD_MATCH_LOGO_SIZE := true
#save ubootenv in nand partition
UBOOTENV_SAVE_IN_NAND := false
BOARD_UBOOTENV_BIG_SIZE := true
TARGET_BUILD_WIPE_USERDATA := false
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 536870912
BOARD_FLASH_BLOCK_SIZE := 512
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2362232012
TARGET_ENABLE_SCALE_FUNCTION := true
TARGET_HAS_HDMIONLY_FUNCTION := true

USE_OPENGL_RENDERER := true


