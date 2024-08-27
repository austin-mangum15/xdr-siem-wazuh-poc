#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to deploy a Kubernetes configuration file
deploy_k8s() {
    local file=$1
    echo "Deploying $file..."
    kubectl apply -f "$file"
}

# Ensure Minikube is running
echo "Ensuring Minikube is running..."
minikube status || minikube start --driver=docker

# Pull the latest Docker Hub images
echo "Pulling the latest Wazuh images from Docker Hub..."
docker pull wazuh/wazuh-manager:latest
docker pull wazuh/wazuh-indexer:latest
docker pull wazuh/wazuh-dashboard:latest

# Set the base directory to the script location
BASE_DIR="$(dirname "$0")/../deploy/kubernetes"

# Deploy Wazuh components (Manager, Indexer, Dashboard)
echo "Deploying Wazuh components..."
deploy_k8s "$BASE_DIR/wazuh-manager-deployment.yaml"
deploy_k8s "$BASE_DIR/wazuh-indexer-deployment.yaml"
deploy_k8s "$BASE_DIR/wazuh-dashboard-deployment.yaml"

# Deploy vulnerable endpoints (if any)
echo "Deploying vulnerable endpoints..."
deploy_k8s "$BASE_DIR/../endpoints/linux-server-deployment.yaml"
deploy_k8s "$BASE_DIR/../endpoints/web-server-deployment.yaml"
deploy_k8s "$BASE_DIR/../endpoints/windows-machine-deployment.yaml"

# Print status of deployments
echo "Getting the status of all deployments..."
kubectl get pods

echo "PoC deployment complete. Wazuh Manager, Indexer, Dashboard, and vulnerable endpoints are now running in your local Kubernetes cluster."
