FROM alpine:latest

RUN apk add --no-cache busybox-extras rrdtool fping font-inconsolata
RUN mkdir -p /srv/www
RUN mkdir -p /data

ADD graph.sh /bin/graph.sh
ADD ping.sh /bin/ping.sh
ADD start.sh /bin/start.sh

ENTRYPOINT ["/bin/start.sh"]
