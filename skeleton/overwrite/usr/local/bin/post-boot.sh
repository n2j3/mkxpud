#!/bin/bash

if [ ! -e /tmp/firsttime ]; then

# run this script once
touch /tmp/firsttime

# start udev daemon
udevd --daemon
udevadm trigger

# work through NIC 
for NIC in eth0 eth1 eth2 wlan0 ath0 ra0; do
	/bin/ifconfig $NIC up
	/sbin/iwconfig $NIC mode Managed
done
/usr/local/bin/netdaemon eth0

# setup sound channel
for channel in Master Front; do
	/usr/bin/amixer set $channel 80%
done

# keymap
if [ ! -z $KEYMAP ] && [ -e /usr/local/share/keymap/$KEYMAP.kmap ]; then 
	loadkmap < /usr/local/share/keymap/$KEYMAP.kmap
fi

# execute customize script 
[ -e /sbin/customize.sh ] && . /sbin/customize.sh 

# start hotplug script
/bin/cp /sbin/hotplug-x /sbin/hotplug

fi 
