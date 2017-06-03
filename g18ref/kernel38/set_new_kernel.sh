#! /bin/bash

cp u-boot-dt.bin ../u-boot.bin
cp Kernel_38.mk ../Kernel.mk
cp system_38.prop ../system.prop
cp set_display_mode_38.sh ../recovery/set_display_mode.sh

echo "set 3.8 kernel compile enviroment done"
