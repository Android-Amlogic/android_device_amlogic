#!/system/bin/sh


#echo "grep 720x480"
busybox grep "w:720,h:480" /sys/class/ppmgr/ppscaler_rect
format480=$?

#echo "grep 720x576"
busybox grep "w:720,h:576" /sys/class/ppmgr/ppscaler_rect
format576=$?

#echo "grep 1280x720"
busybox grep "w:1280,h:720" /sys/class/ppmgr/ppscaler_rect
format720=$?

#echo "grep 1920x1080"
busybox grep "w:1920,h:1080" /sys/class/ppmgr/ppscaler_rect
format1080=$?

#echo "format480 is: "$format480
#echo "format576 is: "$format576
#echo "format720 is: "$format720
#echo "format1080 is: "$format1080

if [ $format480 -eq 0 ]
then
        echo "format480 match!"
        format=480
elif [ $format576 -eq 0 ]
then
        echo "format576 match!"
        format=576
elif [ $format720 -eq 0 ]
then
        echo "format720 match!"
        format=720
elif [ $format1080 -eq 0 ]
then
        echo "format1080 match!"
        format=1080
else
        echo "no format match, set to default?"
fi
busybox fbset -fb /dev/graphics/fb0 -g 1280 720 1280 1440 16
busybox fbset -fb /dev/graphics/fb0 -g 1280 720 1280 1440 16

case $format in 

    720)
       
       busybox echo 40 25 1240 690 0 > /sys/class/ppmgr/ppscaler_rect
    ;;
    
    1080)
    
      busybox  echo 60 40 1900 1060 0 > /sys/class/ppmgr/ppscaler_rect
    ;;

    *)
     
       busybox echo 30 20 680 460 0 > /sys/class/ppmgr/ppscaler_rect
        
esac

outputmode=$(busybox cat /proc/cmdline | busybox awk -F "androidboot.resolution" '{print $2}' | busybox awk -F " " '{print $1}' | busybox cut -c 2-) 
cvbsoutput=$(busybox cat /proc/cmdline | busybox awk -F "cvbsoutput" '{print $2}' | busybox awk -F " " '{print $1}' | busybox cut -c 2-)

if [ $outputmode = "1080p" -o $outputmode = "1080i" -o  $outputmode = "1080p50hz" -o $outputmode = "1080i50hz" ] ; then
    busybox echo 1 > /sys/class/video2/screen_mode
    busybox echo 960 >  /sys/module/amvideo2/parameters/clone_frame_scale_width
    busybox echo null > /sys/class/display2/mode 
else
    busybox echo 1 > /sys/class/video2/screen_mode
    busybox echo 0 >  /sys/module/amvideo2/parameters/clone_frame_scale_width
    busybox echo null > /sys/class/display2/mode 
fi

if [ $cvbsoutput = "480cvbs" ] ; then
    busybox echo 480cvbs > /sys/class/display2/mode 
else
    busybox echo 576cvbs > /sys/class/display2/mode 
fi

#busybox echo 1 > /sys/class/graphics/fb0/free_scale
#busybox echo 1 > /sys/class/ppmgr/ppscaler
#echo 1>/sys/class/graphics/fb1/blank

#added by linan at 2012-12
/sbin/recovery
