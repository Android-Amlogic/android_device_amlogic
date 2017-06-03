#! /system/bin/sh
if [ $# -gt 1 ];then
	echo "wr $1 fb0 "
	echo $1 > /sys/class/graphics/fb0/blank
else
echo 1 > /sys/class/graphics/fb0/blank
fi
