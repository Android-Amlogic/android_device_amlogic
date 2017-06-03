#!/system/bin/sh

case `getprop sys.fb.bits` in
    32) osd_bits=32
    ;;

    *) osd_bits=16
    ;;
esac

case $(getprop ubootenv.var.outputmode) in 

    lvds1080p)
        echo lvds1080p > /sys/class/display/mode
        echo 0 0 1920 1080 0 0 64 64 > /sys/class/display/axis
    ;;  

    lvds1080p50hz)
        echo lvds1080p50hz > /sys/class/display/mode
        echo 0 0 1920 1080 0 0 64 64 > /sys/class/display/axis
    ;;    

    *)
        echo "Error: Un-supported display mode lvds1080p"
        echo "       Default to lvds1080p"
        echo lvds1080p > /sys/class/display/mode
        echo 0 0 1920 1080 0 0 64 64 > /sys/class/display/axis

esac
