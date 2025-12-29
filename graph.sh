#!/bin/sh

echo "<center>" > /srv/www/index.html
NOW=$(date +%s)

for i in "$@"; do
    rrdtool graph /srv/www/$i.png --start -$i \
        --font DEFAULT:10:Inconsolata \
        --height 200 --width 600 \
        --vertical-label "Ping (ms)" \
        --right-axis-label "Loss (%)" \
        --right-axis-formatter numeric \
        --title "Ping to ${TARGET} ($i)" \
        DEF:ping=/data/ping.rrd:ping:AVERAGE \
        DEF:loss=/data/ping.rrd:loss:AVERAGE  \
        DEF:ping_min=/data/ping.rrd:ping:MIN \
        DEF:ping_max=/data/ping.rrd:ping:MAX \
        DEF:loss_min=/data/ping.rrd:loss:MIN \
        DEF:loss_max=/data/ping.rrd:loss:MAX \
        CDEF:delta=ping_max,ping_min,- \
        AREA:ping_min#FFFFFF00 \
        STACK:delta#0000FF40 \
        LINE:ping#0000FF:Ping\ \(RTT\ ms\) \
        LINE:loss#FF0000:Loss\ \(%\) \
        VDEF:ping_smin=ping_min,MINIMUM \
        VDEF:ping_smax=ping_max,MAXIMUM \
        VDEF:ping_savg=ping,AVERAGE \
        COMMENT:"\n" \
        COMMENT:"ping\:" \
        GPRINT:ping_smin:"min\: %5.2lf" \
        GPRINT:ping_smax:"max\: %5.2lf" \
        GPRINT:ping_savg:"avg\: %5.2lf" \
        COMMENT:"\n" \
        VDEF:loss_smin=loss_min,MINIMUM \
        VDEF:loss_smax=loss_max,MAXIMUM \
        VDEF:loss_savg=loss,AVERAGE \
        COMMENT:"loss\:" \
        GPRINT:loss_smin:"min\: %5.2lf" \
        GPRINT:loss_smax:"max\: %5.2lf" \
        GPRINT:loss_savg:"avg\: %5.2lf" \
        COMMENT:"\n" \
        COMMENT:"fping to ${TARGET}" \
        COMMENT:"Generated $(date | sed 's/:/\\:/g')" >/dev/null

        echo "<img src='/$i.png?d=$NOW' /> <br /><br />" >> /srv/www/index.html
done

echo "</center>" >> /srv/www/index.html
