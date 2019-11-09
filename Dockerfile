FROM weaveworks/weave-npc:2.6.0 AS weave

RUN cp /usr/bin/weave-npc /tmp/ \
    && \
    cp /usr/bin/launch.sh /tmp/ \
    && \
    cp /etc/ulogd.conf /tmp/

FROM alpine:3.10.2

COPY --from=weave /tmp/weave-npc /usr/bin/
COPY --from=weave /tmp/launch.sh /usr/bin/
COPY --from=weave /tmp/ulogd.conf /etc/

RUN apk update \
    && \
    apk --no-cache add \
        iptables \
        ipset \
        ulogd \
    && \
    mknod /var/log/ulogd.pcap p \
    && \
    ln -fs /sbin/xtables-nft-multi /sbin/iptables \
    && \
    ln -fs /sbin/xtables-nft-multi /sbin/iptables-restore \
    && \
    ln -fs /sbin/xtables-nft-multi /sbin/iptables-save

ENTRYPOINT ["/usr/bin/launch.sh"]
