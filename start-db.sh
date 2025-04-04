#!/bin/bash

MONGODB_IMAGE="mongodb/mongodb-community-server"
MONGODB_TAG="7.0-ubuntu2204"

# Root Credentials
ROOT_USER="root"
ROOT_PASSWORD="password"

# Custom DB values
KEY_VALUE_DB="key-value-db"
KEY_VALUE_USER="key-value-user"
KEY_VALUE_PASSWORD="key-value-password"

# Connectivity
LOCALHOST_PORT=27017
CONTAINER_PORT=27017

# Load ENV
source .env.db
source .env.network
source .env.volume
source setup.sh

VOLUME_CONTAINER_PATH="/data/db"

# Check and create volume
if ! docker volume ls -q -f name=$VOLUME_NAME | grep -q .; then
    docker volume create $VOLUME_NAME
    echo "Volume $VOLUME_NAME created"
else
    echo "Volume $VOLUME_NAME already exists"
fi

# Check and create network
if ! docker network ls -q -f name=$NETWORK_NAME | grep -q .; then
    docker network create $NETWORK_NAME
    echo "Network $NETWORK_NAME created"
else
    echo "Network $NETWORK_NAME already exists"
fi

# Check for existing container
if [ "$(docker ps -q -f name=$DB_CONTAINER_NAME)" ]; then
    echo "Container $DB_CONTAINER_NAME already exists"
    exit 1
fi

# Run MongoDB container
docker run -d --rm --name $DB_CONTAINER_NAME \
    -e MONGODB_INITDB_ROOT_USERNAME=$ROOT_USER \
    -e MONGODB_INITDB_ROOT_PASSWORD=$ROOT_PASSWORD \
    -e KEY_VALUE_USER=$KEY_VALUE_USER \
    -e KEY_VALUE_PASSWORD=$KEY_VALUE_PASSWORD \
    -e KEY_VALUE_DB=$KEY_VALUE_DB \
    -p $LOCALHOST_PORT:$CONTAINER_PORT \
    -v $VOLUME_NAME:$VOLUME_CONTAINER_PATH \
    -v ./db-config/mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js:ro \
    --network $NETWORK_NAME \
    $MONGODB_IMAGE:$MONGODB_TAG
