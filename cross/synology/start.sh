#!/usr/bin/env bash
_term() {
  echo "Caught SIGTERM signal!"
  echo "Tell the transmission session to shut down."
  pid=`cat /var/transmission.pid`
  if [ ! -z "$USER" ] && [ ! -z "$PASS" ]; then
    /usr/bin/transmission-remote $RPCPORT -n "$USER":"$PASS" --exit
  else
    /usr/bin/transmission-remote $RPCPORT --exit
  fi
  # terminate when the transmission-daemon process dies
  tail --pid=${pid} -f >/dev/null 2>&1
}
trap _term SIGTERM SIGINT ERR
set -eE
usermod -o -u $PUID transmission
groupmod -o -g $PGID download

########### Init ################
if [ ! -f "/config/settings.json" ]; then
    cp /settings.json /config/settings.json
fi
# User settings
echo "USER=$USER,PASS=$PASS"
if [ ! -z "$USER" ] && [ ! -z "$PASS" ]; then
	sed -i '/rpc-authentication-required/c\    "rpc-authentication-required": true,' /config/settings.json
	sed -i "/rpc-username/c\    \"rpc-username\": \"$USER\"," /config/settings.json
	sed -i "/rpc-password/c\    \"rpc-password\": \"$PASS\"," /config/settings.json
else
	sed -i '/rpc-authentication-required/c\    "rpc-authentication-required": false,' /config/settings.json
	sed -i "/rpc-username/c\    \"rpc-username\": \"$USER\"," /config/settings.json
	sed -i "/rpc-password/c\    \"rpc-password\": \"$PASS\"," /config/settings.json
fi
# Ports settings
echo "RPCPORT=$RPCPORT,PEERPORT=$PEERPORT"
if [ ! -z "$RPCPORT" ]; then
	sed -i "/rpc-port/c\    \"rpc-port\": $RPCPORT," /config/settings.json
fi
if [ ! -z "$PEERPORT" ] ; then
	sed -i "/peer-port/c\    \"peer-port\": $PEERPORT," /config/settings.json
fi

su - transmission -c "/usr/bin/transmission-daemon -g /config -c /watch -e /config/transmission.log -x /var/transmission.pid -f"  >/config/start.log 2>/config/start.err.log &
EXPID=$!
# 等待,直到RPC端口被监听, 或者transmission启动失败
while :
do
    PID=`ps -def|grep -P 'transmission-daemon' | grep -v 'su - transmission'|awk '{print $2}'` || true
    PORT_EXIST=`netstat -tunlp | grep "$RPCPORT" | head -n 1` || true
    if [ "$PID" == "" ] || [ "$PORT_EXIST" == "" ]; then
        EXPID_EXIST=$(ps aux | awk '{print $2}'| grep -w $EXPID) || true
        if [ ! $EXPID_EXIST ];then
            echo "transmission is not running"
            exit 1
        fi
        sleep 1
        continue
    fi
    echo $PID > /var/transmission.pid
    break
done
tail -f /config/transmission.log &
wait