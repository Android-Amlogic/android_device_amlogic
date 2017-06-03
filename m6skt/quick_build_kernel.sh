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
	echo "   device/amlogic/m6skt/quick_build_kernel.sh bootimage [kernel config]     --> build boot.img"
	echo "   device/amlogic/m6skt/quick_build_kernel.sh recoveryimage [kernel config]  --> recovery.img"
	echo "   device/amlogic/m6skt/quick_build_kernel.sh menuconfig                    --> open kernel menuconfig"
	echo "   device/amlogic/m6skt/quick_build_kernel.sh saveconfig                    --> make defconfig &  make savedefconfig"
}

if [ $# -lt 1 ]; then
    echo "Error: wrong number of arguments in cmd: $0 $* "
    usage
    exit 1
fi



#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
KERNEL_DEFCONFIG=meson6_skt_defconfig
KERNET_ROOTDIR=common
PROJECT_NAME=m6skt
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

KERNEL_OUT=out/target/product/$PROJECT_NAME/obj/KERNEL_OBJ
KERNEL_CONFIG=$KERNEL_OUT/.config
PRODUCT_OUT=out/target/product/$PROJECT_NAME
NEW_KERNEL_CONFIG=


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

if [ ! -f $PRODUCT_OUT/root/init ]; then
	echo "No $PRODUCT_OUT/root/init found! You need build it first"
	echo "make bootimage at android top dir"
	exit 1
fi

if [ -n $NEW_KERNEL_CONFIG ]; then
	make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $NEW_KERNEL_CONFIG
else
	if [ -f $KERNEL_CONFIG ]; then
		make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $KERNEL_DEFCONFIG
	fi		
fi


make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- uImage
make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- modules

mkdir -p $PRODUCT_OUT/root/boot

if [ -f $KERNET_ROOTDIR/drivers/amlogic/ump/Kbuild ]; then
	cp $KERNEL_OUT/drivers/amlogic/ump/ump.ko $PRODUCT_OUT/root/boot/
	cp $KERNEL_OUT/drivers/amlogic/mali/mali.ko $PRODUCT_OUT/root/boot/
else
	cp out/target/product/$PROJECT_NAME/obj/hardware/arm/gpu/ump/ump.ko $PRODUCT_OUT/root/boot/
	cp out/target/product/$PROJECT_NAME/obj/hardware/arm/gpu/mali/mali.ko $PRODUCT_OUT/root/boot/
fi

#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
cp $KERNEL_OUT/drivers/amlogic/load_deferred_module/deferreddrv.ko $PRODUCT_OUT/root/boot/
cp $KERNEL_OUT/drivers/amlogic/wifi/broadcm_40181/dhd.ko $PRODUCT_OUT/system/lib/

#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

cd $PRODUCT_OUT/root
find .| cpio -o -H newc | gzip -9 > ../ramdisk.img
cd -
out/host/linux-x86/bin/mkbootimg  --kernel $KERNEL_OUT/arch/arm/boot/uImage  --ramdisk $PRODUCT_OUT/ramdisk.img --output $PRODUCT_OUT/boot.img

echo "Build $PRODUCT_OUT/boot.img Done"
exit 0
fi

############################## patch ####################################
if [ $1 = patch ]; then
    cd $PRODUCT_OUT
    mkdir -p inputdir/BOOT
    cp boot.img inputdir/BOOT/kernel
    #mpatch inputdir patch.zip
    ../../../../build/tools/releasetools/aml_update_packer inputdir patch.zip
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

if [ -n $NEW_KERNEL_CONFIG ]; then
	make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $NEW_KERNEL_CONFIG
else
	if [ -f $KERNEL_CONFIG ]; then
		make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $KERNEL_DEFCONFIG
	fi		
fi

make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- uImage
make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- modules
mkdir -p $PRODUCT_OUT/recovery/root/boot

#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
cp $KERNEL_OUT/drivers/amlogic/load_deferred_module/deferreddrv.ko $PRODUCT_OUT/recovery/root/boot/
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}


cd $PRODUCT_OUT/recovery/root
find .| cpio -o -H newc | gzip -9 > ../../ramdisk-recovery.img
cd -
out/host/linux-x86/bin/mkbootimg  --kernel $KERNEL_OUT/arch/arm/boot/uImage  --ramdisk $PRODUCT_OUT/ramdisk-recovery.img --output $PRODUCT_OUT/recovery.img

echo "Build $PRODUCT_OUT/recovery.img Done"
exit 0
fi

############################## menuconfig ####################################
if [ $1 = menuconfig ]; then
	if [ -f $KERNEL_CONFIG ]; then
		make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $KERNEL_DEFCONFIG
	fi
	make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- menuconfig

	exit 0
fi

############################## saveconfig ####################################
if [ $1 = saveconfig -o $1 = savedefconfig ]; then
	if [ ! -f $KERNEL_CONFIG ]; then
		echo " $KERNEL_CONFIG is not found"
		make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $KERNEL_DEFCONFIG
	fi
	make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- savedefconfig

	echo "config saved to $KERNEL_OUT/defconfig"
	exit 0
fi

echo "Error: unrecognized  argument"
usage
