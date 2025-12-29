#!/bin/sh

PINGDATA=$(fping -c 5 -p 100 ${TARGET} 2>&1 | tail -n1)

PING=$(echo $PINGDATA | cut -d'/' -f8)
LOSS=$(echo $PINGDATA | cut -d'/' -f5 | cut -d'%' -f1)

rrdtool update /data/ping.rrd -t ping:loss N:$PING:$LOSS
