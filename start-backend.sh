
    # Connectivity
    LOCALHOST_PORT=3000
    CONTAINER_PORT=3000

    source .env.network

    MONGODB_HOST=mongodb
    BACKEND_IMAGE_NAME=key-value-backend
    BACKEND_CONTAINER_NAME="backend"




    # Check for existing container
    if [ "$(docker ps -q -f name=$BACKEND_CONTAINER_NAME)" ]; then
        echo "Container $BACKEND_CONTAINER_NAME already exists"
        exit 1
    fi

    docker build -t $BACKEND_IMAGE_NAME -f backend/Dockerfile.dev backend

    # Run MongoDB container
    docker run -d --rm --name $BACKEND_CONTAINER_NAME \
        -e KEY_VALUE_USER=$KEY_VALUE_USER \
        -e KEY_VALUE_PASSWORD=$KEY_VALUE_PASSWORD \
        -e KEY_VALUE_DB=$KEY_VALUE_DB \
        -e PORT=$CONTAINER_PORT \
        -e MONGODB_HOST=$MONGODB_HOST \
        -p $LOCALHOST_PORT:$CONTAINER_PORT \
        -v ./backend/src:/app/src \
        --network $NETWORK_NAME \
        $BACKEND_IMAGE_NAME
