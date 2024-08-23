#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker if it's not installed
if ! command_exists docker; then
    echo "Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Install Minikube if it's not installed
if ! command_exists minikube; then
    echo "Minikube not found. Installing Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    sudo mv minikube /usr/local/bin/
fi

# Start Minikube
echo "Starting Minikube..."
minikube start --driver=docker

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
