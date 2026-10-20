# infra-k3s-lab

![Experimental Setup](https://img.shields.io/badge/Experimental-Setup-1563FF?style=flat)
![K3s Cluster](https://img.shields.io/badge/K3s-Cluster-4BC51D?logo=kubernetes&logoColor=white)
![Vagrant Setup](https://img.shields.io/badge/Vagrant-Automation-1563FF?logo=vagrant&logoColor=white)
![VirtualBox VMs](https://img.shields.io/badge/VirtualBox-2%20VMs-183A61?logo=virtualbox&logoColor=white)


This repo fully automates the deployment of a local K3s cluster on VirtualBox VMs using Vagrant and Ansible. This creates a cluster consisting of a control node and a worker node.

Additionally, there are two sample applications that can be deployed to the cluster.

- **[sample application](https://github.com/2urbinator2/microservice-testapp):** An unfinished web application consisting of a frontend and a backend, hosted on GitHub Packages.
- **travel-guide** This application consists of a frontend that provides sight recommendations in Berlin, supported by a backend that manages the actual list of sights.

**Required Prerequisites:** VirtualBox, Vagrant, Ansible, Kubernetes CLI


## Setup Infrastructure in Vagrant 

1. Create VMs: `vagrant up`
   1. Fill out ports in inventory: `vagrant port <name>`
2. Deploy K3s: `ansible-playbook -i inventory.yaml k3s-setup/k3s-setup.yml --ssh-extra-args="-o StrictHostKeyChecking=no"`
3. Setup cluster managemant: `ansible-playbook -i inventory.yaml k3s-setup/cluster-management.yml --ssh-extra-args="-o StrictHostKeyChecking=no"`
4. Start tunnel: `vagrant ssh cluster-control -- -N -L 6443:127.0.0.1:6443 &`


## Deploy Application and Access

Deploy sample-application on the cluster.

1. `cd ./sample-applications/sample-application`
2. `kubectl apply -f deploy/`
3. Port-forwarding:
   1. `kubectl port-forward svc/backend-service 3001:3001 -n my-website`
   2. `kubectl port-forward svc/frontend-service 8080:80 -n my-website`


## Create Registry and Deploy Application

Besides GitHub Packages, you also have the option to set up your own registry and host the container images there.

1. Setup registry in Docker ans push images: `./create-regsitry.sh`
2. `cd ./sample-applications/travel-guide`
3. Build, tag and push images in registry: `./push-in-registry.sh`
4. `kubectl apply -f deploy/`
5.  Create tunnels: 
   1. `kubectl port-forward svc/frontend 8080:80 -n my-app`
   2. `kubectl port-forward svc/backend 5003:5003 -n my-app`
