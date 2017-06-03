busybox fbset -fb /dev/graphics/fb0 -g 1200 690 1200 1380 16
busybox fbset -fb /dev/graphics/fb1 -g 32 32 32 32 32
echo panel > /sys/class/display/mode
echo 83 25 1200 690 40 15 18 18 > /sys/class/display/axis
