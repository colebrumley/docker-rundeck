#!/bin/bash

trap 'kill $(jobs -p)' EXIT

mem=${SERVER_MEMORY:-1024}
perm=$(($mem/4))

exec java -Xmx${mem}m \
  -XX:MaxPermSize=${perm}m \
  -Ddefault.user.name=${DEFAULT_USER:-admin} \
  -Ddefault.user.password=${DEFAULT_PASSWORD:-admin} \
  -Drundeck.jetty.connector.forwarded=true \
  -Dserver.http.host=0.0.0.0 \
  -Dserver.hostname=$(hostname) \
  -Dserver.http.port=${SERVER_PORT:-4440} \
  -jar $RDECK_JAR &
rd_pid=$!

wait $rd_pid
