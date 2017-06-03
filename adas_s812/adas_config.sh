#! /system/bin/sh
ret=`mount | grep config`
echo ret=$ret
if [ -z $ret ];then
	echo "mkfs ext2 /dev/block/config"
	mkfs.ext2 /dev/block/config
	mount -t ext4 /dev/block/config /Custconfig
fi
