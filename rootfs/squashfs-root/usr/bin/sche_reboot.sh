#!/bin/sh
[ -z "$1" ] && echo "Error: Schedule reboot" && exit 1

. /lib/functions.sh
. /lib/netifd/netifd-proto.sh

echo "The system will auto restasrt in $1 seconds!"
sleep $1
reboot

exit 0
