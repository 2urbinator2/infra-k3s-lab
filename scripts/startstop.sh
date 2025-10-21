#!/bin/bash


if [ -z "$1" ]; then
    echo "Usage: $0 {start|stop}"
    exit 1
fi

case "$1" in
    start)
        echo "Start Vagrant-VMs..."
        vagrant up
        echo "Start Docker-Container 'registry'..."
        docker start registry
        ;;
    stop)
        echo "Stop Vagrant-VMs..."
        vagrant halt -f
        echo "Stop Docker-Container 'registry'..."
        docker stop registry
        ;;
    *)
        echo "Unknown Option: $1"
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac