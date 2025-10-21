#!/bin/bash

# This script creates VMs, sets up the K3s cluster, configures cluster management and creates a local Docker registry

echo "Bringing up Vagrant VMs..."
vagrant up

echo "Connect to Vagrant VMs to initialize SSH connections..."
vagrant ssh cluster-control -c "exit"
vagrant ssh cluster-worker -c "exit"

echo "Creating .env file if it does not exist..."
touch .env

echo "Getting host ports for Vagrant VMs and writing to .env file..."
./scripts/get-ports.sh

echo "Creating a folder for Kubeconfig..."
mkdir -p ~/.kube/cs-cluster

echo "Setting up K3s cluster with Ansible..."
ansible-playbook -i inventory.yaml config/k3s-setup.yml --ssh-extra-args="-o StrictHostKeyChecking=no"

echo "Configuring cluster management with Ansible..."
ansible-playbook -i inventory.yaml config/cluster-management.yml --ssh-extra-args="-o StrictHostKeyChecking=no"

echo 'export KUBECONFIG=~/.kube/cs-cluster' >> ~/.bashrc
source ~/.bashrc

echo "Registering local Docker registry on all cluster nodes..."
./scripts/setup-registry.sh
