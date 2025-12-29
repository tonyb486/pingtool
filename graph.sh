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
        DEF:v_min=/data/ping.rrd:ping:MIN \
        DEF:v_max=/data/ping.rrd:ping:MAX \
        CDEF:delta=v_max,v_min,- \
        AREA:v_min#FFFFFF00 \
        STACK:delta#0000FF40 \
        LINE:ping#0000FF:Ping\ \(RTT\ ms\) \
        LINE:loss#FF0000:Loss\ \(%\) \
        VDEF:ping_min=v_min,MINIMUM \
        VDEF:ping_max=v_max,MAXIMUM \
        VDEF:ping_avg=ping,AVERAGE \
        COMMENT:"\n" \
        COMMENT:"ping\:" \
        GPRINT:ping_min:"min\: %5.2lf" \
        GPRINT:ping_max:"max\: %5.2lf" \
        GPRINT:ping_avg:"avg\: %5.2lf" \
        COMMENT:"\n" \
        VDEF:loss_min=loss,MINIMUM \
        VDEF:loss_max=loss,MAXIMUM \
        VDEF:loss_avg=loss,AVERAGE \
        COMMENT:"loss\:" \
        GPRINT:loss_min:"min\: %5.2lf" \
        GPRINT:loss_max:"max\: %5.2lf" \
        GPRINT:loss_avg:"avg\: %5.2lf" \
        COMMENT:"\n" \
        COMMENT:"fping to ${TARGET}" \
        COMMENT:"Generated $(date | sed 's/:/\\:/g')" >/dev/null

        echo "<img src='/$i.png?d=$NOW' /> <br /><br />" >> /srv/www/index.html
done

echo "</center>" >> /srv/www/index.html
