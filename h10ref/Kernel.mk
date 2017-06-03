ifneq ($(TARGET_AMLOGIC_KERNEL),)

KERNEL_DEFCONFIG := meson6tv_h10_defconfig
KERNEL_ROOTDIR :=  common
KERNEL_OUT := $(ANDROID_PRODUCT_OUT)/obj/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
TARGET_PREBUILT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
TARGET_AMLOGIC_INT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
TARGET_AMLOGIC_INT_RECOVERY_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage_recovery
MALI_OUT := $(ANDROID_PRODUCT_OUT)/obj/hardware/arm/gpu/mali
UMP_OUT  := $(ANDROID_PRODUCT_OUT)/obj/hardware/arm/gpu/ump
TVIN_OUT := $(KERNEL_OUT)/drivers/amlogic/tvin

#FIXME tvin_*.ko?
define cp-modules
cp $(UMP_OUT)/ump.ko $(ANDROID_PRODUCT_OUT)/root/boot/
cp $(MALI_OUT)/mali.ko $(ANDROID_PRODUCT_OUT)/root/boot/
cp $(TVIN_OUT)/tvafe/tvin_afe.ko $(ANDROID_PRODUCT_OUT)/root/boot/
cp $(TVIN_OUT)/tvin_common.ko $(ANDROID_PRODUCT_OUT)/root/boot/
cp $(TVIN_OUT)/hdmirx/tvin_hdmirx.ko $(ANDROID_PRODUCT_OUT)/root/boot/
cp $(TVIN_OUT)/vdin/tvin_vdin.ko $(ANDROID_PRODUCT_OUT)/root/boot/
cp $(TVIN_OUT)/viu/tvin_viuin.ko $(ANDROID_PRODUCT_OUT)/root/boot/
cp $(KERNEL_OUT)/drivers/amlogic/load_deferred_module/deferreddrv.ko $(ANDROID_PRODUCT_OUT)/root/boot/
cp $(KERNEL_OUT)/drivers/amlogic/load_deferred_module/deferreddrv.ko $(ANDROID_PRODUCT_OUT)/recovery/root/boot/
cp $(KERNEL_OUT)/drivers/amlogic/wifi/rtl8xxx_CU/8192cu.ko $(ANDROID_PRODUCT_OUT)/system/lib/
endef

define defconfig-to-absolute-recovery
	echo $(KERNEL_CONFIG)
	if [ "$$(grep '^CONFIG_INITRAMFS_SOURCE="\.\.' $(KERNEL_CONFIG))" ]; then \
		sed -i 's,^CONFIG_INITRAMFS_SOURCE="\.\.,CONFIG_INITRAMFS_SOURCE="$(ANDROID_BUILD_TOP)\/$(KERNEL_ROOTDIR)\/\.\.,' $(KERNEL_CONFIG) ;\
		sed -i 's/\/root/\/recovery\/root/' $(KERNEL_CONFIG) ;\
	fi
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- $(KERNEL_DEFCONFIG)

#$(TARGET_AMLOGIC_INT_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG) $(BUILT_RAMDISK_TARGET) $(INSTALLED_AMLOGIC_RECOVERY_TARGET) $(ACP)
$(TARGET_AMLOGIC_INT_KERNEL): $(KERNEL_OUT) $(BUILT_RAMDISK_TARGET) $(INSTALLED_AMLOGIC_RECOVERY_TARGET) $(ACP)
	$(if $(wildcard arch/$(SRCARCH)/boot/uImage), \
        @mv $(KERNEL_OUT)/arch/arm/boot/uImage $(KERNEL_OUT)/arch/arm/boot/__uImage)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- $(KERNEL_DEFCONFIG)
	$(defconfig-to-absolute-recovery)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- uImage
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- modules
	$(cp-modules)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- uImage
	@mv $(KERNEL_OUT)/arch/arm/boot/uImage $(KERNEL_OUT)/arch/arm/boot/uImage_recovery
	@echo " Image arch/$(SRCARCH)/boot/uImage_recovery is ready"
	$(if $(wildcard $(KERNEL_OUT)/arch/arm/boot/__uImage), \
        @mv $(KERNEL_OUT)/arch/arm/boot/__uImage $(KERNEL_OUT)/arch/arm/boot/uImage)
	$(cp-modules)
	$$(sed -i 's/\/recovery\/root/\/root/' $(KERNEL_CONFIG))
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- uImage

.PHONY: kernelnomod
kernelnomod:
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- uImage -j4

kerneltags: $(KERNEL_OUT)
	$(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNEL_ROOTDIR) O=$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- menuconfig

savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNEL_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- savedefconfig
	cp $(KERNEL_OUT)/defconfig $(KERNEL_ROOTDIR)/customer/configs/$(KERNEL_DEFCONFIG)


endif
