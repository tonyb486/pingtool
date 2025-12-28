#!/bin/sh

fping -c 5 -i 1100 $1 2>&1 | while read -r line; do

    if [ "x$(echo $line | cut -d' ' -f3)" == "xxmt/rcv/%loss" ]; then
        LOSS=$(echo $line | cut -d'/' -f5 | cut -d'%' -f1)
        rrdtool update /data/ping.rrd -t loss N:$LOSS
    elif [ "x$(echo $line | cut -d' ' -f4-5)" == "x64 bytes," ]; then
        PING=$(echo $line | cut -d' ' -f6)
        rrdtool update /data/ping.rrd -t ping N:$PING
    fi

done
