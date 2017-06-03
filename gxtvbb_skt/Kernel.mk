#if use probuilt kernel or build kernel from source code
-include device/amlogic/common/t83x.mk

USE_PREBUILT_KERNEL := false


INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel

ifeq ($(USE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	@echo "Kernel installed"
	$(transform-prebuilt-to-target)
	@echo "cp kernel modules"

else

KERNEL_DEVICETREE := gxtvbb_skt
KERNEL_DEFCONFIG := meson64_defconfig
KERNEL_ARCH := arm64
KERNEL_ROOTDIR := common

KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
INTERMEDIATES_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image.lzo
BOARD_MKBOOTIMG_ARGS := --second $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb
INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/upgrade/dt.img
BOARD_MKBOOTIMG_ARGS := --second $(INSTALLED_DTIMAGE_TARGET)
TARGET_AMLOGIC_INT_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/uImage
TARGET_AMLOGIC_INT_RECOVERY_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image_recovery
DTBTOOL := vendor/amlogic/tools/dtbTool
WORD_NUMBER := $(words $(KERNEL_DEVICETREE))
define build-dtimage-target
	mkdir -p $(PRODUCT_OUT)/upgrade
	#$(call pretty,"Target dt image: $(INSTALLED_DTIMAGE_TARGET)")
	@echo " Target dt image: $(INSTALLED_DTIMAGE_TARGET)"
	$(hide) $(DTBTOOL) -o $(INSTALLED_DTIMAGE_TARGET) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/
	$(hide) chmod a+r $@
endef
ifeq ($(WORD_NUMBER),1)
BOARD_MKBOOTIMG_ARGS := --second $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb
define cp-dtbs
	@echo " only one dtb"
	mkdir -p $(PRODUCT_OUT)/upgrade
	cp $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb $(PRODUCT_OUT)/upgrade/meson.dtb
endef
else
define cp-dtbs
	@echo " multi dtbs"
	mkdir -p $(PRODUCT_OUT)/upgrade
	$(foreach dtd_file,$(KERNEL_DEVICETREE), \
		cp $(KERNEL_ROOTDIR)/arch/$(KERNEL_ARCH)/boot/dts/$(dtd_file).dtd $(PRODUCT_OUT)/upgrade/; \
	)
	$(build-dtimage-target)
endef

endif

WIFI_OUT  := $(TARGET_OUT_INTERMEDIATES)/hardware/wifi

PREFIX_CROSS_COMPILE=aarch64-linux-gnu-

define cp-modules
	mkdir -p $(PRODUCT_OUT)/root/boot
        mkdir -p $(PRODUCT_OUT)/upgrade
	mkdir -p $(TARGET_OUT)/lib

#	-cp $(KERNEL_OUT)/drivers/amlogic/usb/dwc_otg/310/dwc_otg.ko $(TARGET_OUT)/lib/
#	cp $(WIFI_OUT)/broadcom/drivers/ap6xxx/broadcm_40181/dhd.ko $(TARGET_OUT)/lib/
	#cp $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(KERNEL_DEVICETREE).dtb $(PRODUCT_OUT)/upgrade/meson.dtb
	$(cp-dtbs)
#	cp $(KERNEL_OUT)/../hardware/amlogic/pmu/aml_pmu_dev.ko $(TARGET_OUT)/lib/
	cp $(shell pwd)/hardware/amlogic/thermal/aml_thermal.ko $(TARGET_OUT)/lib/
#	cp $(KERNEL_OUT)/../hardware/amlogic/nand/amlnf/aml_nftl_dev.ko $(PRODUCT_OUT)/root/boot/
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEFCONFIG)


$(INTERMEDIATES_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG)
	@echo "make Image"
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE)
#	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd_1_201_59_x ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
#	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8189es/rtl8189ES ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
#	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/amlogic/thermal/ ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
ifeq ($(WORD_NUMBER),1)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEVICETREE).dtb
else
	$(foreach dtd_file,$(KERNEL_DEVICETREE), \
		$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(dtd_file).dtb; \
	)
endif
	$(gpu-modules)
	$(cp-modules)

kerneltags: $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) menuconfig

savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) savedefconfig
	@echo
	@echo Saved to $(KERNEL_OUT)/defconfig
	@echo
	@echo handly merge to "$(KERNEL_ROOTDIR)/arch/$(KERNEL_ARCH)/configs/$(KERNEL_DEFCONFIG)" if need
	@echo

$(INSTALLED_KERNEL_TARGET): $(INTERMEDIATES_KERNEL) | $(ACP)
	@echo "Kernel installed"
	$(transform-prebuilt-to-target)

.PHONY: bootimage-quick
bootimage-quick: $(INTERMEDIATES_KERNEL)
	cp -v $(INTERMEDIATES_KERNEL) $(INSTALLED_KERNEL_TARGET)
	out/host/linux-x86/bin/mkbootfs $(PRODUCT_OUT)/root | \
	out/host/linux-x86/bin/minigzip > $(PRODUCT_OUT)/ramdisk.img
	out/host/linux-x86/bin/mkbootimg  --kernel $(INTERMEDIATES_KERNEL) \
		--base 0x0 \
		--kernel_offset 0x1080000 \
		--ramdisk $(PRODUCT_OUT)/ramdisk.img \
		$(BOARD_MKBOOTIMG_ARGS) \
		--output $(PRODUCT_OUT)/boot.img
	ls -l $(PRODUCT_OUT)/boot.img
	echo "Done building boot.img"

.PHONY: recoveryimage-quick
recoveryimage-quick: $(INTERMEDIATES_KERNEL)
	cp -v $(INTERMEDIATES_KERNEL) $(INSTALLED_KERNEL_TARGET)
	out/host/linux-x86/bin/mkbootfs $(PRODUCT_OUT)/recovery/root | \
	out/host/linux-x86/bin/minigzip > $(PRODUCT_OUT)/ramdisk-recovery.img
	out/host/linux-x86/bin/mkbootimg  --kernel $(INTERMEDIATES_KERNEL) \
		--base 0x0 \
		--kernel_offset 0x1080000 \
		--ramdisk $(PRODUCT_OUT)/ramdisk-recovery.img \
		$(BOARD_MKBOOTIMG_ARGS) \
		--output $(PRODUCT_OUT)/recovery.img
	ls -l $(PRODUCT_OUT)/recovery.img
	echo "Done building recovery.img"

.PHONY: kernelconfig

.PHONY: savekernelconfig

endif

$(PRODUCT_OUT)/ramdisk.img: $(INSTALLED_KERNEL_TARGET)
$(PRODUCT_OUT)/system.img: $(INSTALLED_KERNEL_TARGET)
