#! /bin/bash
ARCH_INFO=`uname -a`
ARCH=''
if [[ $ARCH_INFO =~ "x86_64" ]]; then
    ARCH='amd64'
fi
if [[ $ARCH_INFO =~ "armv7" ]]; then
    ARCH='armv7'
fi
if [[ $ARCH_INFO =~ "aarch64" ]]; then
    ARCH='arm64'
fi
if [[ $ARCH == "" ]]; then
    echo "unrecognized arch"
    exit -1
fi
echo "arch: "$ARCH
cp /build/$ARCH/bin/* /usr/bin/
sed -i `grep -n 'PEERPORT' /etc/cont-init.d/20-config | awk -F: '{print $1}'|head -n 1`' i if [ ! -z "$RPCPORT" ]; then' /etc/cont-init.d/20-config
sed -i `grep -n 'PEERPORT' /etc/cont-init.d/20-config | awk -F: '{print $1}'|head -n 1`' i     sed -i "/rpc-port/c\\    \\"rpc-port\\": $RPCPORT," /config/settings.json' /etc/cont-init.d/20-config
sed -i `grep -n 'PEERPORT' /etc/cont-init.d/20-config | awk -F: '{print $1}'|head -n 1`' i fi' /etc/cont-init.d/20-config