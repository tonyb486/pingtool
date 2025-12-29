#!/bin/sh

# Check if the RRD for this exists.
# If not, create it.

if [ ! -f /data/ping.rrd ]; then

    # data ever minute for 5 minutes
    # average+min+max every 5 minutes for a year
    # average+min+max every hour for 10 years

    echo "Creating ping.rrd...."
    rrdtool create /data/ping.rrd --step 60 \
        DS:ping:GAUGE:600:0:U \
        DS:loss:GAUGE:600:0:U \
        RRA:AVERAGE:0.5:1:5 \
        RRA:AVERAGE:0.5:5:105192 \
        RRA:MIN:0.5:5:105192 \
        RRA:MAX:0.5:5:105192 \
        RRA:AVERAGE:0.5:60:87660 \
        RRA:MIN:0.5:60:87660 \
        RRA:MAX:0.5:60:87660
else
    echo "Using existing ping.rrd..."
fi

echo "Starting web server..."
httpd -p 80 -h /srv/www/

echo "Starting loop..."
while true; do
    ping.sh
    graph.sh 3h 1d 1w 1y 10y
    sleep 60
done
