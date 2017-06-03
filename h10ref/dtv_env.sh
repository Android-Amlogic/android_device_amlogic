#!/system/bin/sh

echo "do wififix..."
chmod 0666 /dev/dvb0.frontend0
chmod 0666 /dev/dvb0.demux0
chmod 0666 /dev/dvb0.demux1
chmod 0666 /dev/dvb0.demux2
chmod 0666 /dev/dvb0.dvr0
chmod 0666 /dev/dvb0.dvr1
chmod 0666 /dev/dvb0.dvr2
chmod 0666 /sys/class/stb/demux0_source
chmod 0666 /sys/class/stb/demux1_source
chmod 0666 /sys/class/stb/demux2_source
chmod 0666 /sys/class/stb/source
chmod 0666 /sys/class/stb/asyncfifo0_source
chmod 0666 /sys/class/stb/asyncfifo1_source
chmod 0666 /sys/class/stb/video_pts
chmod 0666 /sys/class/stb/audio_pts
chmod 0666 /sys/class/stb/reset_tuner
