#!/system/bin/sh

outputmode=$(cat /proc/cmdline | awk -F "androidboot.resolution" '{print $2}' | awk -F " " '{print $1}' | cut -c 2-) 
cvbsoutput=$(cat /proc/cmdline | awk -F "cvbsoutput" '{print $2}' | awk -F " " '{print $1}' | cut -c 2-)

if [ $outputmode = "1080p" -o $outputmode = "1080i" -o  $outputmode = "1080p50hz" -o $outputmode = "1080i50hz" ] ; then
    echo 1 > /sys/class/video2/screen_mode
    echo 960 >  /sys/module/amvideo2/parameters/clone_frame_scale_width 
    echo null > /sys/class/display2/mode
else
    echo 1 > /sys/class/video2/screen_mode
    echo 0 >  /sys/module/amvideo2/parameters/clone_frame_scale_width 
    echo null > /sys/class/display2/mode
fi

if [ $cvbsoutput = "480cvbs" ] ; then
    echo 480cvbs > /sys/class/display2/mode 
else
    echo 576cvbs > /sys/class/display2/mode 
fi

CONFIG_XML="/fastplay/adconf.xml"
if [ -f ${CONFIG_XML} ] ; then
	AD_FILE=`grep "<adpath>" ${CONFIG_XML} | sed 's/\(.*\)>\(.*\)<\(.*\)/\2/g'`
	if [ -f ${AD_FILE} ] ; then
		echo ${AD_FILE}
		/system/bin/kplayer_alsa ${AD_FILE} 
	else
		echo "no ad file"
		/system/bin/kplayer_alsa
	fi
else
	echo "no adconf.xml"
	/system/bin/kplayer_alsa
fi

#fix@lir, now getprop may be faild, so sleep 5 
sleep 5
#end
case `getprop sys.fb.bits` in
	32) osd_bits=32
	;;

	*) osd_bits=16
	;;
