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
ifeq ($(ANDROID_BUILD_TYPE), 32)
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a9
else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_VARIANT := cortex-a9
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true
endif

TARGET_USES_64_BIT_BINDER := true

TARGET_NO_BOOTLOADER := false
TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true
TARGET_NO_RECOVERY := false

TARGET_BOARD_PLATFORM := gxbaby
TARGET_BOOTLOADER_BOARD_NAME := gxtvbb_skt

USE_OPENGL_RENDERER := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

USING_ION := true
GPU_TARGET_PLATFORM := default_8a
MESON_GRALLOC_DIR :=hardware/arm/gpu/t83x/android/gralloc/src
KERNEL_ARCH ?= arm
ifeq (,$(wildcard $(MESON_GRALLOC_DIR)))
MESON_GRALLOC_DIR :=hardware/arm/gpu/t83x/driver/product/android/gralloc/src
endif
GPU_TYPE:=t83x

# Camera
USE_CAMERA_STUB := false
BOARD_HAVE_FRONT_CAM := false
BOARD_HAVE_BACK_CAM := false
BOARD_USE_USB_CAMERA := true
IS_CAM_NONBLOCK := true
BOARD_HAVE_FLASHLIGHT := false
BOARD_HAVE_HW_JPEGENC := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1073741824
BOARD_USERDATAIMAGE_PARTITION_SIZE := 576716800
BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 4096

TARGET_SUPPORT_USB_BURNING_V2 := true
TARGET_AMLOGIC_RES_PACKAGE := device/amlogic/gxtvbb_skt/logo_img_files

BOARD_HAL_STATIC_LIBRARIES := libhealthd.mboxdefault

USE_E2FSPROGS := true

BOARD_KERNEL_BASE := 0x0
BOARD_KERNEL_OFFSET := 0x1080000

BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_ALSA_AUDIO := true

TARGET_RELEASETOOLS_EXTENSIONS := device/amlogic/common
TARGET_USE_BLOCK_BASE_UPGRADE := true
TARGET_OTA_UPDATE_DTB := true
#TARGET_RECOVERY_DISABLE_ADB_SIDELOAD := true

BOARD_HAVE_BLUETOOTH_BCM := true
include device/amlogic/common/sepolicy.mk
MALLOC_IMPL := dlmalloc
