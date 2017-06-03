#!/system/bin/sh
dbFile="/param/pq.db"
if [ ! -f "$dbFile" ]; then
cp /system/etc/pq.db /param/pq.db
chown system /param/pq.db
chgrp system /param/pq.db
sync
else
cat /default.prop
fi
