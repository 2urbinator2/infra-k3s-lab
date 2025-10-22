#!/bin/bash

# This script destroys either all infrastructure and deployments or only the application resources in the K3s cluster

# === Fuctions ===

delete_all() {
  echo "Deleting all everything ..."

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

    echo "Removing generated Kubernetes deployment configurations..."
    rm /config/backend-deployment.yaml.template
    rm /config/frontend-deployment.yaml.template

    echo "Cleanup completed."
  
}

delete_app() {
  echo "Deleting all resources in namespace 'my-app' and the namespace..."
  kubectl delete all --all -n my-app
  kubectl delete namespace my-app
}

# === Main Script ===

case "$1" in
  all)
    delete_all
    ;;
  app)
    delete_app
    ;;
  *)
    echo "Usage: $0 {all|app}"
    exit 1
    ;;
esac
