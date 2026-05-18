#!/bin/sh
. /lib/totolink_custom.sh
CURDATE=$(date +%Y%m%d)
#output HTTP header
echo "Pragma: no-cache"
echo "Cache-control: no-cache"
echo "Content-type: application/x-targz"
echo "Content-Transfer-Encoding: gzip, deflate"
echo "Content-Disposition: attachment; filename=\"Config-$MODEL-$CURDATE.dat\""
echo ""
sysupgrade --create-backup - 2>/dev/null