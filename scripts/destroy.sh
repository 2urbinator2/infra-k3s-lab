#!/bin/bash

# This script destroys the Vagrant VMs and removes the local Docker registry

set -o allexport
source ./.env
set +o allexport

echo "Destroying Vagrant VMs..."
vagrant destroy -f

echo "Removing .env file."
rm .env

echo "Delete Kubeconfig for the cluster." 
rm -rf ~/.kube/cs-cluster

echo "Removing local Docker registry..."
docker stop registry 
docker rm registry
docker rmi registry:2

echo "Removing registry data directory."
rm -rf registry-data

echo "Remove application images"
docker rmi frontend:latest
docker rmi backend:latest

echo "Removing tagged images from local registry"
docker rmi $HOST_IP:5001/frontend:latest
docker rmi $HOST_IP:5001/backend:latest

echo "Cleanup completed."