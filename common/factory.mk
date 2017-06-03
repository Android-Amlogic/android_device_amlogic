IMGPACK := $(BUILD_OUT_EXECUTABLES)/logo_img_packer$(BUILD_EXECUTABLE_SUFFIX)
TARGET_PRODUCT_DIR := device/amlogic/$(TARGET_PRODUCT)
PRODUCT_UPGRADE_OUT := $(PRODUCT_OUT)/upgrade

BUILT_IMAGES := system.img userdata.img cache.img
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	BUILT_IMAGES += boot.img.encrypt recovery.img.encrypt u-boot.bin.encrypt
else
	BUILT_IMAGES += boot.img recovery.img u-boot.bin
endif#ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)

UPGRADE_FILES := \
        aml_sdc_burn.ini \
        ddr_init.bin \
	u-boot.bin.sd.bin  u-boot.bin.usb.bl2 u-boot.bin.usb.tpl \
        u-boot-comp.bin

ifneq ($(TARGET_USE_SECURITY_MODE),true)
UPGRADE_FILES += \
        platform.conf \
        aml_upgrade_package.conf
else # secureboot mode
UPGRADE_FILES += \
        u-boot-usb.bin.aml \
        platform_enc.conf \
        aml_upgrade_package_enc.conf
endif

UPGRADE_FILES := $(addprefix $(TARGET_DEVICE_DIR)/upgrade/,$(UPGRADE_FILES))
UPGRADE_FILES := $(wildcard $(UPGRADE_FILES)) #extract only existing files for burnning

ifneq ($(TARGET_AMLOGIC_RES_PACKAGE),)
INSTALLED_AML_LOGO := $(PRODUCT_UPGRADE_OUT)/logo.img
$(INSTALLED_AML_LOGO): $(IMGPACK)
	@echo
	@echo "generate $(INSTALLED_AML_LOGO)"
	@echo
	mkdir -p $(PRODUCT_UPGRADE_OUT)
	$(IMGPACK) -r $(TARGET_AMLOGIC_RES_PACKAGE) $(INSTALLED_AML_LOGO)
else
INSTALLED_AML_LOGO :=
endif

.PHONY: logoimg
logoimg: $(INSTALLED_AML_LOGO)

ifneq ($(BOARD_AUTO_COLLECT_MANIFEST),false)
BUILD_TIME := $(shell date +%Y-%m-%d--%H-%M)
INSTALLED_MANIFEST_XML := $(PRODUCT_OUT)/manifests/manifest-$(BUILD_TIME).xml
$(INSTALLED_MANIFEST_XML):
	$(hide) mkdir -p $(PRODUCT_OUT)/manifests
	$(hide) mkdir -p $(PRODUCT_OUT)/upgrade
	repo manifest -r -o $(INSTALLED_MANIFEST_XML)
	$(hide) cp $(INSTALLED_MANIFEST_XML) $(PRODUCT_OUT)/upgrade/manifest.xml

.PHONY:build_manifest
build_manifest:$(INSTALLED_MANIFEST_XML)
else
INSTALLED_MANIFEST_XML :=
endif

ifeq ($(TARGET_SUPPORT_USB_BURNING_V2),true)
INSTALLED_AML_UPGRADE_PACKAGE_TARGET := $(PRODUCT_OUT)/aml_upgrade_package.img

ifeq ($(TARGET_USE_SECURITY_MODE),true)
  PACKAGE_CONFIG_FILE := $(PRODUCT_UPGRADE_OUT)/aml_upgrade_package_enc.conf
else
  PACKAGE_CONFIG_FILE := $(PRODUCT_UPGRADE_OUT)/aml_upgrade_package.conf
endif

define update-aml_upgrade-conf
	@echo "update-aml_upgrade_conf for multi-dtd";
	@sed -i "/meson.*\.dtd/d" $(PACKAGE_CONFIG_FILE);
	@sed -i "s/meson.*\.dtb/dt.img/" $(PACKAGE_CONFIG_FILE);
	$(hide) $(foreach dtd_file,$(KERNEL_DEVICETREE), \
		sed -i "0,/aml_sdc_burn\.ini/ s/file=\"aml_sdc_burn\.ini\".*/&\n&/" $(PACKAGE_CONFIG_FILE); \
		sed -i "0,/aml_sdc_burn\.ini/ s/ini\"/dtd\"/g" $(PACKAGE_CONFIG_FILE); \
		sed -i "0,/aml_sdc_burn\.dtd/ s/aml_sdc_burn/$(dtd_file)/g" $(PACKAGE_CONFIG_FILE); \
	)
