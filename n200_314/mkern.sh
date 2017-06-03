#!/bin/bash -ex

# Run from top of kitkat source

#ROOTFS=$1
ROOTFS="out/target/product/n200_314/ramdisk.img"
PREFIX_CROSS_COMPILE=arm-linux-gnueabihf-

if [ "$ROOTFS" == "" -o ! -f "$ROOTFS" ]; then
    echo "Usage: $0 <ramdisk.img> [m]"
    exit 1
fi

KERNEL_OUT=out/target/product/n200_314/obj/KERNEL_OBJ
#mkdir -p $KERNEL_OUT

if [ ! -f $KERNEL_OUT/.config ]; then
    make -C common O=../$KERNEL_OUT meson32_defconfig ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE
fi
if [ "$2" != "m" ]; then
    make -C common O=../$KERNEL_OUT uImage ARCH=arm -j6 CROSS_COMPILE=$PREFIX_CROSS_COMPILE UIMAGE_LOADADDR=0x1008000
fi
make -C common O=../$KERNEL_OUT modules ARCH=arm -j6 CROSS_COMPILE=$PREFIX_CROSS_COMPILE

if [ "$2" != "m" ]; then
#    make -C common O=../$KERNEL_OUT meson8m2_n200_2G.dtd ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE
    make -C common O=../$KERNEL_OUT meson8m2_n200_2G.dtb ARCH=arm CROSS_COMPILE=$PREFIX_CROSS_COMPILE
fi


if [ "$2" != "m" ]; then
    common/mkbootimg --kernel common/../$KERNEL_OUT/arch/arm/boot/uImage \
        --ramdisk ${ROOTFS} \
        --second common/../$KERNEL_OUT/arch/arm/boot/dts/amlogic/meson8m2_n200_2G.dtb \
        --output ./out/target/product/n200_314/boot.img
    ls -l ./out/target/product/n200_314/boot.img
    echo "boot.img done"
fi
