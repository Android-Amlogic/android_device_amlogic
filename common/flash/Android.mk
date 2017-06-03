
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := oem_install_flash_player_jb_mr1.apk
LOCAL_SRC_FILES := oem_install_flash_player_jb_mr1.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_PATH := $(TARGET_OUT)/app
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libflashplayer.so
LOCAL_SRC_FILES := libflashplayer.so
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/plugins/com.adobe.flashplayer/
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libysshared.so
LOCAL_SRC_FILES := libysshared.so
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/plugins/com.adobe.flashplayer/
include $(BUILD_PREBUILT)

