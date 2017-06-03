#! /system/bin/sh

echo rm default_ext > /sys/class/vfm/map;
echo add dvd_in vdin0 deinterlace amvideo > /sys/class/vfm/map;
echo 480i >/sys/class/tvin_ext/sphe8202k;
echo 1 > /sys/class/video/screen_mode;
#echo 1 > /sys/class/graphics/fb0/blank;
echo 1 > /sys/class/video/freerun_mode;
