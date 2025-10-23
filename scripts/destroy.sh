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

# Does not delete perfectly yet due to finalizers in namespace
delete_app() {
    NAMESPACE="my-app"

    echo "Checking if namespace '$NAMESPACE' exists..."
    if ! kubectl get namespace "$NAMESPACE" &>/dev/null; then
        echo "Namespace $NAMESPACE does not exist."
        return 0
    fi

    echo "Deleting all resources in namespace '$NAMESPACE'..."
    kubectl delete all --all -n "$NAMESPACE" --ignore-not-found
    kubectl delete configmap,secret,pvc --all -n "$NAMESPACE" --ignore-not-found

    echo "Removing finalizers from the namespace itself..."
    kubectl get namespace "$NAMESPACE" -o json | \
    jq '.spec.finalizers=[]' | \
    kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f -

    echo "Deleting namespace '$NAMESPACE'..."
    kubectl delete namespace "$NAMESPACE" --wait=true
    echo "Namespace '$NAMESPACE' and all resources deleted."
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
