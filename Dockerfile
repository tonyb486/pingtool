FROM alpine:latest

RUN apk add --no-cache busybox-extras rrdtool fping font-inconsolata tzdata
RUN mkdir -p /srv/www
RUN mkdir -p /data

ADD graph.sh /bin/graph.sh
ADD ping.sh /bin/ping.sh
ADD start.sh /bin/start.sh

RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -S -D appuser

RUN chown -R appuser:appgroup /srv/www
RUN chown -R appuser:appgroup /data

USER appuser

ENTRYPOINT ["/bin/start.sh"]
