#!/bin/bash

# This script destroys the Vagrant VMs and removes the local Docker registry
echo "Destroying Vagrant VMs..."
vagrant destroy -f

echo "Removing local Docker registry..."
docker stop registry 
docker rm registry
docker rmi registry:2

echo "Removing .env file."
rm .env

echo "Cleanup completed."