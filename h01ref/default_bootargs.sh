#!/system/bin/sh
DefaultBootargsFile="/param/default_bootargs.args"
if [ ! -f "$DefaultBootargsFile" ]; then
cp /system/etc/default_bootargs.args /param/default_bootargs.args
sync
else
cat /default.prop
fi