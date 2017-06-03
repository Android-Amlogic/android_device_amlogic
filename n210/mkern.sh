#!/bin/bash -ex

# Run from top of kitkat source

ROOTFS=$1
#ROOTFS="../lpdk/out/target/product/m102/ramdisk.img"

if [ "$ROOTFS" == "" -o ! -f "$ROOTFS" ]; then
    echo "Usage: $0 <ramdisk.img> [m]"
    exit 1
fi

KERNEL_OUT=out/target/product/n210/obj/KERNEL_OBJ
mkdir -p $KERNEL_OUT

if [ ! -f $KERNEL_OUT/.config ]; then
    make -C common O=../$KERNEL_OUT mesong9tv_defconfig
fi
if [ "$2" != "m" ]; then
    make -C common O=../$KERNEL_OUT uImage -j6
fi
make -C common O=../$KERNEL_OUT modules -j6

if [ "$2" != "m" ]; then
    make -C common O=../$KERNEL_OUT mesong9tv_n210.dtd
    make -C common O=../$KERNEL_OUT mesong9tv_n210.dtb
fi


if [ "$2" != "m" ]; then
    common/mkbootimg --kernel common/../$KERNEL_OUT/arch/arm/boot/uImage \
        --ramdisk ${ROOTFS} \
        --second common/../$KERNEL_OUT/arch/arm/boot/dts/amlogic/mesong9tv_n210.dtb \
        --output ./boot.img
    ls -l ./boot.img
    echo "boot.img done"
fi
