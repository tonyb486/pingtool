#!/bin/bash

echo "Spiking the tip jar..."
NOW=$(date +%s)
THEN=$(($NOW-(300*3000)))

rm ping.rrd data.txt

rrdtool create ping.rrd --step 1 --start $(($THEN-300)) \
    DS:ping:GAUGE:600:0:U \
    DS:loss:GAUGE:600:0:U \
    RRA:AVERAGE:0.5:1:300 \
    RRA:AVERAGE:0.5:300:105192 \
    RRA:MIN:0.5:300:105192 \
    RRA:MAX:0.5:300:105192 \
    RRA:AVERAGE:0.5:3600:87660 \
    RRA:MIN:0.5:3600:87660 \
    RRA:MAX:0.5:3600:87660

gseq $THEN 300 $NOW | while read -r i; do
    echo "$(($i)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+1)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+2)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+3)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+4)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+5)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+6)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+7)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+8)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
    echo "$(($i+9)):$(shuf -i 10-30 -n 1):$(shuf -i 0-10 -n 1)" >> data.txt
done

echo "Updating..."
rrdtool update ping.rrd -t ping:loss $(cat data.txt)
