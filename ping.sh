#!/bin/sh

PINGDATA=$(fping -c ${NUM_PINGS} -p 100 -t 5000 -q ${TARGET} 2>&1)

PING=$(echo $PINGDATA | cut -d'/' -f8)
LOSS=$(echo $PINGDATA | cut -d'/' -f5 | cut -d'%' -f1)

rrdtool update /data/ping.rrd -t ping:loss N:$PING:$LOSS
