ifeq ($(TARGET_CP_H10REF_ROOT_FILES),true)
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

$(shell cd $(LOCAL_PATH) && mkdir -p $(ANDROID_PRODUCT_OUT)/system && cp -rf system/* $(ANDROID_PRODUCT_OUT)/system > /dev/null)
endif

