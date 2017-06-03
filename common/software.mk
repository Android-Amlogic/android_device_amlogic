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


#########################################################################
#
#                                                Amlogic player
#
#########################################################################
ifeq ($(BUILD_WITH_AMLOGIC_PLAYER),true)


PRODUCT_COPY_FILES += \
	$(TARGET_PRODUCT_DIR)/media_profiles.xml:system/etc/media_profiles.xml \
	$(TARGET_PRODUCT_DIR)/media_codecs.xml:system/etc/media_codecs.xml 

# Player
PRODUCT_PACKAGES += \
    amlogic.subtitle.xml \
    amlogic.libplayer.xml

endif

#########################################################################
#
#                                                App optimization
#
#########################################################################
ifeq ($(BUILD_WITH_APP_OPTIMIZATION),true)

PRODUCT_COPY_FILES += \
	$(TARGET_PRODUCT_DIR)/config:system/package_config/config \
	$(TARGET_PRODUCT_DIR)/liboptimization.so:system/lib/liboptimization.so

PRODUCT_PROPERTY_OVERRIDES += \
	ro.app.optimization=true

endif

#########################################################################
#
#                                                Widevine drm
#
#########################################################################
ifeq ($(BUILD_WITH_WIDEVINE_DRM),true)

PRODUCT_PROPERTY_OVERRIDES += drm.service.enable=true

PRODUCT_PACKAGES += com.google.widevine.software.drm.xml \
	com.google.widevine.software.drm \
	libWVStreamControlAPI_L1 \
	libdrmwvmplugin_L1 \
	libwvm_L1 \
	libwvdrm_L1 \
	libWVStreamControlAPI_L3 \
	libdrmwvmplugin \
	libwvm \
	libwvdrm_L3 \
	libotzapi \
	libwvsecureos_api \
	libdrmdecrypt \
	libwvdrmengine \
	liboemcrypto \
	widevine

endif

#########################################################################
#
#                                                PlayReady drm
#
#########################################################################
ifeq ($(BUILD_WITH_PLAYREADY_DRM),true)

PRODUCT_PACKAGES += libdrmplayreadyplugin \
	libsmoothstreaming_test \
	libsmoothstreaming \
	libprwmv \
	playready

PRODUCT_COPY_FILES += \
    vendor/playready/playreadyplugin/keycert/zgpriv.dat:system/etc/drm/playready/zgpriv.dat \
    vendor/playready/playreadyplugin/keycert/bgroupcert.dat:system/etc/drm/playready/bgroupcert.dat \
    vendor/playready/playreadyplugin/keycert/devcerttemplate.dat:system/etc/drm/playready/devcerttemplate.dat \
    vendor/playready/playreadyplugin/keycert/priv.dat:system/etc/drm/playready/priv.dat

endif


#########################################################################
#
#                                                Ereader
#
#########################################################################
ifeq ($(BUILD_WITH_EREADER),true)

PRODUCT_PACKAGES += \
	Ereader \
	libDeflatingDecompressor-v3.so \
	libLineBreak-v2.so \
	libNativeFormats-v2.so \
	libpdfview2.so \
	libstlport_shared.so
	
endif

#########################################################################
#
#                                                Facelock
#
#########################################################################
ifeq ($(BUILD_WITH_FACE_UNLOCK),true)

$(call inherit-product, device/amlogic/common/faceunlock/products/faceunlock.mk)

endif


#########################################################################
#
#                                                Miracast
#
#########################################################################
ifeq ($(BUILD_WITH_MIRACAST),true)

PRODUCT_PACKAGES += \
	Miracast \
	libstagefright_hdcp \
	libstagefright_hdcpkey

PRODUCT_COPY_FILES += \
	device/amlogic/common/miracast/srm.bin:system/etc/hdcp/srm.bin 
endif

#########################################################################
#
#                                                Xiaocong
#
#########################################################################
ifeq ($(BUILD_WITH_XIAOCONG),true)

PRODUCT_PACKAGES += \
        XCgamecenter.apk \
        libEventJNI4.so \
        xcuts.idc \
        xcmid-amlogic

endif

#########################################################################
#
#                                                Thirdpart APKs
#
#########################################################################
ifeq ($(BUILD_WITH_THIRDPART_APK),true)

PRODUCT_PACKAGES += \
	preinstall.sh \
  $(patsubst vendor/amlogic/prebuilt/preinstallation/%,%,$(wildcard vendor/amlogic/prebuilt/preinstallation/*.apk))
endif

ifeq ($(BUILD_WITH_BAIDU_APK),true)
PRODUCT_PACKAGES += \
	baidu_preinstall.sh \
  $(patsubst vendor/amlogic/prebuilt/baidu_preinstall_apk/%,%,$(wildcard vendor/amlogic/prebuilt/baidu_preinstall_apk/*.apk))
endif