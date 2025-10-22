#!/bin/bash

# This script automates the deployment of feature branch changes to the K3s cluster

set -e

set -o allexport
source ./.env
set +o allexport

echo "Deploying changes."

echo "Generating unique tag for this deployment..."
TAG=$(date +%s)

echo "Building Docker images for frontend and backend..."
docker build -t $HOST_IP:5001/frontend:$TAG ./my-app/frontend
docker build -t $HOST_IP:5001/backend:$TAG ./my-app/backend

echo "Pushing Docker images to local registry..."
docker push $HOST_IP:5001/frontend:latest
docker push $HOST_IP:5001/backend:latest

echo "Updating Kubernetes deployments with new images..."
kubectl set image deployment/frontend frontend=$HOST_IP:5001/frontend:$TAG --record
kubectl set image deployment/backend backend=$HOST_IP:5001/backend:$TAG --record

echo "Waiting for deployments to roll out..."
kubectl rollout restart deployment/frontend
kubectl rollout restart deployment/backend

kubectl rollout status deployment/frontend --timeout=30s || echo "Frontend Rollout hängt – Logs prüfen"
kubectl rollout status deployment/backend --timeout=30s || echo "Backend Rollout hängt – Logs prüfen"


echo "Successfully deployed!"