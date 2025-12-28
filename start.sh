#!/bin/sh

# Check if the RRD for this exists.
# If not, create it.

if [ ! -f /data/ping.rrd ]; then

    # all data for 5 minutes
    # average+min+max every 5 minutes for a year
    # average+min+max every hour for 10 years

    echo "Creating ping.rrd...."
    rrdtool create /data/ping.rrd --step 1 \
        DS:ping:GAUGE:600:0:U \
        DS:loss:GAUGE:600:0:U \
        RRA:AVERAGE:0.5:1:300 \
        RRA:AVERAGE:0.5:300:105192 \
        RRA:MIN:0.5:300:105192 \
        RRA:MAX:0.5:300:105192 \
        RRA:AVERAGE:0.5:3600:87660 \
        RRA:MIN:0.5:3600:87660 \
        RRA:MAX:0.5:3600:87660
else
    echo "Using existing ping.rrd..."
fi

echo "Updating crontab..."

cat > /etc/crontabs/root <<EOF
* * * * * ping.sh
*/5 * * * * graph.sh 1h 1d 1w 1y 10y
EOF

echo "Generating graphs..."
graph.sh 1h 1d 1w 1y 10y

echo "Starting web server..."
httpd -p 80 -h /srv/www/

echo "Starting cron..."
crond -f
