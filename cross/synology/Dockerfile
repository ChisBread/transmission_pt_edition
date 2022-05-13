FROM ubuntu:20.04
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    net-tools expect wget ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && rm /bin/sh && ln -s /bin/bash /bin/sh

ARG TPE_VER=3.0-r13
ARG TR_VER=3.00-20
ARG SYNO_VER=6.2.3

RUN  echo 'detect arch ...' \
    && ARCH='unknown' \
    && if [[ `uname -p` =~ "x86_64" ]]; then ARCH='x64';  fi \
    && if [[ `uname -p` =~ "armv7" ]]; then \
        ARCH='armv7';  \
        for i in /etc/ssl/certs/*.pem; do HASH=$(openssl x509 -hash -noout -in $i); ln -s $(basename $i) /etc/ssl/certs/$HASH.0; done \
    fi \
    && if [[ `uname -p` =~ "aarch64" ]]; then ARCH='aarch64'; fi \
    && echo "download spk and copy to root" \
    && mkdir -p /tmp/tr && cd /tmp/tr \
    && wget https://github.com/ChisBread/transmission_pt_edition/releases/download/$TPE_VER/transmission_${ARCH}-${SYNO_VER}_${TR_VER}.spk \
    && tar xvf transmission_${ARCH}-${SYNO_VER}_${TR_VER}.spk \
    && tar xvf package.tgz -C /usr \
    && chmod a+x /usr/bin/transmission-* \
    && chmod -R a+rw /usr/share/transmission \
    && rm -rf /tmp/tr \
    && echo "create user and group" \
    && groupadd -o -g 100 download && useradd -o -m -u 1026 -g download transmission
    

COPY start.sh /start.sh
COPY settings.json /settings.json
RUN chmod a+x /start.sh && chmod a+r /settings.json

ENV TRANSMISSION_WEB_HOME=/usr/share/transmission/web \
    TZ=Asia/Shanghai 
# ports and volumes
ENV USER='transmission'
ENV PASS='transmission'
ENV PUID=1026
ENV PGID=100
ENV RPCPORT=9091
ENV PEERPORT=51413
EXPOSE $RPCPORT $PEERPORT/tcp $PEERPORT/udp
VOLUME /config /downloads /watch
ENTRYPOINT [ "/start.sh" ]