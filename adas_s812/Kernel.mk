#ifneq ($(TARGET_AMLOGIC_KERNEL),)

#KERNEL_DEVICETREE := meson8_adas_2G
KERNEL_DEVICETREE := meson8_adas
ifeq ($(TARGET_USE_SECUREOS),true)
KERNEL_DEFCONFIG := meson8_adas_tee_defconfig
else
KERNEL_DEFCONFIG := meson8_adas_defconfig
endif

KERNET_ROOTDIR :=  common
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
TARGET_PREBUILT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
BOARD_MKBOOTIMG_ARGS := --second $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb
INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img
BOARD_MKBOOTIMG_ARGS := --second $(INSTALLED_DTIMAGE_TARGET)
TARGET_AMLOGIC_INT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage
TARGET_AMLOGIC_INT_RECOVERY_KERNEL := $(KERNEL_OUT)/arch/arm/boot/uImage_recovery
DTBTOOL := device/amlogic/common/dtbTool
WORD_NUMBER := $(words $(KERNEL_DEVICETREE))
define build-dtimage-target
    #$(call pretty,"Target dt image: $(INSTALLED_DTIMAGE_TARGET)")
    @echo " Target dt image: $(INSTALLED_DTIMAGE_TARGET)"
    $(hide) $(DTBTOOL) -o $(INSTALLED_DTIMAGE_TARGET) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/
    $(hide) chmod a+r $@
endef
ifeq ($(WORD_NUMBER),1)
BOARD_MKBOOTIMG_ARGS := --second $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb
define cp-dtbs
    @echo " only one dtb"
    cp $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb $(PRODUCT_OUT)/meson.dtb
    cp $(KERNET_ROOTDIR)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtd $(PRODUCT_OUT)/meson_target.dtd
endef
else
define cp-dtbs
@echo " multi dtbs"
$(foreach dtd_file,$(KERNEL_DEVICETREE), \
    cp $(KERNET_ROOTDIR)/arch/arm/boot/dts/amlogic/$(dtd_file).dtd $(PRODUCT_OUT)/; \
    )
$(build-dtimage-target)
endef
define update-aml_upgrade-conf
@echo " update-aml_upgrade_conf for multi-dtd"
@sed -i "/meson.*\.dtd/d" $(PACKAGE_CONFIG_FILE)
@sed -i "s/meson.*\.dtb/dt.img/" $(PACKAGE_CONFIG_FILE)
$(hide) $(foreach dtd_file,$(KERNEL_DEVICETREE), \
	sed -i "0,/aml_sdc_burn\.ini/ s/file=\"aml_sdc_burn\.ini\".*/&\n&/" $(PACKAGE_CONFIG_FILE); \
	sed -i "0,/aml_sdc_burn\.ini/ s/ini\"/dtd\"/g" $(PACKAGE_CONFIG_FILE); \
	sed -i "0,/aml_sdc_burn\.dtd/ s/aml_sdc_burn/$(dtd_file)/g" $(PACKAGE_CONFIG_FILE); \
	)
endef 
endif
ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL),true)
SYSTEMIMG_INTERMEDIATES := obj\/PACKAGING\/systemimage_intermediates
define security_dm_verity_conf
@echo " copy dm-verity file: table.bin system.img.raw.hash"
$(hide) \
	sed -i "/aml_sdc_burn\.ini/ s/.*/&\nfile=\"$(SYSTEMIMG_INTERMEDIATES)\/table.bin\"\t\tmain_type=\"bin\"\t\tsub_type=\"table\"/" $(PACKAGE_CONFIG_FILE); \
	sed -i "/aml_sdc_burn\.ini/ s/.*/&\nfile=\"$(SYSTEMIMG_INTERMEDIATES)\/system.img.raw.hash\"\t\tmain_type=\"hash\"\t\tsub_type=\"system.img.raw\"/" $(PACKAGE_CONFIG_FILE);
endef
endif
MALI_OUT := $(TARGET_OUT_INTERMEDIATES)/hardware/arm/gpu/mali
UMP_OUT  := $(TARGET_OUT_INTERMEDIATES)/hardware/arm/gpu/ump
WIFI_OUT  := $(TARGET_OUT_INTERMEDIATES)/hardware/wifi

PREFIX_CROSS_COMPILE=arm-linux-gnueabihf-
#arm-none-linux-gnueabi-

define cp-modules
mkdir -p $(PRODUCT_OUT)/root/boot
mkdir -p $(TARGET_OUT)/lib

#cp $(UMP_OUT)/ump.ko $(PRODUCT_OUT)/root/boot/
cp $(MALI_OUT)/mali.ko $(PRODUCT_OUT)/root/boot/


cp $(WIFI_OUT)/broadcom/drivers/ap6xxx/bcmdhd_1_141_xx/dhd.ko $(TARGET_OUT)/lib/

#cp $(KERNET_ROOTDIR)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtd $(PRODUCT_OUT)/meson_target.dtd
cp $(KERNEL_OUT)/arch/arm/boot/meson.dtd $(PRODUCT_OUT)/meson.dtd
#cp $(KERNEL_OUT)/arch/arm/boot/dts/amlogic/$(KERNEL_DEVICETREE).dtb $(PRODUCT_OUT)/meson.dtb
$(cp-dtbs)
cp $(KERNEL_OUT)/../hardware/amlogic/pmu/aml_pmu_dev.ko $(TARGET_OUT)/lib/
$(THERMAL_KO):
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/amlogic/thermal/ ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
cp $(shell pwd)/hardware/amlogic/thermal/aml_thermal.ko $(TARGET_OUT)/lib/
cp $(KERNEL_OUT)/../hardware/amlogic/nand/amlnf/aml_nftl_dev.ko $(PRODUCT_OUT)/root/boot/ 
endef

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEFCONFIG)


$(TARGET_PREBUILT_KERNEL): $(KERNEL_OUT) $(KERNEL_CONFIG)
	@echo " make uImage" 
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) uImage
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) modules
ifeq ($(WORD_NUMBER),1)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEVICETREE).dtd
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(KERNEL_DEVICETREE).dtb
else
	$(foreach dtd_file,$(KERNEL_DEVICETREE), \
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(dtd_file).dtd; \
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) $(dtd_file).dtb; \
        )
endif
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) dtd
	$(cp-modules)

kerneltags: $(KERNEL_OUT)
	$(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) menuconfig

savekernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(KERNET_ROOTDIR) O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=$(PREFIX_CROSS_COMPILE) savedefconfig
	cp $(KERNEL_OUT)/defconfig $(KERNET_ROOTDIR)/customer/configs/$(KERNEL_DEFCONFIG)


#endif
