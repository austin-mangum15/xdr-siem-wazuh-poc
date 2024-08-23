# XDR and SIEM Solution with Wazuh - Proof of Concept

## Overview

This repository contains a Proof of Concept (PoC) for integrating Wazuh as an XDR and SIEM solution within a Kubernetes environment. The PoC demonstrates how Wazuh can be used to monitor and detect security events on vulnerable endpoints. The setup includes a local Kubernetes cluster using Minikube, with the Wazuh Manager, Wazuh Indexer, Wazuh Dashboard, and various vulnerable endpoints deployed in the cluster.

## Table of Contents

- [Setup](#setup)
- [Deploying the PoC](#deploying-the-poc)
- [Accessing the Wazuh Dashboard](#accessing-the-wazuh-dashboard)
- [Exploring Vulnerable Endpoints](#exploring-vulnerable-endpoints)
- [Monitoring and Analysis](#monitoring-and-analysis)
- [Cleanup](#cleanup)
- [Components](#components)
- [Templates](#templates)
- [Auto-Scaling and Cost Optimization](#auto-scaling-and-cost-optimization)
- [Future Work](#future-work)
- [Conclusion](#conclusion)

## Setup

### 1. Clone the Repository

Clone this repository to your local machine using the following command:

```bash
git clone https://github.com/your-repo/xdr-siem-wazuh-poc.git
cd xdr-siem-wazuh-poc
```

### 1. Clone the Repository

Clone the repository to your local machine. 

```bash
git clone https://github.com/your-repo/xdr-siem-wazuh-poc.git
cd xdr-siem-wazuh-poc
```

### 2. Set Up the Local Environment

Run the setup script to install necessary dependencies and start Minikube:

```bash
./scripts/setup.sh
```
This script will:
- Install Docker, Minikube, and kubectl if they are not already installed.
- Start a Minikube cluster using Docker as the driver.

### 3. Verify Minikube is Running

Ensure that Minikube is running correctly:

```bash
minikube status
```
You should see output indicating that Minikube and its components are running.

## Deploying the PoC

### 1. Deploy Wazuh Components and Vulnerable Endpoints

Run the deployment script to deploy all components of the PoC:

```bash
./scripts/deploy-poc.sh
```

This script will:
- Deploy the Wazuh Manager, Indexer, and Dashboard in the Minikube cluster.
- Deploy three vulnerable endpoints: a Linux server, a web server, and a Windows machine.

### 2. Check Deployment Status

You can check the status of the deployments and ensure all pods are running with:

```bash
kubectl get pods
```

You should see a list of running pods for the Wazuh Manager, Indexer, Dashboard, and the vulnerable endpoints.

### 3. Accessing the Wazuh Dashboard

to get access you will need to find the Dashboard URL. run the following command to find the url 

```bash 
minikube service wazuh-dashboard --url
```

This Command will return the URL. Open this URL n your Browser to access the Wazuh Dashboard.

### 4. Login to the Wazuh Dashboard

- Username: admin
- Password: wazuh (default password; consider changing this in a real deployment)

After logging in, you will see the Wazuh Dashboard, which provides a comprehensive overview of the security events and alerts.

### 5. Exploring Vulnerable Endpoints

The PoC deploys several vulnerable endpoints that the Wazuh agents will monitor:

- Linux Server: A Linux-based server with open ports and vulnerable services.
- Web Server: A web server running an outdated PHP application with misconfigurations.
- Windows Machine: A simulated Windows environment with insecure settings.

You can interact with these endpoints using Minikube to generate some logs and alerts. For example, you can use kubectl exec to run commands on these pods and simulate different security events.

Some examples include:

#### Port Scans
```bash
kubectl exec -it <linux-pod-name> -- nmap localhost
```
Replace *linux-pod-name* with the actual name of your Linux pod. This command will run an nmap scan within the Linux server, simulating an external port scan.

#### Directory Traversal
```bash
kubectl exec -it <web-server-pod-name> -- bash -c "curl http://localhost/../../../../etc/passwd"
```
Replace *web-server-pod-name* with the actual name of your web server pod. This command tries to read the /etc/passwd file using directory traversal, which should be detected by Wazuh.

#### Brute Force/Login Falures 
```bash
kubectl exec -it <linux-pod-name> -- bash -c "for i in {1..5}; do ssh wronguser@localhost; done"
```

Run this command to send 5 failed SSH attempts in a row. 


## Cleanup

After you are done exploring the PoC, you can clean up the resources to free up your local environment:

```bash
minikube delete
```