endef

ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL),true)
  SYSTEMIMG_INTERMEDIATES := $(PRODUCT_OUT)/obj/PACKAGING/systemimage_intermediates
  SYSTEMIMG_INTERMEDIATES := $(SYSTEMIMG_INTERMEDIATES)/verity_table.bin $(SYSTEMIMG_INTERMEDIATES)/verity.img
  define security_dm_verity_conf
	  @echo "copy verity.img and verity_table.bin"
	  @sed -i "/verity_table.bin/d" $(PACKAGE_CONFIG_FILE)
	  @sed -i "/verity.img/d" $(PACKAGE_CONFIG_FILE)
	  $(hide) \
		sed -i "/aml_sdc_burn\.ini/ s/.*/&\nfile=\"verity.img\"\t\tmain_type=\"img\"\t\tsub_type=\"verity\"/" $(PACKAGE_CONFIG_FILE); \
		sed -i "/aml_sdc_burn\.ini/ s/.*/&\nfile=\"verity_table.bin\"\t\tmain_type=\"bin\"\t\tsub_type=\"verity_table\"/" $(PACKAGE_CONFIG_FILE);
	  cp $(SYSTEMIMG_INTERMEDIATES) $(PRODUCT_UPGRADE_OUT)/
  endef #define security_dm_verity_conf
endif # ifeq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL),true)


.PHONY:aml_upgrade
aml_upgrade:$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET): \
	$(addprefix $(PRODUCT_OUT)/,$(BUILT_IMAGES)) \
	$(UPGRADE_FILES) \
	$(INSTALLED_AML_LOGO) \
	$(INSTALLED_MANIFEST_XML) \
	$(TARGET_USB_BURNING_V2_DEPEND_MODULES)
	mkdir -p $(PRODUCT_UPGRADE_OUT)
ifneq ($(TARGET_USE_SECURITY_MODE),true)
	$(hide) $(foreach file,$(UPGRADE_FILES), \
			echo cp $(file) $(PRODUCT_UPGRADE_OUT)/$(notdir $(file)); \
			cp -f $(file) $(PRODUCT_UPGRADE_OUT)/$(notdir $(file)); \
		)
else # secureboot mode
	$(hide) $(foreach file,$(UPGRADE_FILES), \
		echo cp $(file) $(PRODUCT_UPGRADE_OUT)/$(notdir $(file)); \
		cp -f $(file) $(PRODUCT_UPGRADE_OUT)/$(notdir $(file)); \
		if [ "$(file)" == "ddr_init.bin" ]; then \
			echo cp $(file) $(PRODUCT_UPGRADE_OUT)/DDR_ENC.USB; \
			cp $(file) $(PRODUCT_UPGRADE_OUT)/DDR_ENC.USB; \
		fi; \
		)
	-cp $(TARGET_DEVICE_DIR)/u-boot.bin.aml $(PRODUCT_UPGRADE_OUT)
endif
	$(hide) $(foreach file,$(BUILT_IMAGES), \
		if [ -f "$(PRODUCT_OUT)/$(file)" ]; then \
			echo ln -s $(PRODUCT_OUT)/$(file) $(PRODUCT_UPGRADE_OUT)/$(file); \
			rm -f $(PRODUCT_UPGRADE_OUT)/$(file); \
			ln -s $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/$(file) $(PRODUCT_UPGRADE_OUT)/$(file); \
		fi;\
		)
ifeq ($(PRODUCT_BUILD_SECURE_BOOT_IMAGE_DIRECTLY),true)
	$(hide) rm -f $(PRODUCT_UPGRADE_OUT)/u-boot.bin.encrypt.*
	$(hide) rm -f $(PACKAGE_CONFIG_FILE)
	$(hide) $(ACP) $(PRODUCT_OUT)/u-boot.bin.encrypt.* $(PRODUCT_UPGRADE_OUT)/
	$(hide) $(ACP) $(TARGET_DEVICE_DIR)/upgrade/aml_upgrade_package_enc.conf $(PACKAGE_CONFIG_FILE)
endif#ifneq ($(TARGET_USE_SECURITY_MODE),true)
	$(update-aml_upgrade-conf)
	$(security_dm_verity_conf)
	@echo "Package: $@"
	@echo ./vendor/amlogic/tools/aml_upgrade/aml_image_v2_packer -r \
		$(PACKAGE_CONFIG_FILE) \
		$(PRODUCT_UPGRADE_OUT)/ \
		$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
	$(hide) ./vendor/amlogic/tools/aml_upgrade/aml_image_v2_packer -r \
		$(PACKAGE_CONFIG_FILE) \
		$(PRODUCT_UPGRADE_OUT)/ \
		$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
	@echo " $@ installed"
else
#none
INSTALLED_AML_UPGRADE_PACKAGE_TARGET :=
endif

droidcore: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML)
otapackage: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET) $(INSTALLED_MANIFEST_XML)

