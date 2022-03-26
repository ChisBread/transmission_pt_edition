FROM linuxserver/transmission:latest
RUN apk add automake autoconf gcc g++ pkgconfig curl-dev libevent-dev
RUN cd / && git clone https://github.com/ChisBread/transmission_pt_edition && cd transmission_pt_edition ; \
    HAVE_CXX=yes ./configure --disable-nls --enable-daemon --enable-utp --disable-dependency-tracking --prefix=/usr ; \
    make && make install ; \
    rm -r /transmission_pt_edition
RUN sed -i `grep -n 'PEERPORT' /etc/cont-init.d/20-config | awk -F: '{print $1}'|head -n 1`' i if [ ! -z "$RPCPORT" ]; then \
	sed -i "/rpc-port/c\\    \\"rpc-port\\": $RPCPORT," /config/settings.json \
fi' /etc/cont-init.d/20-config
ENV RPCPORT=9091
EXPOSE $RPCPORT
