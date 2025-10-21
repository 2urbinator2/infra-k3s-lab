#!/bin/bash

# This script automates the deployment of the application on the K3s cluster

set -e

# echo "Deploying applications to K3s cluster..."

# set -o allexport
# source .env
# set +o allexport

# echo "Building Docker images for frontend and backend..."
# docker build -t frontend:latest ./my-app/frontend
# docker build -t backend:latest ./my-app/backend

# echo "Tagging Docker images for local registry..."
# docker tag frontend:latest $HOST_IP:5001/frontend:latest
# docker tag backend:latest $HOST_IP:5001/backend:latest

# echo "Pushing Docker images to local registry..."
# docker push $HOST_IP:5001/frontend:latest
# docker push $HOST_IP:5001/backend:latest


