#!/bin/sh

athstats > /tmp/athstate_r1
ch_c_c1=`cat /tmp/athstate_r1 | grep Channel | awk '{print $1}`
cy_c1=`cat /tmp/athstate_r1 | grep Cycle | awk '{print $1}`

#echo $ch_c_c1,$cy_c1

sleep 1

athstats > /tmp/athstate_r2
ch_c_c2=`cat /tmp/athstate_r2 | grep Channel | awk '{print $1}`
cy_c2=`cat /tmp/athstate_r2 | grep Cycle | awk '{print $1}`
#echo $ch_c_c2,$cy_c2

ch_c_c=`expr $ch_c_c2 - $ch_c_c1`
cy_c=`expr $cy_c2 - $cy_c1`
#echo $ch_c_c,$cy_c

ch_c_c=`expr $ch_c_c \* 100`
channel_busy=`expr $ch_c_c \/ $cy_c`

echo channel busy = $channel_busy %
