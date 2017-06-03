#!/sbin/sh

/sbin/busybox fdisk /dev/block/cardblkinand14 < /etc/fdisk.media.cmd
