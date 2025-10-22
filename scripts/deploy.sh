#!/bin/bash

# This script automates the deployment of the application on the K3s cluster and applies changes based on the provided parameter

# initial deployment function
initial() {
    set -e

    echo "Deploying applications to K3s cluster..."
    set -o allexport
    source .env
    set +o allexport

    echo "Createing namespace 'my-app' in K3s cluster..."
    kubectl create namespace my-app || echo "Namespace 'my-app' already exists."

    echo "Building Docker images for frontend and backend..."
    docker build -t frontend:latest ./applications/berlin-travel-guide/frontend
    docker build -t backend:latest ./applications/berlin-travel-guide/backend

    echo "Tagging Docker images for local registry..."
    docker tag frontend:latest $HOST_IP:5001/frontend:latest
    docker tag backend:latest $HOST_IP:5001/backend:latest

    echo "Pushing Docker images to local registry..."
    docker push $HOST_IP:5001/frontend:latest
    docker push $HOST_IP:5001/backend:latest

    echo "Generating Kubernetes deployment configurations..."
    sed "s|IMAGE_PLACEHOLDER|$HOST_IP:5001/backend:latest|" ./config/backend-deployment.yaml.template > ./config/backend-deployment.yaml
    sed "s|IMAGE_PLACEHOLDER|$HOST_IP:5001/frontend:latest|" ./config/frontend-deployment.yaml.template > ./config/frontend-deployment.yaml

    echo "Applying Kubernetes deployment configurations..."
    kubectl apply -f ./config/frontend-deployment.yaml
    kubectl apply -f ./config/backend-deployment.yaml

    echo "Applying Kubernetes service configurations..."
    kubectl apply -f config/backend-service.yaml
    kubectl apply -f config/frontend-service.yaml
}

# deployment changes function
change() {
    echo "Tschüss"
}

# Prüfen, ob ein Parameter übergeben wurde
if [ "$1" == "initial" ]; then
    initial
elif [ "$1" == "change" ]; then
    change
else
    echo "Please use 'initial' or 'change' as parameter."
fi