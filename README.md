Ubuntu 16.04 Development Environment

This repository provides a Dockerfile and setup scripts to build and run a customized Ubuntu 16.04 development environment. The environment includes various tools such as Python, GEF, Pwntools, and more.

Features

Base OS: Ubuntu 16.04

Pre-installed tools:

Python 2.7 and pip

Pwntools

GEF (GDB Enhanced Features)

Oh My Zsh with Powerlevel10k theme

Tmux

Locale set to UTF-8

Dynamic home directory support with /home volume mounting

Setup Instructions

1. Build the Docker Image

You can build the Docker image either manually or using the provided setup.sh script.

Option 1: Build Manually

Clone this repository:

git clone https://github.com/<your_username>/ubuntu16.04-for-sf.git
cd ubuntu16.04-for-sf

Build the Docker image:

docker build -t ubuntu-16.04-dev .

Option 2: Build with setup.sh

Run the setup script:

./setup.sh

This script dynamically sets the home directory and builds the Docker image.

Run the Container

You can run the container either manually or using the provided start.sh script.

Option 1: Run Manually

Run the container and mount your home directory:

docker run -it --name sf16.04 -v /home:/home ubuntu-16.04-dev

Once inside the container, you can start working in the mounted /home directory.

Option 2: Run with start.sh

Use the start.sh script to run the container:

./start.sh

If a container with the same name exists, it will be restarted.

If no container exists, a new one will be created and started.

