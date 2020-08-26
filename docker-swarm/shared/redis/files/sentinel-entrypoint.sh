#!/bin/sh

if [ "!${CLUSTER_NAME:-}" ]; then
  CLUSTER_NAME="docker-cluster"
fi

if [ "!${SENTINEL_QUORUM:-}" ]; then
  SENTINEL_QUORUM=1
fi

if [ "!${SENTINEL_DOWN_AFTER:-}" ]; then
  SENTINEL_DOWN_AFTER=60000
fi

if [ "!${SENTINEL_FAILOVER:-}" ]; then
  SENTINEL_FAILOVER=180000
fi

mkdir -p /etc/redis

tee /etc/redis/sentinel.conf <<EOF
port 26379

dir /tmp

sentinel monitor $CLUSTER_NAME $MASTER_HOST 6379 $SENTINEL_QUORUM
sentinel down-after-milliseconds $CLUSTER_NAME $SENTINEL_DOWN_AFTER
sentinel parallel-syncs $CLUSTER_NAME 1
sentinel failover-timeout $CLUSTER_NAME $SENTINEL_FAILOVER
EOF

chown redis:redis /etc/redis/sentinel.conf

exec "/usr/local/bin/docker-entrypoint.sh" "$@"