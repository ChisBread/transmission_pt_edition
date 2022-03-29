FROM linuxserver/transmission:latest
RUN apk add make automake autoconf pkgconfig curl-dev libevent-dev gcc g++ git && \
    cd / && git clone --recursive https://github.com/ChisBread/transmission_pt_edition && cd transmission_pt_edition ; \
    HAVE_CXX=yes ./configure --disable-nls --enable-daemon --enable-utp --disable-dependency-tracking --prefix=/usr ; \
    make && make install ; \
    rm -r /transmission-web-control && mv /transmission_pt_edition/third-party/transmission-web-control/src /transmission-web-control; \
    rm -r /transmission_pt_edition && \
    echo "**** cleanup ****" && \
    apk del --purge make automake autoconf pkgconfig git gcc g++ curl-dev libevent-dev openssh && \
    rm -rf \
        /root/.cache \
        /tmp/*
RUN sed -i `grep -n 'PEERPORT' /etc/cont-init.d/20-config | awk -F: '{print $1}'|head -n 1`' i if [ ! -z "$RPCPORT" ]; then' /etc/cont-init.d/20-config && \
    sed -i `grep -n 'PEERPORT' /etc/cont-init.d/20-config | awk -F: '{print $1}'|head -n 1`' i     sed -i "/rpc-port/c\\    \\"rpc-port\\": $RPCPORT," /config/settings.json' /etc/cont-init.d/20-config && \
    sed -i `grep -n 'PEERPORT' /etc/cont-init.d/20-config | awk -F: '{print $1}'|head -n 1`' i fi' /etc/cont-init.d/20-config
ENV RPCPORT=9091
ENV TRANSMISSION_WEB_HOME=/transmission-web-control/
EXPOSE $RPCPORT
