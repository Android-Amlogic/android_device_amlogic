# Copyright (C) 2010 The Android Open Source Project
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

ifneq ($(TARGET_AMLOGIC_RES_PACKAGE),)

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := FAKE
LOCAL_MODULE_SUFFIX := -timestamp

LOCAL_MODULE := img-package
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES := $(IMGPACK)

$(LOCAL_MODULE):
	@echo
	@echo "generate $(PRODUCT_OUT)/res-package.img"
	@echo
	$(IMGPACK) -r $(TARGET_AMLOGIC_RES_PACKAGE) $(PRODUCT_OUT)/res-package.img

#include $(BUILD_PHONY_PACKAGE)

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(IMGPACK)
	$(hide) echo "Fake: $@"
	$(hide) mkdir -p $(dir $@)
	$(hide) touch $@
	@echo
	@echo "generate $(PRODUCT_OUT)/res-package.img"
	@echo
	$(IMGPACK) -r $(TARGET_AMLOGIC_RES_PACKAGE) $(PRODUCT_OUT)/res-package.img

endif
