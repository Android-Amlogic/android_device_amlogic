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
	echo "   device/amlogic/${TARGET_PRODUCT}/quick_build_kernel.sh bootimage [kernel config]     --> uImage"
	echo "   device/amlogic/${TARGET_PRODUCT}/quick_build_kernel.sh recoveryimage [kernel config] --> uImage_recovery"
	echo "   device/amlogic/${TARGET_PRODUCT}/quick_build_kernel.sh usbbrunimage                  --> uImage_usb_burning"
	echo "   device/amlogic/${TARGET_PRODUCT}/quick_build_kernel.sh bootimagenomod                --> uImage without rebuilding modules"
	echo "   device/amlogic/${TARGET_PRODUCT}/quick_build_kernel.sh menuconfig                    --> open kernel menuconfig"
	echo "   device/amlogic/${TARGET_PRODUCT}/quick_build_kernel.sh saveconfig                    --> make defconfig &  make savedefconfig"
	echo "   device/amlogic/${TARGET_PRODUCT}/quick_build_kernel.sh patch                         --> make patch.zip containing kernel only"
}

if [ $# -lt 1 ]; then
    echo "Error: wrong number of arguments in cmd: $0 $* "
    usage
    exit 1
fi

#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
KERNEL_DEFCONFIG=meson6tv_h01_defconfig
KERNEL_USBBURN_CONFIG=
KERNEL_ROOTDIR=common
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

KERNEL_OUT=$ANDROID_PRODUCT_OUT/obj/KERNEL_OBJ
KERNEL_CONFIG=$KERNEL_OUT/.config
NEW_KERNEL_CONFIG=
PRETTY_PRODUCT_OUT=${ANDROID_PRODUCT_OUT#${ANDROID_BUILD_TOP}/}

############################## bootimage ####################################
if [ $1 = bootimage ]; then
    make -f device/amlogic/${TARGET_PRODUCT}/Kernel.mk $ANDROID_PRODUCT_OUT/obj/KERNEL_OBJ/arch/arm/boot/uImage -j4

#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
    cp $KERNEL_OUT/drivers/amlogic/wifi/rtl8xxx_CU/8192cu.ko $ANDROID_PRODUCT_OUT/system/lib/
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

    cp $KERNEL_OUT/arch/arm/boot/uImage $ANDROID_PRODUCT_OUT/

    echo "Build $PRETTY_PRODUCT_OUT/uImage Done"
    exit 0
fi

############################## patch ####################################
if [ $1 = patch ]; then
    # creates a patch.zip that only upgrades kernel, applyable from recovery
    cd $ANDROID_PRODUCT_OUT
    mkdir -p inputdir/BOOT
    if [ -f boot.img ]; then
        cp boot.img inputdir/BOOT/kernel
    elif [ -f uImage ]; then
        cp uImage inputdir/BOOT/kernel
    else
        echo "Error. Build kernel first"
        exit 1
    fi
    # same as running 'mpatch inputdir patch.zip'
    ../../../../build/tools/releasetools/aml_update_packer inputdir patch.zip

    echo "Build $PRETTY_PRODUCT_OUT/patch.zip Done"
    exit 0
fi

############################## recoveryimage ####################################
if [ $1 = recoveryimage ]; then
    if [ ! -d $ANDROID_PRODUCT_OUT/recovery/root ]; then
    	echo "No $PRODUCT_OUT/recovery/root found! You need build it first"
	    echo "make recoveryimage at android top dir"
        exit 1
    fi

    make -f device/amlogic/${TARGET_PRODUCT}/Kernel.mk $ANDROID_PRODUCT_OUT/obj/KERNEL_OBJ/arch/arm/boot/uImage -j4

#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
    cp $KERNEL_OUT/drivers/amlogic/wifi/rtl8xxx_CU/8192cu.ko $ANDROID_PRODUCT_OUT/system/lib/
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

    cp $KERNEL_OUT/arch/arm/boot/uImage_recovery $ANDROID_PRODUCT_OUT/

    echo "Build $PRETTY_PRODUCT_OUT/uImage_recovery Done"
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
fi

if [ ! -d $PRODUCT_OUT/recovery/root ]; then
	echo "No $PRODUCT_OUT/recovery/root found! You need build it first"
	echo "make recoveryimage at android top dir"
exit 1
fi

echo "config: $KERNEL_USBBURN_CONFIG"
make -C $KERNEL_ROOTDIR O=$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $KERNEL_USBBURN_CONFIG

make -C $KERNEL_ROOTDIR O=$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- uImage
make -C $KERNEL_ROOTDIR O=$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- modules
mkdir -p $PRODUCT_OUT/recovery/root/boot

#{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{
cp $KERNEL_OUT/drivers/amlogic/load_deferred_module/deferreddrv.ko $PRODUCT_OUT/recovery/root/boot/
#}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

cp $KERNEL_OUT/arch/arm/boot/uImage $PRODUCT_OUT/uImage_usb_burning

echo "Build $PRODUCT_OUT/uImage_usb_burning Done"
exit 0
fi

############################## menuconfig ####################################
if [ $1 = menuconfig ]; then
	if [ -f $KERNEL_CONFIG ]; then
		make -C $KERNEL_ROOTDIR O=$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $KERNEL_DEFCONFIG
	fi
	make -C $KERNEL_ROOTDIR O=$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- menuconfig

	exit 0
fi

############################## saveconfig ####################################
if [ $1 = saveconfig -o $1 = savedefconfig ]; then
	if [ ! -f $KERNEL_CONFIG ]; then
		echo " $KERNEL_CONFIG is not found"
		make -C $KERNEL_ROOTDIR O=$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- $KERNEL_DEFCONFIG
	fi
	make -C $KERNEL_ROOTDIR O=$KERNEL_OUT ARCH=arm CROSS_COMPILE=arm-eabi- savedefconfig

	echo "config saved to $KERNEL_OUT/defconfig"
	exit 0
fi

############################## bootimage ####################################
if [ $1 = bootimagenomod ]; then
    make -f device/amlogic/${TARGET_PRODUCT}/Kernel.mk kernelnomod -j4
    cp $KERNEL_OUT/arch/arm/boot/uImage $ANDROID_PRODUCT_OUT/

    echo "Build $PRETTY_PRODUCT_OUT/uImage Done"
    exit 0
fi

#############################################################################
echo "Error: unrecognized  argument"
usage
