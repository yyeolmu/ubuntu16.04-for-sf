#!/bin/bash

# Define the container name
CONTAINER_NAME="sf16.04"

# Start the container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Starting container: ${CONTAINER_NAME}"
    docker start ${CONTAINER_NAME}
else
    echo "Container ${CONTAINER_NAME} does not exist. Please create it first."
    exit 1
fi

# Attach to the container
echo "Attaching to container: ${CONTAINER_NAME}"
docker attach ${CONTAINER_NAME}
