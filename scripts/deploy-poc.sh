#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to deploy a Kubernetes configuration file
deploy_k8s() {
    local file=$1
    echo "Deploying $file..."
    kubectl apply -f $file
}

# Ensure Minikube is running
echo "Ensuring Minikube is running..."
minikube status || minikube start

# Deploy Wazuh components (Manager, Indexer, Dashboard)
echo "Deploying Wazuh components..."
deploy_k8s ../deploy/kubernetes/wazuh-manager-deployment.yaml

# Deploy vulnerable endpoints
echo "Deploying vulnerable endpoints..."
deploy_k8s ../deploy/endpoints/linux-server-deployment.yaml
deploy_k8s ../deploy/endpoints/web-server-deployment.yaml
deploy_k8s ../deploy/endpoints/windows-machine-deployment.yaml

# Print status of deployments
echo "Getting the status of all deployments..."
kubectl get pods

echo "PoC deployment complete. Wazuh Manager, Indexer, Dashboard, and vulnerable endpoints are now running in your local Kubernetes cluster."
