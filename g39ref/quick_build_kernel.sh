#!/bin/bash

#  This script use to build boot.img or recovery.img.
#  Compare with 'make bootimage' or 'make recoveryimage'at android top directory , it will not check android makefile, save time to enter build process
#
#  Read me for copy it your project, Configuration between {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{ 
#  and }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}} may need modify.
# 
#  This scipt is created by Frank.Chen, any problem with this, let me know

#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
KERNEL_DEFCONFIG=meson6_g39_jb_defconfig
KERNEL_USB_BURNING_DEFCONFIG=meson6_g39_jb_usb_burn_defconfig
KERNET_ROOTDIR=common
PROJECT_NAME=g39ref
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

KERNEL_OUT=out/target/product/$PROJECT_NAME/obj/KERNEL_OBJ
KERNEL_CONFIG=$KERNEL_OUT/.config
PRODUCT_OUT=out/target/product/$PROJECT_NAME
NEW_KERNEL_CONFIG=
DEVICE_DIR=device/amlogic/g39ref

DATE=`date +%F`

TASK_NUM=16


function usage () {
	echo "Usage:"
	echo "   Pelease run the script in android top directory"
	echo "   device/amlogic/g39ref/quick_build_kernel.sh bootimage [kernel config]     --> build boot.img"
	echo "   device/amlogic/g39ref/quick_build_kernel.sh recoveryimage [kernel config]  --> recovery.img"
	echo "   device/amlogic/g39ref/quick_build_kernel.sh usbburnimage                  --> uImage_usb_burning"
	echo "   device/amlogic/g39ref/quick_build_kernel.sh menuconfig                    --> open kernel menuconfig"
	echo "   device/amlogic/g39ref/quick_build_kernel.sh saveconfig                    --> make defconfig &  make savedefconfig"
	echo "   device/amlogic/g39ref/quilk_build_kernel.sh usbburnzip                 --> build usbburnzip.zip"
}

if [ $# -lt 1 ]; then
    echo "Error: wrong number of arguments in cmd: $0 $* "
    usage
    exit 1
fi




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

make -C $KERNET_ROOTDIR O=../$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- uImage -j$TASK_NUM
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

############################## usbburnzip ####################################
if [ $1 = usbburnzip ]; then

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

USB_BURNING_KERNEL_OUT=out/target/product/$PROJECT_NAME/obj/USB_BURNING_KERNEL_OBJ
USB_BURNING_KERNEL_CONFIG=$USB_BURNING_KERNEL_OUT/.config

if [ ! -f $USB_BURNING_KERNEL_CONFIG ]; then
    mkdir -p $USB_BURNING_KERNEL_OUT
    make -C $KERNET_ROOTDIR O=../$USB_BURNING_KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $KERNEL_USB_BURNING_DEFCONFIG
fi

make -C $KERNET_ROOTDIR O=../$USB_BURNING_KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- uImage -j$TASK_NUM

if [ -f drivers/amlogic/load_deferred_module/Makefile ]; then
    make -C $KERNET_ROOTDIR O=../$USB_BURNING_KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- SUBDIRS=drivers/amlogic/load_deferred_module modules 
    mkdir -p $PRODUCT_OUT/recovery/root/boot/

    #{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
    cp $USB_BURNING_KERNEL_OUT/drivers/amlogic/load_deferred_module/deferreddrv.ko $PRODUCT_OUT/recovery/root/boot/
    #}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
fi


cd $PRODUCT_OUT/recovery/root
find .| cpio -o -H newc | gzip -9 > ../../ramdisk.img
cd -
out/host/linux-x86/bin/mkbootimg  --kernel $USB_BURNING_KERNEL_OUT/arch/arm/boot/uImage  --ramdisk $PRODUCT_OUT/ramdisk-recovery.img --output $PRODUCT_OUT/usb_burning.img

mkdir $PRODUCT_OUT/g39ref_usb_burn
echo "copy usb burning file......."
echo "copy config_progress.xml....."
cp -f $DEVICE_DIR/config_progress.xml $PRODUCT_OUT/g39ref_usb_burn
echo "copy u-boot-orig.bin....."
cp -f $DEVICE_DIR/u-boot-orig.bin $PRODUCT_OUT/g39ref_usb_burn
echo "copy usb_spl.bin....."
cp -f $DEVICE_DIR/usb_spl.bin $PRODUCT_OUT/g39ref_usb_burn
echo "copy update.zip......"
cp -f $PRODUCT_OUT/g39ref-ota* $PRODUCT_OUT/g39ref_usb_burn/update.zip
echo "copy usb_burning.img...."
mv -f $PRODUCT_OUT/usb_burning.img $PRODUCT_OUT/g39ref_usb_burn
echo "copy u-boot-orig-usid.bin....."
cp -f $DEVICE_DIR/u-boot-orig-usid.bin $PRODUCT_OUT/g39ref_usb_burn

if [ ! -f $PRODUCT_OUT/g39ref_usb_burn/config_progress.xml ]; then
	echo "###ERROR!! No $PRODUCT_OUT/g39ref_usb_burn/config_progress.xml found! check the file in you device first "
exit 1
fi
if [ ! -f $PRODUCT_OUT/g39ref_usb_burn/u-boot-orig-usid.bin ]; then
	echo "###ERROR!! No $PRODUCT_OUT/g39ref_usb_burn/u-boot-orig-usid.bin found! check the file in you device first "
exit 1
fi
if [ ! -f $PRODUCT_OUT/g39ref_usb_burn/u-boot-orig.bin ]; then
	echo "###ERROR!! No $PRODUCT_OUT/g39ref_usb_burn/u-boot-orig.bin found! check the file in you device first"
exit 1
fi
if [ ! -f $PRODUCT_OUT/g39ref_usb_burn/usb_spl.bin ]; then
	echo "###ERROR!! No $PRODUCT_OUT/g39ref_usb_burn/usb_spl.bin found! check the file in you device first"
exit 1
fi
if [ ! -f $PRODUCT_OUT/g39ref_usb_burn/usb_burning.img ]; then
	echo "###ERROR!! No $PRODUCT_OUT/g39ref_usb_burn/usb_burning.img found! maybe Cause by compiled usb_burning.img fail please check config"
exit 1
fi
if [ ! -f $PRODUCT_OUT/g39ref_usb_burn/update.zip ]; then
	echo "###ERROR!! No $PRODUCT_OUT/g39ref_usb_burn/update.zip found! please do "make otapackage -j24 first ""
exit 1
fi
if [ -f $PRODUCT_OUT/$DATE-G39-shuttle-nand7-usb-burn.zip ]; then
echo "###we will rm the before one ... "
rm -f $PRODUCT_OUT/$DATE-G39-shuttle-nand7-usb-burn.zip
fi
cd $PRODUCT_OUT

echo "creating zip ......"
zip -r $DATE-G39-shuttle-nand7-usb-burn.zip g39ref_usb_burn/
rm -rf g39ref_usb_burn/

echo "Build $PRODUCT_OUT/$DATE-G39-shuttle-nand7-usb-burn.zip Done"
exit 0
fi



echo "Error: unrecognized  argument"
usage
