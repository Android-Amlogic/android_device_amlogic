#if use probuilt kernel or build kernel from source code
-include device/amlogic/common/gpu.mk
USE_PREBUILT_KERNEL := false


INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel

ifeq ($(USE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	@echo "Kernel installed"
	$(transform-prebuilt-to-target)
	@echo "cp kernel modules"

else
ifeq ($(SUPPORT_HDMIIN),true)
KERNEL_DEVICETREE := meson8m2_n200C_1G_hdmiin meson8m2_n200C_2G_hdmiin meson8_k200b_1G_emmc_sdio_hdmiin meson8_k200b_1G_emmc_sdhc_hdmiin meson8_k200b_2G_emmc_sdhc_hdmiin meson8_k200b_2G_emmc_sdio_hdmiin m8m2_bcm4335_n200C_1G
else
KERNEL_DEVICETREE := meson8m2_n200C_1G meson8m2_n200C_2G m8m2_bcm4335_n200C_1G
endif

ifeq ($(TARGET_USE_SECUREOS),true)
KERNEL_DEFCONFIG := meson8_tee_defconfig
else
KERNEL_DEFCONFIG := meson8_defconfig
endif



KERNEL_ROOTDIR :=  common
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
INTERMEDIATES_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
BOARD_MKBOOTIMG_ARGS := --second $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb
INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/upgrade/dt.img
BOARD_MKBOOTIMG_ARGS := --second $(INSTALLED_DTIMAGE_TARGET)
TARGET_AMLOGIC_INT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
TARGET_AMLOGIC_INT_RECOVERY_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage_recovery
DTBTOOL := vendor/amlogic/tools/dtbTool
WORD_NUMBER := $(words $(KERNEL_DEVICETREE))
define build-dtimage-target
	mkdir -p $(PRODUCT_OUT)/upgrade
	#$(call pretty,"Target dt image: $(INSTALLED_DTIMAGE_TARGET)")
	@echo " Target dt image: $(INSTALLED_DTIMAGE_TARGET)"
	$(hide) $(DTBTOOL) -o $(INSTALLED_DTIMAGE_TARGET) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/
	$(hide) chmod a+r $@
endef
ifeq ($(WORD_NUMBER),1)
BOARD_MKBOOTIMG_ARGS := --second $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb
define cp-dtbs
	@echo " only one dtb"
	mkdir -p $(PRODUCT_OUT)/upgrade
	cp $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb $(PRODUCT_OUT)/upgrade/meson.dtb
	cp $(KERNEL_ROOTDIR)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtd $(PRODUCT_OUT)/upgrade/meson_target.dtd
endef
else
define cp-dtbs
	@echo " multi dtbs"
	mkdir -p $(PRODUCT_OUT)/upgrade
	$(foreach dtd_file,$(KERNEL_DEVICETREE), \
		cp $(KERNEL_ROOTDIR)/arch/arm/boot/dts/amlogic/$(dtd_file).dtd $(PRODUCT_OUT)/upgrade/; \
	)
	$(build-dtimage-target)
endef

endif
WIFI_OUT  := $(TARGET_OUT_INTERMEDIATES)/hardware/wifi

PREFIX_CROSS_COMPILE=arm-linux-gnueabihf-

define cp-modules
	mkdir -p $(PRODUCT_OUT)/root/boot
        mkdir -p $(PRODUCT_OUT)/upgrade
	mkdir -p $(TARGET_OUT)/lib

	#cp $(UMP_OUT)/ump.ko $(PRODUCT_OUT)/root/boot/
	cp $(WIFI_OUT)/realtek/drivers/8189es/rtl8189ES/8189es.ko $(TARGET_OUT)/lib/
	#cp $(WIFI_OUT)/broadcom/drivers/ap6xxx/broadcm_40181/dhd.ko $(TARGET_OUT)/lib/
	#cp $(KERNEL_ROOTDIR)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtd $(PRODUCT_OUT)/upgrade/meson_target.dtd
	cp $(KERNEL_OUT)/arch/arm/boot/meson.dtd $(PRODUCT_OUT)/upgrade/meson.dtd
	#cp $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb $(PRODUCT_OUT)/upgrade/meson.dtb
	$(cp-dtbs)
	cp $(KERNEL_OUT)/../hardware/amlogic/pmu/aml_pmu_dev.ko $(TARGET_OUT)/lib/
	cp $(shell pwd)/hardware/amlogic/thermal/aml_thermal.ko $(TARGET_OUT)/lib/
	cp $(KERNEL_OUT)/../hardware/amlogic/nand/amlnf/aml_nftl_dev.ko $(PRODUCT_OUT)/root/boot/
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEFCONFIG)


$(INTERMEDIATES_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG)
	@echo "make uImage"
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) uImage
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/amlogic/thermal/ ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
ifeq ($(WORD_NUMBER),1)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEVICETREE).dtd
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEVICETREE).dtb
else
	$(foreach dtd_file,$(KERNEL_DEVICETREE), \
		$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(dtd_file).dtd; \
		$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(dtd_file).dtb; \
	)
endif
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) dtd
	$(gpu-modules)
	$(cp-modules)

kerneltags: $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) menuconfig

savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) savedefconfig
	@echo
	@echo Saved to $(KERNEL_OUT)/defconfig
	@echo
	@echo handly merge to "$(KERNEL_ROOTDIR)/arch/arm/configs/$(KERNEL_DEFCONFIG)" if need
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
