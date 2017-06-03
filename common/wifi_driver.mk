KERNEL_ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-
PRODUCT_OUT=out/target/product/$(TARGET_PRODUCT)
TARGET_OUT=$(PRODUCT_OUT)/system

define bcmwifi-modules
	@echo "make wifi module KERNEL_ARCH is $(KERNEL_ARCH)"
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd_1_201_59_x ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd_1_201_59_x/dhd.ko $(TARGET_OUT)/lib/
endef

AP6181:
	@echo "wifi module is AP6181"
	$(bcmwifi-modules)
AP6210:
	@echo "wifi module is AP6210"
	$(bcmwifi-modules)
AP6330:
	@echo "wifi module is AP6330"
	$(bcmwifi-modules)
AP6234:
	@echo "wifi module is AP6234"
	$(bcmwifi-modules)
AP6441:
	@echo "wifi module is AP6441"
	$(bcmwifi-modules)
AP6335:
	@echo "wifi module is AP6335"
	$(bcmwifi-modules)
AP6212:
	@echo "wifi module is AP6212"
	$(bcmwifi-modules)
AP62x2:
	@echo "wifi module is AP62x2"
	$(bcmwifi-modules)
bcm43341:
	@echo "wifi module is bcm43341"
	$(bcmwifi-modules)
bcm43241:
	@echo "wifi module is bcm43241"
	$(bcmwifi-modules)
bcm40181:
	@echo "wifi module is bcm40181"
	$(bcmwifi-modules)
bcm40183:
	@echo "wifi module is bcm40183"
	$(bcmwifi-modules)
bcm4354:
	@echo "wifi module is bcm4354"
	$(bcmwifi-modules)
bcm4356:
	@echo "wifi module is bcm4356"
	$(bcmwifi-modules)
bcm43458:
	@echo "wifi module is bcm43458"
	$(bcmwifi-modules)

rtl8189es:
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8189es/rtl8189ES ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8189es/rtl8189ES/8189es.ko $(TARGET_OUT)/lib/

rtl8189ftv:
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8189ftv/rtl8189FS ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8189ftv/rtl8189FS/8189ftv.ko $(TARGET_OUT)/lib/

rtl8192eu:
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8192eu/rtl8192EU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8192eu/rtl8192EU/8192eu.ko $(TARGET_OUT)/lib/

rtl8723bs:
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8723bs/rtl8723BS ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8723bs/rtl8723BS/8723bs.ko $(TARGET_OUT)/lib/

rtl8188eu:
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8188eu/rtl8xxx_EU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8188eu/rtl8xxx_EU/8188eu.ko $(TARGET_OUT)/lib/

rtl8812au:
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8812au/rtl8812AU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8812au/rtl8812AU/8812au.ko $(TARGET_OUT)/lib/

multiwifi:
	@echo "make wifi module KERNEL_ARCH is $(KERNEL_ARCH)"
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8189es/rtl8189ES ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8189es/rtl8189ES/8189es.ko $(TARGET_OUT)/lib/
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8192eu/rtl8192EU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8192eu/rtl8192EU/8192eu.ko $(TARGET_OUT)/lib/
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8723bs/rtl8723BS ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8723bs/rtl8723BS/8723bs.ko $(TARGET_OUT)/lib/
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8188eu/rtl8xxx_EU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8188eu/rtl8xxx_EU/8188eu.ko $(TARGET_OUT)/lib/
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/realtek/drivers/8812au/rtl8812AU ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/realtek/drivers/8812au/rtl8812AU/8812au.ko $(TARGET_OUT)/lib/
	$(MAKE) -C $(shell pwd)/$(PRODUCT_OUT)/obj/KERNEL_OBJ M=$(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd_1_201_59_x ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	cp $(shell pwd)/hardware/wifi/broadcom/drivers/ap6xxx/bcmdhd_1_201_59_x/dhd.ko $(TARGET_OUT)/lib/
