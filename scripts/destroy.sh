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
    rm ./config/backend-deployment.yaml
    rm ./config/frontend-deployment.yaml

    echo "Cleanup completed."
  
}

delete_app() {
    echo "Checking if namespace 'my-app' exists..."
    if ! kubectl get namespace my-app &>/dev/null; then
        echo "Namespace my-app does not exist."
        exit 0
    fi

    echo "Deleting all resources in namespace 'my-app'..."
    kubectl delete all --all -n my-app
    echo "Deleting all resources in namespace 'my-app' and the namespace..."
    kubectl get namespace my-app -o json > /tmp/ns.json
    jq '.spec.finalizers=[]' /tmp/ns.json > /tmp/ns-mod.json
    kubectl replace --raw "/api/v1/namespaces/my-app/finalize" -f /tmp/ns-mod.json
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