esac
#fix@letv
#outputmode=$(getprop ubootenv.var.outputmode)
#outputmode=$(cat /proc/cmdline | awk -F "androidboot.resolution" '{print $2}' | awk -F " " '{print $1}' | cut -c 2-)
echo $outputmode
#endfix		
case $outputmode in 
	480p)
	if [ "$(getprop ubootenv.var.480poutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.480poutputx)
		fi
		if [ "$(getprop ubootenv.var.480poutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.480poutputy)
		fi
		if [ "$(getprop ubootenv.var.480poutputwidth)" = "" ] ; then 
			outputwidth=720
		else outputwidth=$(getprop ubootenv.var.480poutputwidth)
		fi
		if [ "$(getprop ubootenv.var.480poutputheight)" = "" ] ; then 
			outputheight=480
		else outputheight=$(getprop ubootenv.var.480poutputheight)
	fi
	   
	;;
	
	480i)
	
	if [ "$(getprop ubootenv.var.480ioutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.480ioutputx)
		fi
		if [ "$(getprop ubootenv.var.480ioutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.480ioutputy)
		fi
		if [ "$(getprop ubootenv.var.480ioutputwidth)" = "" ] ; then 
			outputwidth=720
		else outputwidth=$(getprop ubootenv.var.480ioutputwidth)
		fi
		if [ "$(getprop ubootenv.var.480ioutputheight)" = "" ] ; then 
			outputheight=480
		else outputheight=$(getprop ubootenv.var.480ioutputheight)    
	 fi  
	;; 
	
		480cvbs)
	
	if [ "$(getprop ubootenv.var.480ioutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.480ioutputx)
		fi
		if [ "$(getprop ubootenv.var.480ioutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.480ioutputy)
		fi
		if [ "$(getprop ubootenv.var.480ioutputwidth)" = "" ] ; then 
			outputwidth=720
		else outputwidth=$(getprop ubootenv.var.480ioutputwidth)
		fi
		if [ "$(getprop ubootenv.var.480ioutputheight)" = "" ] ; then 
			outputheight=480
		else outputheight=$(getprop ubootenv.var.480ioutputheight)    
	 fi  
	;; 
	   
	576p)
	if [ "$(getprop ubootenv.var.576poutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.576poutputx)
		fi
		if [ "$(getprop ubootenv.var.576poutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.576poutputy)
		fi
		if [ "$(getprop ubootenv.var.576poutputwidth)" = "" ] ; then 
			outputwidth=720
		else outputwidth=$(getprop ubootenv.var.576poutputwidth)
		fi
		if [ "$(getprop ubootenv.var.576poutputheight)" = "" ] ; then 
			outputheight=576
		else outputheight=$(getprop ubootenv.var.576poutputheight)    
	 fi      
	   
	;;    
	
	576i)
	if [ "$(getprop ubootenv.var.576ioutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.576ioutputx)
		fi
		if [ "$(getprop ubootenv.var.576ioutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.576ioutputy)
		fi
		if [ "$(getprop ubootenv.var.576ioutputwidth)" = "" ] ; then 
			outputwidth=720
		else outputwidth=$(getprop ubootenv.var.576ioutputwidth)
		fi
		if [ "$(getprop ubootenv.var.576ioutputheight)" = "" ] ; then 
			outputheight=576
		else outputheight=$(getprop ubootenv.var.576ioutputheight)    
	 fi
	 ;;          
	
	  576cvbs)
	  if [ "$(getprop ubootenv.var.576ioutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.576ioutputx)
		fi
		if [ "$(getprop ubootenv.var.576ioutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.576ioutputy)
		fi
		if [ "$(getprop ubootenv.var.576ioutputwidth)" = "" ] ; then 
			outputwidth=720
		else outputwidth=$(getprop ubootenv.var.576ioutputwidth)
		fi
		if [ "$(getprop ubootenv.var.576ioutputheight)" = "" ] ; then 
			outputheight=576
		else outputheight=$(getprop ubootenv.var.576ioutputheight)    
	 fi 
	    
	;;        
	720p)
	if [ "$(getprop ubootenv.var.720poutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.720poutputx)
		fi
		if [ "$(getprop ubootenv.var.720poutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.720poutputy)
		fi
		if [ "$(getprop ubootenv.var.720poutputwidth)" = "" ] ; then 
			outputwidth=1280
		else outputwidth=$(getprop ubootenv.var.720poutputwidth)
		fi
		if [ "$(getprop ubootenv.var.720poutputheight)" = "" ] ; then 
			outputheight=720
		else outputheight=$(getprop ubootenv.var.720poutputheight)    
	 fi          
		
	;;

	1080p)
	if [ "$(getprop ubootenv.var.1080poutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.1080poutputx)
		fi
		if [ "$(getprop ubootenv.var.1080poutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.1080poutputy)
		fi
		if [ "$(getprop ubootenv.var.1080poutputwidth)" = "" ] ; then 
			outputwidth=1920
		else outputwidth=$(getprop ubootenv.var.1080poutputwidth)
		fi
		if [ "$(getprop ubootenv.var.1080poutputheight)" = "" ] ; then 
			outputheight=1080
		else outputheight=$(getprop ubootenv.var.1080poutputheight)    
	 fi                 
	;;

	1080i)
	 if [ "$(getprop ubootenv.var.1080ioutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.1080ioutputx)
		fi
		if [ "$(getprop ubootenv.var.1080ioutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.1080ioutputy)
		fi
		if [ "$(getprop ubootenv.var.1080ioutputwidth)" = "" ] ; then 
			outputwidth=1920
		else outputwidth=$(getprop ubootenv.var.1080ioutputwidth)
		fi
		if [ "$(getprop ubootenv.var.1080ioutputheight)" = "" ] ; then 
			outputheight=1080
		else outputheight=$(getprop ubootenv.var.1080ioutputheight)    
	 fi                       
	;;   
	1080i50hz)
	 if [ "$(getprop ubootenv.var.1080ioutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.1080ioutputx)
		fi
		if [ "$(getprop ubootenv.var.1080ioutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.1080ioutputy)
		fi
		if [ "$(getprop ubootenv.var.1080ioutputwidth)" = "" ] ; then 
			outputwidth=1920
		else outputwidth=$(getprop ubootenv.var.1080ioutputwidth)
		fi
		if [ "$(getprop ubootenv.var.1080ioutputheight)" = "" ] ; then 
			outputheight=1080
		else outputheight=$(getprop ubootenv.var.1080ioutputheight)    
	 fi                           
	   
	;;   
   
	1080p50hz)
	if [ "$(getprop ubootenv.var.1080poutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.1080poutputx)
		fi
		if [ "$(getprop ubootenv.var.1080poutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.1080poutputy)
		fi
		if [ "$(getprop ubootenv.var.1080poutputwidth)" = "" ] ; then 
			outputwidth=1920
		else outputwidth=$(getprop ubootenv.var.1080poutputwidth)
		fi
		if [ "$(getprop ubootenv.var.1080poutputheight)" = "" ] ; then 
			outputheight=1080
		else outputheight=$(getprop ubootenv.var.1080poutputheight)    
	 fi                     
	
	   ;; 
	720p50hz)
	if [ "$(getprop ubootenv.var.720poutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.720poutputx)
		fi
		if [ "$(getprop ubootenv.var.720poutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.720poutputy)
		fi
		if [ "$(getprop ubootenv.var.720poutputwidth)" = "" ] ; then 
			outputwidth=1280
		else outputwidth=$(getprop ubootenv.var.720poutputwidth)
		fi
		if [ "$(getprop ubootenv.var.720poutputheight)" = "" ] ; then 
			outputheight=720
		else outputheight=$(getprop ubootenv.var.720poutputheight)    
	 fi          
	;;   
	*)
	outputmode=720p
	if [ "$(getprop ubootenv.var.720poutputx)" = "" ] ; then 
			outputx=0
		else outputx=$(getprop ubootenv.var.720poutputx)
		fi
		if [ "$(getprop ubootenv.var.720poutputy)" = "" ] ; then 
			outputy=0
		else outputy=$(getprop ubootenv.var.720poutputy)
		fi
		if [ "$(getprop ubootenv.var.720poutputwidth)" = "" ] ; then 
			outputwidth=1280
		else outputwidth=$(getprop ubootenv.var.720poutputwidth)
		fi
		if [ "$(getprop ubootenv.var.720poutputheight)" = "" ] ; then 
			outputheight=720
		else outputheight=$(getprop ubootenv.var.720poutputheight)    
	 fi              
 
esac

echo $outputmode > /sys/class/display/mode                                                                                                                                      

busybox echo $outputx $outputy $(($outputwidth + $outputx - 1)) $(($outputheight + $outputy - 1)) 0 > /sys/class/ppmgr/ppscaler_rect                     
echo 1 > /sys/class/graphics/fb0/free_scale                                                                                                                                      
echo 1 > /sys/class/graphics/fb1/free_scale    
																														  
if [ "$(getprop ubootenv.var.digitaudiooutput)" = "RAW" ] ; then
	echo 1 > /sys/class/audiodsp/digital_raw
else
	echo 0 > /sys/class/audiodsp/digital_raw
fi

echo 1 > /sys/class/graphics/fb1/blank
fbset -fb /dev/graphics/fb1 -g 32 32 32 32 $osd_bits
echo 0 > /sys/class/graphics/fb1/blank
echo 2 > /sys/class/video/disable_video
