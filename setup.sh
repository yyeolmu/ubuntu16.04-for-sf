#!/bin/bash

# Set the home directory dynamically
USER_HOME=${1:-/home/default}
IMAGE_NAME="ubuntu-16.04-dev"
CONTAINER_NAME="sf16.04"

# Build the Docker image with the dynamic home directory
echo "Building Docker image with USER_HOME=${USER_HOME}..."
docker build --build-arg USER_HOME=${USER_HOME} -t ${IMAGE_NAME} .

# Check if the container already exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container ${CONTAINER_NAME} already exists. Restarting it..."
    docker start ${CONTAINER_NAME}
else
    echo "Creating and starting a new container: ${CONTAINER_NAME}"
    docker run -it --name ${CONTAINER_NAME} -v ${USER_HOME}:${USER_HOME} ${IMAGE_NAME}
fi
