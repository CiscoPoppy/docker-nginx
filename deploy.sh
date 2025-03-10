#!/bin/bash

# Stop and remove existing container if it exists
if [ "$(docker ps -aq -f name=nginx-web)" ]; then
    echo "Stopping and removing existing container..."
    docker stop nginx-web
    docker rm nginx-web
fi

# Remove existing image to force rebuild
if [[ "$(docker images -q nginx-web 2> /dev/null)" != "" ]]; then
    echo "Removing existing image..."
    docker rmi nginx-web:latest
fi

# Build and start the container
echo "Building and starting container..."
docker-compose up -d --build

# Verify the container is running
echo "Verifying container is running..."
if [ "$(docker ps -q -f name=nginx-web)" ]; then
    echo "=== SUCCESS: Nginx container is running on port 8088 ==="
    echo "You can access it at: http://$(hostname -I | awk '{print $1}'):8088"
    exit 0
else
    echo "=== ERROR: Container failed to start ==="
    docker logs nginx-web
    exit 1
fi
