#!/bin/bash
cd ../../..

repo sync -j12
source build/envsetup.sh
lunch h01ref-eng
make clean -j12
make -j12
cd external/tvapi
mm -B
cd ../..
cd ./common/
make distclean -j12
make meson6tv_h01_defconfig
make uImage -j12
make modules -j12

cp drivers/amlogic/ppmgr/ppmgr.ko ../out/target/product/h01ref/system/lib/
cp drivers/amlogic/tvin/tvafe/tvin_afe.ko ../out/target/product/h01ref/system/lib/
cp drivers/amlogic/tvin/tvin_common.ko ../out/target/product/h01ref/system/lib/
cp drivers/amlogic/tvin/hdmirx/tvin_hdmirx.ko ../out/target/product/h01ref/system/lib/
cp drivers/amlogic/tvin/vdin/tvin_vdin.ko ../out/target/product/h01ref/system/lib/

cp drivers/amlogic/ppmgr/ppmgr.ko ../out/target/product/h01ref/root/boot
cp drivers/amlogic/tvin/tvafe/tvin_afe.ko ../out/target/product/h01ref/root/boot
cp drivers/amlogic/tvin/tvin_common.ko ../out/target/product/h01ref/root/boot
cp drivers/amlogic/tvin/hdmirx/tvin_hdmirx.ko ../out/target/product/h01ref/root/boot
cp drivers/amlogic/tvin/vdin/tvin_vdin.ko ../out/target/product/h01ref/root/boot
cp ../hardware/arm/gpu/ump/ump.ko ../out/target/product/h01ref/root/boot/
cp ../hardware/arm/gpu/mali/mali.ko ../out/target/product/h01ref/root/boot/

make uImage -j12
cp arch/arm/boot/uImage ../out/target/product/h01ref/


make meson6tv_h01_recovery_defconfig
make uImage -j12
cp arch/arm/boot/uImage ../out/target/product/h01ref/uImage_recovery

cd ..

make otapackage -j12


