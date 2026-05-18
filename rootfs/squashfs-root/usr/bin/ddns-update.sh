#!/bin/sh
#
# $Id: //WIFI_SOC/release/SDK_4_1_0_0/source/user/rt2880_app/scripts/ddns-update.sh#1 $
#
# usage: ddns-update.sh
#

wanmode=`uci get network.wan.proto`
ddns_enable=`uci get system.ddns.enable`
srv=`uci get system.ddns.provider`
ddns=`uci get system.ddns.domain`
u=`uci get system.ddns.account`
pw=`uci get system.ddns.password`
#hn=`nvram_get 2860 DDNSHostname`
#email=`nvram_get 2860 DDNSEmail`
hn=''
email=''
opmode=`uci get system.opmode.mode`
killall -q yddns

if [ "$ddns_enable" = "0" ]; then
	exit 0
fi
if [ "$opmode" = "1" ]; then
	if [ "$wanmode" = "PPPOE" ]; then
		s1=`ifconfig ppp0 | grep "inet addr"`
		if [ "$s1" = "" ]; then
			echo "ppp0 no addr, ddns exit"
			exit 0
		fi
		
		s2=`echo $s1 | cut -f2 -d:`	
		wan_ip_addr=`echo $s2 | cut -f1 -d " "`
		
	elif [ "$wanmode" = "3G" ]; then
		if [ "$wan3gmodel" = "ME3760" ]; then
				s1=`ifconfig usb0 | grep "inet addr"`
			else
				s1=`ifconfig ppp0 | grep "inet addr"`
			fi
			
			if [ "$s1" = "" ]; then
				echo "ppp0 no addr, ddns exit"
				exit 0
			fi
		
		s2=`echo $s1 | cut -f2 -d:`	
		wan_ip_addr=`echo $s2 | cut -f1 -d " "`
	elif [ "$wanmode" = "DHCP" -o "$wanmode" = "STATIC" ]; then
		s1=`ifconfig eth2.2 | grep "inet addr"`
		if [ "$s1" = "" ]; then
			echo "eth2.2 no addr, ddns exit"
			exit 0
		fi

		s2=`echo $s1 | cut -f2 -d:`
		wan_ip_addr=`echo $s2 | cut -f1 -d " "`
	else
		wan_ip_addr=`echo 172.1.1.1`
	fi

	s3=`ifconfig eth2.2 | grep "HWaddr"`
	wan_mac_addr=`echo $s3 | cut -c35-52`
elif [ "$opmode" = "3" ]; then
	if [ "$wanmode" = "PPPOE" ]; then
		s1=`ifconfig ppp0 | grep "inet addr"`
		if [ "$s1" = "" ]; then
			echo "ppp0 no addr, ddns exit"
			exit 0
		fi
		
		s2=`echo $s1 | cut -f2 -d:`	
		wan_ip_addr=`echo $s2 | cut -f1 -d " "`
	elif [ "$wanmode" = "DHCP" -o "$wanmode" = "STATIC" ]; then
		s1=`ifconfig apcli0 | grep "inet addr"`
		if [ "$s1" = "" ]; then
			echo "apcli0 no addr, ddns exit"
			exit 0
		fi

		s2=`echo $s1 | cut -f2 -d:`
		wan_ip_addr=`echo $s2 | cut -f1 -d " "`
	else
		wan_ip_addr=`echo 172.1.1.1`
	fi

	s3=`ifconfig apcli0 | grep "HWaddr"`
	wan_mac_addr=`echo $s3 | cut -c35-52`

fi

if [ "$srv" = "intelbras.com" ]; then
	wan_ip_addr=`uci get system.ddns.ipaddr`
	yddns -u intelbras $email $hn $wan_mac_addr $wan_ip_addr
else
#	echo "$0: unknown DDNS provider: $srv"
	exit 1
fi
