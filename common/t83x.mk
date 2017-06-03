#
# Copyright (C) 2015 The Android Open Source Project
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

MALI=hardware/arm/gpu/t83x/kernel/drivers/gpu/arm/midgard
MALI_OUT=hardware/arm/gpu/t83x/kernel/drivers/gpu/arm/midgard
KERNEL_ARCH ?= arm
ifeq (,$(wildcard $(MALI)))
MALI=hardware/arm/gpu/t83x/driver/product/kernel/drivers/gpu/arm/midgard
MALI_OUT=hardware/arm/gpu/t83x/driver/product/kernel/drivers/gpu/arm/midgard
endif

define gpu-modules

$(MALI_KO):
	@echo "make mali module KERNEL_ARCH is $(KERNEL_ARCH) current dir is $(shell pwd)"
	@echo "MALI is $(MALI), MALI_OUT is $(MALI_OUT)"
	$(MAKE) -C $(MALI) KDIR=$(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ 	  \
	ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) \
	EXTRA_CFLAGS="-DMALI_GCC_WORKAROUND_MIDCOM_4598=1 -DCONFIG_MALI_PLATFORM_DEVICETREE -DCONFIG_MALI_BACKEND=gpu" \
	MALI_GCC_WORKAROUND_MIDCOM_4598=1 CONFIG_MALI_MIDGARD=m CONFIG_MALI_PLATFORM_DEVICETREE=y CONFIG_MALI_BACKEND=gpu

	mkdir -p $(PRODUCT_OUT)/root/boot
	cp $(MALI_OUT)/mali_kbase.ko $(PRODUCT_OUT)/root/boot/
	$(cd -)
	@echo "make mali module finished current dir is $(shell pwd)"
endef
	#ifeq($(pwd),/mnt/filerot/jiyu.yang/WORK_DIR/s905)
	#$(error cd failed)
	#endif
