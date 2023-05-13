#!/bin/sh

[ -z "$REDIS_NODES" ] && REDIS_NODES="6000,6001,6002,6003,6004,6005"
[ -z "$REDIS_HOST" ] && REDIS_HOST="127.0.0.1"
[ -z "$REDIS_REPLICAS" ] && REDIS_REPLICAS="1"

NODES=$(echo "$REDIS_NODES" | tr "," " ")
CLUSTER_ROOT="/data/cluster"
LOG_ROOT="/var/log/redis"

prepare()
{
  echo "Cluster nodes: $REDIS_NODES"
  mkdir -p "$CLUSTER_ROOT"
  mkdir -p "$LOG_ROOT"
}

configure_node()
{
  port="$1"
  local_config="$CLUSTER_ROOT/$port"

  mkdir -p "$local_config"
  cat > "$local_config/redis.conf" <<EOF
port $port
bind 0.0.0.0
cluster-enabled yes
cluster-config-file nodes-$port.conf
cluster-node-timeout 32000
appendonly yes
daemonize yes
pidfile /var/run/redis-$port.pid
logfile $LOG_ROOT/$port.log
EOF
  
  touch "$LOG_ROOT/$port.log"
  tail -f "$LOG_ROOT/$port.log" & redis-server "$local_config/redis.conf" &
  sleep 4
}


configure()
{
  cluster_nodes=""

  for node_port in $NODES
  do
    echo "===> Configuring node with port: $node_port..."
    cluster_nodes="$REDIS_HOST:$node_port $cluster_nodes"

    configure_node "$node_port"
  done;

  echo "===> Creating cluster..."
  sleep 4
  redis-cli --cluster create $cluster_nodes --cluster-yes --cluster-replicas $REDIS_REPLICAS
}

prepare && configure

# to keep container running...
echo "===> Ready for client connections"
tail -f /dev/null 

