# infra-k3s-lab

![Experimental Setup](https://img.shields.io/badge/Experimental-Setup-1563FF?style=flat)
![K3s Cluster](https://img.shields.io/badge/K3s-Cluster-4BC51D?logo=kubernetes&logoColor=white)
![Vagrant Setup](https://img.shields.io/badge/Vagrant-Automation-1563FF?logo=vagrant&logoColor=white)
![VirtualBox VMs](https://img.shields.io/badge/VirtualBox-2%20VMs-183A61?logo=virtualbox&logoColor=white)


This repo fully automates the deployment of a local K3s cluster on VirtualBox VMs using Vagrant and Ansible.

Optionally, a microservice-application featuring a frontend and backend can be deployed to provide Berlin sightseeing recommendations.

**Required Prerequisites:** VirtualBox, Vagrant, Ansible, Kubernetes CLI


## Setup Infrastructure in Vagrant 

1. Create VMs: `vagrant up`
   1. Fill out ports in inventory: `vagrant port <name>`
2. Deploy K3s: `ansible-playbook -i inventory.yaml k3s-setup/k3s-setup.yml --ssh-extra-args="-o StrictHostKeyChecking=no"`
3. Setup cluster managemant: `ansible-playbook -i inventory.yaml k3s-setup/cluster-management.yml --ssh-extra-args="-o StrictHostKeyChecking=no"`
4. Start tunnel: `vagrant ssh cluster-control -- -N -L 6443:127.0.0.1:6443 &`


## Deploy Application and Access

1. Deploy application on cluster: 
   1. `cd test-application` 
   2. `kubectl apply -f deploy/`
2. Create tunnel: 
   1. `kubectl port-forward svc/frontend 8080:80 -n my-app`
   2. `kubectl port-forward svc/backend 31000:5003 -n my-app`
3. Access: `http://localhost:8080/`

