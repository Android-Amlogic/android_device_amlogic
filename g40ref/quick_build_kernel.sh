#!/bin/bash

#  This script use to build boot.img or recovery.img.
#  Compare with 'make bootimage' or 'make recoveryimage'at android top directory , it will not check android makefile, save time to enter build process
#
#  Read me for copy it your project, Configuration between {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{ 
#  and }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}} may need modify.
# 
#  This scipt is created by Frank.Chen, any problem with this, let me know

function usage () {
	echo "Usage:"
	echo "   Pelease run the script in android top directory"
	echo "   device/amlogic/g40ref/quick_build_kernel.sh bootimage [kernel config]     --> build uImage"
	echo "   device/amlogic/g40ref/quick_build_kernel.sh recoveryimage [kernel config]  --> build recovery uImage"
	echo "   device/amlogic/g40ref/quick_build_kernel.sh usbburnimage                  --> uImage_usb_burning"
	echo "   device/amlogic/g40ref/quick_build_kernel.sh menuconfig                    --> open kernel menuconfig"
	echo "   device/amlogic/g40ref/quick_build_kernel.sh saveconfig                    --> savedefconfig"
}

if [ $# -lt 1 ]; then
    echo "Error: wrong number of arguments in cmd: $0 $* "
    usage
    exit 1
fi



#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
KERNEL_DEFCONFIG=meson6_g40_defconfig
KERNEL_USBBURN_CONFIG=meson6_g40_usb_burning_defconfig
KERNET_ROOTDIR=common
PROJECT_NAME=g40ref
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

KERNEL_OUT=out/target/product/$PROJECT_NAME/obj/KERNEL_OBJ
KERNEL_CONFIG=$KERNEL_OUT/.config
PRODUCT_OUT=out/target/product/$PROJECT_NAME
NEW_KERNEL_CONFIG=
HAS_CONFIF_ARG=0
PREFIX_CROSS_COMPILE=arm-eabi-
#arm-none-linux-gnueabi-


############################## bootimage ####################################
if [ $1 = bootimage ]; then

if [ $# -eq 2 ]; then
	if [ ! -f common/arch/arm/config/$2 ]; then
		if [ ! -f common/customer/configs/$2 ]; then
			echo "No $2 found!"
			exit 1
		fi
	fi
	NEW_KERNEL_CONFIG=$2
	HAS_CONFIF_ARG=1
fi
	
if [ ! -f out/host/linux-x86/bin/mkbootimg ]; then
	echo "No out/host/linux-x86/bin/mkbootimg found! You need build it first"
	echo "make bootimage at android top dir"
	exit 1
fi

if [ ! -d $PRODUCT_OUT/root ]; then
	echo "No $PRODUCT_OUT/root found! You need build it first"
	echo "make bootimage at android top dir"
	exit 1
fi

if [ ! -d $KERNEL_OUT ]; then
	echo "$KERNEL_OUT no found! Build it..."
	mkdir $KERNEL_OUT
fi

if [ ! -f $PRODUCT_OUT/root/init ]; then
	echo "No $PRODUCT_OUT/root/init found! You need build it first"
	echo "make bootimage at android top dir"
	exit 1
fi

if [ $HAS_CONFIF_ARG -eq 1 ]; then
	make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE $NEW_KERNEL_CONFIG -j4
else
	if [ ! -f $KERNEL_CONFIG ]; then
		make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE $KERNEL_DEFCONFIG -j4
	fi		
fi

make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE modules

mkdir -p $PRODUCT_OUT/root/boot
if [ -f $KERNET_ROOTDIR/drivers/amlogic/ump/Kbuild ]; then
	cp $KERNEL_OUT/drivers/amlogic/ump/ump.ko $PRODUCT_OUT/root/boot/
	cp $KERNEL_OUT/drivers/amlogic/mali/mali.ko $PRODUCT_OUT/root/boot/
else
	cp out/target/product/$PROJECT_NAME/obj/hardware/arm/gpu/ump/ump.ko $PRODUCT_OUT/root/boot/
	cp out/target/product/$PROJECT_NAME/obj/hardware/arm/gpu/mali/mali.ko $PRODUCT_OUT/root/boot/
fi

#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
#cp $KERNEL_OUT/drivers/amlogic/wifi/rtl8xxx_EU/8188eu.ko $PRODUCT_OUT/system/lib/
cp $KERNEL_OUT/drivers/amlogic/wifi/broadcm_40181/dhd.ko $PRODUCT_OUT/system/lib/
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE uImage -j8

cd $PRODUCT_OUT/root
find .| cpio -o -H newc | gzip -9 > ../ramdisk.img
cd -
out/host/linux-x86/bin/mkbootimg  --kernel $KERNEL_OUT/arch/arm/boot/uImage  --ramdisk $PRODUCT_OUT/ramdisk.img --output $PRODUCT_OUT/boot.img

echo "Build $PRODUCT_OUT/boot.img Done"
exit 0
fi

############################## recoveryimage ####################################
if [ $1 = recoveryimage ]; then

if [ $# -eq 2 ]; then
	if [ ! -f common/arch/arm/config/$2 ]; then
		if [ ! -f common/customer/configs/$2 ]; then
			echo "No $2 found!"
			exit 1
		fi
	fi
	NEW_KERNEL_CONFIG=$2
	HAS_CONFIF_ARG=1
fi

if [ ! -f out/host/linux-x86/bin/mkbootimg ]; then
	echo "No out/host/linux-x86/bin/mkbootimg found! You need build it first"
	echo "make recoveryimage at android top dir"
exit 1
fi
 
if [ ! -d $PRODUCT_OUT/recovery/root ]; then
	echo "No $PRODUCT_OUT/recovery/root found! You need build it first"
	echo "make recoveryimage at android top dir"
exit 1
fi

if [ ! -d $KERNEL_OUT ]; then
	echo "$KERNEL_OUT no found! Build it..."
	mkdir $KERNEL_OUT
fi

if [ $HAS_CONFIF_ARG -eq 1 ]; then
	make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE $NEW_KERNEL_CONFIG -j4
else
	if [ ! -f $KERNEL_CONFIG ]; then
		make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE $KERNEL_DEFCONFIG -j4
	fi		
fi

make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE BUILD_URECOVERY=true uImage -j8
make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE modules
mkdir -p $PRODUCT_OUT/recovery/root/boot


cd $PRODUCT_OUT/recovery/root
find .| cpio -o -H newc | gzip -9 > ../../ramdisk-recovery.img
cd -
out/host/linux-x86/bin/mkbootimg  --kernel $KERNEL_OUT/arch/arm/boot/uImage  --ramdisk $PRODUCT_OUT/ramdisk-recovery.img --output $PRODUCT_OUT/recovery.img

echo "Build $PRODUCT_OUT/recovery.img Done"
exit 0
fi

############################## usbbrunimage ####################################
if [ $1 = usbburnimage ]; then
echo "Build $PRODUCT_OUT/uImage_usb_burning Start"
if [ $# -eq 2 ]; then
	if [ ! -f common/arch/arm/config/$2 ]; then
		if [ ! -f common/customer/configs/$2 ]; then
			echo "No $2 found!"
			exit 1
		fi
	fi
	NEW_KERNEL_CONFIG=$2
	HAS_CONFIF_ARG=1
fi

if [ ! -d $PRODUCT_OUT/recovery/root ]; then
	echo "No $PRODUCT_OUT/recovery/root found! You need build it first"
	echo "make recoveryimage at android top dir"
exit 1
fi

if [ ! -d $KERNEL_OUT ]; then
	echo "$KERNEL_OUT no found! Build it..."
	mkdir $KERNEL_OUT
fi

echo "config: $KERNEL_USBBURN_CONFIG"
make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE $KERNEL_USBBURN_CONFIG

make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE uImage
make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE modules
mkdir -p $PRODUCT_OUT/recovery/root/boot

cp $KERNEL_OUT/arch/arm/boot/uImage $PRODUCT_OUT/uImage_usb_burning

echo "Build $PRODUCT_OUT/uImage_usb_burning Done"
exit 0
fi

############################## menuconfig ####################################
if [ $1 = menuconfig ]; then
	if [ ! -f $KERNEL_CONFIG ]; then
		make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE $KERNEL_DEFCONFIG
	fi
	make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE menuconfig

	exit 0
fi

############################## saveconfig ####################################
if [ $1 = saveconfig -o $1 = savedefconfig ]; then
	if [ ! -f $KERNEL_CONFIG ]; then
		echo " $KERNEL_CONFIG is not found"
		make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE $KERNEL_DEFCONFIG
	fi
	make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE savedefconfig

	echo "config saved to $KERNEL_OUT/defconfig"
	exit 0
fi

echo "Error: unrecognized  argument"
usage
