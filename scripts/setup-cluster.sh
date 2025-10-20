#!/bin/bash

ENV_FILE="$(dirname "$0")/../.env"

# This script creates VMs, sets up the K3s cluster, configures cluster management and creates a local Docker registry
echo "Bringing up Vagrant VMs..."
vagrant up

echo "Connect to Vagrant VMs to initialize SSH connections..."
vagrant ssh cluster-control -c "exit"
vagrant ssh cluster-worker -c "exit"

# Create .env file if it doesn't exist
touch .env

echo "Getting host ports for Vagrant VMs and writing to .env file..."
./get-ports.sh

mkdir -p ~/.kube/cs-cluster

echo "Setting up K3s cluster with Ansible..."
ansible-playbook -i inventory.yaml config/k3s-setup.yml --ssh-extra-args="-o StrictHostKeyChecking=no"

echo "Configuring cluster management with Ansible..."
ansible-playbook -i inventory.yaml config/cluster-management.yml --ssh-extra-args="-o StrictHostKeyChecking=no"

echo 'export KUBECONFIG=~/.kube/cs-cluster' >> ~/.bashrc
source ~/.bashrc

echo "Setting up local Docker registry on host machine..."
docker run -d -p 5001:5000 --name registry \
  -v $(pwd)/registry-data:/var/lib/registry \
  registry:2

echo "Registering local Docker registry on all cluster nodes..."
./scripts/register-registry.sh
