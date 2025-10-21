#!/bin/bash

# This script automates the deployment of feature branch changes to the K3s cluster

set -e

# Load environment variables
set -o allexport
source ./.env
set +o allexport

echo "Deploying changes."

# 1. Build images
docker build -t $HOST_IP:5001/frontend:latest ./frontend
docker build -t $HOST_IP:5001/backend:latest ./backend

# 2. Push zur Registry
docker push $HOST_IP:5001/frontend:latest
docker push $HOST_IP:5001/backend:latest

# 3. Deployments aktualisieren
kubectl set image deployment/frontend frontend=$HOST_IP:5001/frontend:latest
kubectl set image deployment/backend backend=$HOST_IP:5001/backend:latest

# 4. Check rollout
kubectl rollout status deployment/frontend
kubectl rollout status deployment/backend

echo "Successfully deployed!"