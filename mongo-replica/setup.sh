#!/bin/bash
echo "Running on ports: $MONGO_NODES"

# Variables defined by user:
NODES=$(echo "$MONGO_NODES" | tr "," " ") # transform example "2000,3000,4000" to "2000 3000 4000" (we can iterate)
RS="${REPLICA_SET:-rs}" # replica set name (rs by default)
HOST="${MONGO_HOST:-localhost}"

ALL_LOG_FILES=""
FIRST_NODE_PORT=""
RS_MEMBERS=""

for node_port in $NODES
do
  echo "mongodb://$HOST:$node_port"
  DATA_PATH="/var/data/mongo-$node_port"
  LOGS_PATH="/var/logs/mongo-$node_port"

  mkdir -p "$DATA_PATH"
  mkdir -p "$LOGS_PATH"

  LOGS_FILE="$LOGS_PATH/mongod.log"
  ALL_LOG_FILES="$ALL_LOG_FILES $LOGS_FILE"
  mongod --fork --dbpath $DATA_PATH --logpath $LOGS_FILE --port $node_port --bind_ip_all --replSet $RS

  if test -z "$RS_MEMBERS" # if RS_MEMBERS is empty - that means this is a first iteration
  then
    FIRST_NODE_PORT="$node_port"
    RS_MEMBERS="{\"_id\": $node_port, \"host\": \"$HOST:$node_port\"}"
  else
    RS_MEMBERS="$RS_MEMBERS, {\"_id\": $node_port, \"host\": \"$HOST:$node_port\"}"
  fi
done;

(sleep 10 && echo "RS_MEMBERS: $RS_MEMBERS" &&
mongosh --port $FIRST_NODE_PORT --eval "rs.initiate({ \"_id\": \"${RS}\", \"members\": [${RS_MEMBERS}] });") &

tail -f $ALL_LOG_FILES
