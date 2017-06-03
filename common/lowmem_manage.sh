#!/system/bin/sh
	text=`grep 'MemTotal:' /proc/meminfo`
	mem=${text#MemTotal:}
	if (("${mem%kB}" < "512*1024")) then
		echo $((256*1024*1024))  > /sys/block/zram0/disksize
		echo $((2048)) > /proc/sys/vm/mem_management_thresh
	else
		echo $((500*1024*1024))  > /sys/block/zram0/disksize
		echo $((8192)) > /proc/sys/vm/mem_management_thresh
	fi
	mkswap /dev/block/zram0
	swapon /dev/block/zram0
	sleep 1
	make_ext4fs -b 4096 /dev/block/zram0
	sleep 1
	mount -t ext4 -o rw /dev/block/zram0 /swap_zram0

