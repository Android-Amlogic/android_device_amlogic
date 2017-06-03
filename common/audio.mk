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

PRODUCT_PACKAGES += \
    audio_policy.default \
    audio.primary.amlogic \
    acoustics.default \
    audio_firmware

ifdef DOLBY_UDC_MULTICHANNEL
PRODUCT_PACKAGES += \
		audio.hdmi6.amlogic
endif

PRODUCT_COPY_FILES += \
  $(TARGET_PRODUCT_DIR)/audio_policy.conf:system/etc/audio_policy.conf \
	$(TARGET_PRODUCT_DIR)/audio_effects.conf:system/etc/audio_effects.conf

#arm audio decoder lib
#PRODUCT_COPY_FILES += \
#	device/amlogic/common/acodec_lib/libape.so:system/lib/libape.so	\
#	device/amlogic/common/acodec_lib/libfaad.so:system/lib/libfaad.so	\
#	device/amlogic/common/acodec_lib/libflac.so:system/lib/libflac.so
PRODUCT_COPY_FILES += $(TOP)/packages/amlogic/LibPlayer/amadec/acodec_lib/*:system/lib/

################################################################################## alsa

ifeq ($(BOARD_ALSA_AUDIO),legacy)

PRODUCT_COPY_FILES += \
	$(TARGET_PRODUCT_DIR)/asound.conf:system/etc/asound.conf \
	$(TARGET_PRODUCT_DIR)/asound.state:system/etc/asound.state

BUILD_WITH_ALSA_UTILS := true

PRODUCT_PACKAGES += \
    alsa.default \
    libasound \
    alsa_aplay \
    alsa_ctl \
    alsa_amixer \
    alsainit-00main \
    alsalib-alsaconf \
    alsalib-pcmdefaultconf \
    alsalib-cardsaliasesconf
endif

################################################################################## tinyalsa

ifeq ($(BOARD_ALSA_AUDIO),tiny)

BUILD_WITH_ALSA_UTILS := false

# Audio
PRODUCT_PACKAGES += \
    audio.usb.default \
    libtinyalsa \
    tinyplay \
    tinycap \
    tinymix \
    audio.usb.amlogic
endif

##################################################################################
ifneq ($(wildcard $(TARGET_PRODUCT_DIR)/mixer_paths.xml),)
    PRODUCT_COPY_FILES += \
        $(TARGET_PRODUCT_DIR)/mixer_paths.xml:system/etc/mixer_paths.xml
else
    ifeq ($(BOARD_AUDIO_CODEC),rt5631)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/rt5631_mixer_paths.xml:system/etc/mixer_paths.xml
    endif

    ifeq ($(BOARD_AUDIO_CODEC),wm8960)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/wm8960_mixer_paths.xml:system/etc/mixer_paths.xml
    endif
    
    ifeq ($(BOARD_AUDIO_CODEC),dummy)
        PRODUCT_COPY_FILES += \
            hardware/amlogic/audio/dummy_mixer_paths.xml:system/etc/mixer_paths.xml
    endif
endif
