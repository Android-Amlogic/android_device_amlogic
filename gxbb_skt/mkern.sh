#!/bin/bash -ex

# Run from top of kitkat source

#ROOTFS=$1
ROOTFS="out/target/product/gxbb_skt/ramdisk.img"
PREFIX_CROSS_COMPILE=aarch64-linux-gnu-

if [ "$ROOTFS" == "" -o ! -f "$ROOTFS" ]; then
    echo "Usage: $0 <ramdisk.img> [m]"
    exit 1
fi

KERNEL_OUT=out/target/product/gxbb_skt/obj/KERNEL_OBJ
#mkdir -p $KERNEL_OUT

if [ ! -f $KERNEL_OUT/.config ]; then
    make -C common O=../$KERNEL_OUT meson64_defconfig ARCH=arm64 CROSS_COMPILE=$PREFIX_CROSS_COMPILE
fi
if [ "$2" != "m" ]; then
    make -C common O=../$KERNEL_OUT ARCH=arm64 -j6 CROSS_COMPILE=$PREFIX_CROSS_COMPILE UIMAGE_LOADADDR=0x1008000
fi
make -C common O=../$KERNEL_OUT modules ARCH=arm64 -j6 CROSS_COMPILE=$PREFIX_CROSS_COMPILE

if [ "$2" != "m" ]; then
#    make -C common O=../$KERNEL_OUT gxbb_skt.dtd ARCH=arm64 CROSS_COMPILE=$PREFIX_CROSS_COMPILE
    make -C common O=../$KERNEL_OUT gxbb_skt.dtb ARCH=arm64 CROSS_COMPILE=$PREFIX_CROSS_COMPILE
fi


if [ "$2" != "m" ]; then
    out/host/linux-x86/bin/mkbootimg --kernel common/../$KERNEL_OUT/arch/arm64/boot/Image \
        --ramdisk ${ROOTFS} \
        --second common/../$KERNEL_OUT/arch/arm64/boot/dts/amlogic/gxbb_skt.dtb \
        --output ./out/target/product/gxbb_skt/boot.img
    ls -l ./out/target/product/gxbb_skt/boot.img
    echo "boot.img done"
fi
