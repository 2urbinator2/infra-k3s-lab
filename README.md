# K3sVMShowcase MT - Berlin Travel Guide

![Experimental Setup](https://img.shields.io/badge/Experimental-Setup-1563FF?style=flat)
![K3s Cluster](https://img.shields.io/badge/K3s-Cluster-4BC51D?logo=kubernetes&logoColor=white)
![Vagrant Setup](https://img.shields.io/badge/Vagrant-Automation-1563FF?logo=vagrant&logoColor=white)
![VirtualBox VMs](https://img.shields.io/badge/VirtualBox-2%20VMs-183A61?logo=virtualbox&logoColor=white)
![Microservices](https://img.shields.io/badge/Microservices-2-orange?logo=containers&logoColor=white)

This project deploys a simple Berlin Travel Guide consisting of two microservices: the frontend, which displays a random Berlin attraction, and the backend, which provides the attractions through an API. It runs on a lightweight K3s cluster distributed across two VirtualBox VMs, automatically set up using Vagrant. The goal is to achieve a fully automated deployment, allowing the application to run smoothly with minimal manual configuration.

## Prerequisites
- **Host:** MacOS
- **Infrastructure:** VirtualBox, Vagrant, Docker
- **Configuration, Automation, Orchestration:** Ansible, Kubernetes CLI

## Get Started
1. Create and setup infrastructure: `./scripts/setup-cluster.sh` 
2. Set-up registry: `./scripts/setup-registry.sh`
3. Deploy application on the cluster: `./scripts/deploy.sh initial`
4. Open Backend `open "http://localhost:31000/quote"` and Frontend `open "http://localhost:30080"`
 
## Further Settings
1. Deploy changes: `./scripts/destroy.sh app` and `./scripts/deploy.sh initial`
2. Stop and restart: `./scripts/startstop.sh stop` and `./scripts/startstop.sh start`
3. Destroy infrastructure and deployments: `./scripts/destroy.sh all`
4. Further information about the application in `applications/berlin-travel-guide`

## Project Summary
### 1. Create VMs with Vagrantfile
- Two virtual machines called `cluster-control` and `cluster-worker` are created with `Vagrant` using `Ubuntu 24.04`.
- In addition to `NAT` on `NIC1`, a `NAT network` is configured on `NIC2` and a `host-only network` is set up on `NIC3` for each instance.
- For the cluster-control VM, `two additional port forwardings` are configured so that the application can be accessed and viewed in the host's browser.

### 2. Deploy K3s with Ansible and Set Up Central Cluster-Management
- Central script to deploy K3s, and set up central cluster management: `scripts/setup-cluster.sh`
- The port number for the inventory file is written directly into the `.env` via a script: `scripts-ports.sh`
- K3s is deployed on the 2 VMs with `inventory.yaml` and `config/k3s-setup.yml` via `Ansible`
- Configuration management is set up via `Ansible` using `inventory.yaml` and `config/cluster-management.yml`

### 3. Create Registry in Docker and Register Nodes
- A Docker registry is created, and all cluster nodes are registered: `/scripts/setup-registry.sh`

### 4. Deploy Application on the Cluster
- More information about the application are in `applications/berlin-travel-guide`
- Images are build, tagged and pushed in the registry: `./scripts/deploy.sh initial`
- In the config folder, you can find all deployments files