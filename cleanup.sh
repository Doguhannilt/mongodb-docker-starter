#!/bin/bash

source .env.volume
source .env.network
source .env.db

# Volume temizliği
if [ "$(docker volume ls -q -f name=$VOLUME_NAME)" ]; then
    docker volume rm $VOLUME_NAME
    echo "Volume $VOLUME_NAME removed"
fi

# Network temizliği
if [ "$(docker network ls -q -f name=$NETWORK_NAME)" ]; then
    docker network rm $NETWORK_NAME
    echo "Network $NETWORK_NAME removed"
fi  

# Container temizliği
if [ "$(docker ps -aq -f name=$DB_CONTAINER_NAME)" ]; then
    docker rm -f $DB_CONTAINER_NAME
    echo "Container $DB_CONTAINER_NAME removed"
fi
