#Android makefile to build kernel as a part of Android Build

#ifeq (0,1)

KERNEL_DEFCONFIG := meson6_defconfig
KERNET_ROOTDIR :=  common
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
TARGET_PREBUILT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
BOARD_MKBOOTIMG_ARGS := --second $(KERNEL_OUT)/arch/arm/boot/dts/meson6s_skt.dtb

define cp-kernel-modules
mkdir -p $(PRODUCT_OUT)/root/boot
mkdir -p $(TARGET_OUT)/lib
if [ -f $(KERNET_ROOTDIR)/drivers/amlogic/ump/Kbuild ]; then \
	cp $(KERNEL_OUT)/drivers/amlogic/ump/ump.ko $(PRODUCT_OUT)/root/boot/ ;\
	cp $(KERNEL_OUT)/drivers/amlogic/mali/mali.ko $(PRODUCT_OUT)/root/boot/ ;\
else \
	cp $(TARGET_OUT_INTERMEDIATES)/hardware/arm/gpu/ump/ump.ko $(PRODUCT_OUT)/root/boot/ ;\
	cp $(TARGET_OUT_INTERMEDIATES)/hardware/arm/gpu/mali/mali.ko $(PRODUCT_OUT)/root/boot/ ;\
fi
cp $(KERNEL_OUT)/drivers/amlogic/wifi/broadcm_40181/dhd.ko $(TARGET_OUT)/lib/
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- $(KERNEL_DEFCONFIG)


$(TARGET_PREBUILT_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG)
	@echo " make uImage" 
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- meson6s_skt.dtb
	$(cp-kernel-modules)

kerneltags: $(KERNEL_OUT)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
	     
savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- savedefconfig
	cp $(KERNEL_OUT)/defconfig $(KERNET_ROOTDIR)/customer/configs/$(KERNEL_DEFCONFIG)

#endif
