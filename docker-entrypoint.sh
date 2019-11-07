#!/bin/bash
#set -e
#set -x


rpcbind
rpc.statd -L
rpc.idmapd
dbus-uuidgen --ensure
dbus-daemon --system --fork
exec /usr/bin/supervisord -n -c /etc/supervisord.conf