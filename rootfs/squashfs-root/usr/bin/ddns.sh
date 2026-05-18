#!/bin/sh
#
# $Id: //WIFI_SOC/MP/SDK_4_3_0_0/RT288x_SDK/source/user/rt2880_app/scripts/ddns.sh#1 $
#
# usage: ddns.sh
#


ddns_enabled=`uci get system.ddns.enabled`
srv=`uci get system.ddns.provider`
ddns=`uci get system.ddns.domain`
u=`uci get system.ddns.account`
pw=`uci get system.ddns.password`
#hn=`nvram_get 2860 DDNSHostname`
#email=`nvram_get 2860 DDNSEmail`
hn=''
email=''
opmode=`uci get system.opmode.mode`
wan3gmodel=``
updateDDNS(){
#	killall -q yddns

	if [ "$ddns_enabled" = "0" ]; then
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
	elif [ "$opmode" = "3" ]; then
		wispInterface=`uci get system.opmode.wispinface`
		if [ "$wanmode" = "PPPOE" ]; then
			s1=`ifconfig ppp0 | grep "inet addr"`
			if [ "$s1" = "" ]; then
				echo "ppp0 no addr, ddns exit"
				exit 0
			fi
		
			s2=`echo $s1 | cut -f2 -d:`	
			wan_ip_addr=`echo $s2 | cut -f1 -d " "`
		elif [ "$wanmode" = "DHCP" -o "$wanmode" = "STATIC" ]; then
			if [ "$wispInterface" = "1" ]; then
				s1=`ifconfig apclii0 | grep "inet addr"`
			else
				s1=`ifconfig apcli0 | grep "inet addr"`
			fi
			if [ "$s1" = "" ]; then
				echo "apcli0 no addr, ddns exit"
				exit 0
			fi

			s2=`echo $s1 | cut -f2 -d:`
			wan_ip_addr=`echo $s2 | cut -f1 -d " "`
		else
			wan_ip_addr=`echo 172.1.1.1`
		fi
		if [ "$wispInterface" = "1" ]; then
			s3=`ifconfig apclii0 | grep "HWaddr"`
		else
			s3=`ifconfig apcli0 | grep "HWaddr"`
		fi
	fi

	wan_mac_addr=`echo $s3 | cut -c35-52`
	if [ "$srv" = "dyndns.org" ]; then
		yddns -s dyndns $ddns $u $pw $wan_ip_addr
	elif [ "$srv" = "no-ip.com" ]; then
		yddns -s noip $ddns $u $pw $wan_ip_addr
	elif [ "$srv" = "3322.org" ]; then
		yddns -s qdns $ddns $u $pw $wan_ip_addr
	elif [ "$srv" = "tzo.org" ]; then
		yddns -s tzo $ddns $u $pw $wan_ip_addr
	elif [ "$srv" = "intelbras.com" ]; then
		yddns -s intelbras $email $hn $wan_mac_addr $wan_ip_addr
	else
	#	echo "$0: unknown DDNS provider: $srv"
		exit 1
	fi
}

while [ "1" == "1" ]
do
	updateDDNS
	sleep 180
done
