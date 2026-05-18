#!/bin/sh

. /lib/functions.sh

set_port_speed() {
	local wan lan1 lan2 lan3 lan4
	# 0:auto, 1:10M half, 2:10M full, 3:100M half, 4:100M full

	config_get speedIdx $1 wan
	echo "[set port wan speed $speedIdx]"
	
	case $speedIdx in
		0) 
			;;
		1)
			ethtool -s eth0 speed 10 duplex half
			;;
		2) 
			ethtool -s eth0 speed 10 duplex full
			;;
		3)
			ethtool -s eth0 speed 100 duplex half
			;;
		4)
			ethtool -s eth0 speed 100 duplex full
			;;
	esac

	#lan1:port1, lan2:port2, ...
	for i in 1 2 3 4;
	do
		config_get speedIdx $1 lan$i
		echo "[set port lan$i speed $speedIdx]"
		if [ $speedIdx = 1 ]; then
			ssdk_sh port duplex set $i half
			ssdk_sh port speed set $i 10
		elif [ $speedIdx = 2 ]; then
			ssdk_sh port duplex set $i full
			ssdk_sh port speed set $i 10
		elif [ $speedIdx = 3 ]; then
			ssdk_sh port duplex set $i half
			ssdk_sh port speed set $i 100
		elif [ $speedIdx = 4 ]; then
			ssdk_sh port duplex set $i full
			ssdk_sh port speed set $i 100
		fi
	 done
}

config_load network
config_foreach set_port_speed ethspeed

exit 0
