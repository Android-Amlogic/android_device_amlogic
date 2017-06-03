#!/system/bin/sh
random()
{
  echo `expr $RANDOM % 256`
}
addr()
{
  printf "%02x:%02x:%02x:%02x:%02x:%02x\n" `random` `random` `random` `random` `random` `random`
}
if [ -f "/system/etc/bluetooth/bt_addr.conf" ];then
  if [ `head -n 1 /system/etc/bluetooth/bt_addr.conf` != "00:00:00:00:00:00" ];then
      exit 0;
  fi
fi
touch /system/etc/bluetooth/bt_addr.conf
chmod 666 /system/etc/bluetooth/bt_addr.conf
echo `addr` > /system/etc/bluetooth/bt_addr.conf
