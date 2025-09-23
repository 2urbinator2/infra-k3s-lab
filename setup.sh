#!/bin/bash

vms=("cluster-control" "cluster-worker")

get_ports() {
   
    local vm port
    for vm in "${vms[@]}"; do
        port=$(vagrant port "$vm" 2>/dev/null | grep '22 (guest) =>' | sed -E 's/.*=> ([0-9]+) \(host\)/\1/')
        echo "$vm: $port"
    done
}

setup_cluster() {
    ansible-playbook -i inventory.ini config/vb-k3s-setup.yml --ssh-extra-args="-o StrictHostKeyChecking=no"
    ansible-playbook -i inventory.ini config/cluster-management.yml --ssh-extra-args="-o StrictHostKeyChecking=no"
}

prepare_cluster() {
    kubectl create namespace my-app

    kubectl create secret docker-registry ghcr-secret \
    --docker-server=$DOCKER_SERVER \
    --docker-username=$DOCKER_USERNAME \
    --docker-password=$DOCKER_PASSWORD \
    --docker-email=$DOCKER_EMAIL \
    -n my-app
}


if [ $# -eq 0 ]; then
    echo "Error: No function specified."
    help
    exit 1
fi

case $1 in
    get_ports)
        get_ports
        ;;
    setup_cluster)
        setup_cluster
        ;;
    prepare_cluster)
        prepare_cluster
        ;;
    help|-h|--help)
        help
        ;;
    *)
        echo "Error: Unknown function '$1'."
        hilfe
        exit 1
        ;;
esac