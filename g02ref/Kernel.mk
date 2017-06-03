#ifneq ($(TARGET_AMLOGIC_KERNEL),)

KERNEL_DEFCONFIG := meson6_g02_jb42_defconfig
KERNET_ROOTDIR :=  common
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
TARGET_PREBUILT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
TARGET_AMLOGIC_INT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
TARGET_AMLOGIC_INT_RECOVERY_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage_recovery
MALI_OUT := $(TARGET_OUT_INTERMEDIATES)/hardware/arm/gpu/mali
UMP_OUT  := $(TARGET_OUT_INTERMEDIATES)/hardware/arm/gpu/ump

define cp-modules

cp $(UMP_OUT)/ump.ko $(PRODUCT_OUT)/root/boot/
cp $(MALI_OUT)/mali.ko $(PRODUCT_OUT)/root/boot/
cp $(KERNEL_OUT)/drivers/amlogic/wifi/rtl8xxx_CU/8192cu.ko $(TARGET_OUT)/lib/
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- $(KERNEL_DEFCONFIG)


$(TARGET_AMLOGIC_INT_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG) $(BUILT_RAMDISK_TARGET) $(INSTALLED_AMLOGIC_RECOVERY_TARGET) $(ACP)
	$(if $(wildcard arch/$(SRCARCH)/boot/uImage), @mv $(KERNEL_OUT)/arch/arm/boot/uImage $(KERNEL_OUT)/arch/arm/boot/__uImage)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- BUILD_URECOVERY=true uImage
	@mv $(KERNEL_OUT)/arch/arm/boot/uImage $(KERNEL_OUT)/arch/arm/boot/uImage_recovery
	@echo " Image arch/$(SRCARCH)/boot/uImage_recovery is ready"
	$(if $(wildcard $(KERNEL_OUT)/arch/arm/boot/__uImage), @mv $(KERNEL_OUT)/arch/arm/boot/__uImage $(KERNEL_OUT)/arch/arm/boot/uImage)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- modules
	$(cp-modules)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- uImage

kerneltags: $(KERNEL_OUT)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- menuconfig

savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- savedefconfig
	cp $(KERNEL_OUT)/defconfig $(KERNET_ROOTDIR)/customer/configs/$(KERNEL_DEFCONFIG)


#endif
