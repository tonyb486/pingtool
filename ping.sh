#!/bin/sh

PINGDATA=$(fping -i 50 -c 5 -i 1 ${TARGET} 2>&1 | tail -n1)

echo $PINGDATA

PING=$(echo $PINGDATA | cut -d'/' -f8)
LOSS=$(echo $PINGDATA | cut -d'/' -f5 | cut -d'%' -f1)

rrdtool update /data/ping.rrd -t ping:loss N:$PING:$LOSS
