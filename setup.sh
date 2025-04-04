# Responsible for creating volumes and networks

source .env.network
source .env.volume


if [ "$(docker volume ls -q -f name=$VOLUME_NAME)" ]; then
    echo "Volume $VOLUME_NAME already exists"
else
    docker volume create $VOLUME_NAME
    echo "Volume $VOLUME_NAME created"
fi