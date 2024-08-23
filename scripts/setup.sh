#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if Docker is running and accessible
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running or not accessible. Please start Docker and ensure your user has access."
    exit 1
fi

# Check if the user is in the docker group
if ! groups $USER | grep -q "\bdocker\b"; then
    echo "Adding user $USER to the docker group..."
    sudo usermod -aG docker $USER
    echo "User $USER added to the docker group. Please log out and log back in or run 'newgrp docker' to apply changes."
    newgrp docker
fi

# Start Minikube with Docker driver
echo "Starting Minikube..."
minikube start --driver=docker --force

# Install kubectl if it's not installed
if ! command_exists kubectl; then
    echo "kubectl not found. Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

# Verify installation
echo "Verifying installations..."
docker --version
minikube version
kubectl version --client

echo "Local Kubernetes cluster setup is complete."
