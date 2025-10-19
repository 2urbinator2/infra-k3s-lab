#!/bin/bash

echo "Getting host ports for Vagrant VMs and writing to .env file..."

./scripts/get-ports.sh

echo "Setting up K3s cluster with Ansible..."

ansible-playbook -i inventory.ini config/k3s-setup.yml --ssh-extra-args="-o StrictHostKeyChecking=no"

echo "Configuring cluster management with Ansible..."

ansible-playbook -i inventory.ini cluster-management.yml --ssh-extra-args="-o StrictHostKeyChecking=no"



