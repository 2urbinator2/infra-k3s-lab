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
 




    - Open in Browser: `open "http://localhost:30080"` and `open "http://localhost:31000/quote"`
    - Stop in Browser: 


and then `./scripts/deploy-app.sh`


## Further Settings
3. Deploy changes to the cluster: `./scripts/deploy-changes.sh`
4. Stop and restart (VMs in VBox and Docker): `./scripts/startstop.sh stop` and `./scripts/startstop.sh start`
5. Destroy infrastructure and deployments: `./scripts/destroy.sh all`
6.  Information about the application: `cd/applications/berlin-travel-guide`

## Project Summary
### 1. Create VMs with Vagrantfile
- Two virtual machines called `cluster-control` and `cluster-worker` are created using `Ubuntu 24.04`
- Connects the VM’s to the VirtualBox `NAT network` named `NatNetwork`
- Each VM also gets a `Host-Only-network` for direct communication with the host.
- For the `cluster-control` VM, two port forwardings are configured so that the application can be accessed and viewed in the browser of the host

### 2. Deploy K3s with Ansible and Set Kubernetes CLI
- Central script to discover ports, deploy K3s, and set up central cluster management: `scripts/setup-cluster.sh`
- The port number for the inventory file is written directly into the `.env` via a script: `scripts-ports.sh`
- Directly via the Vagrant file, K3s is deployed on the 2 VMs: `config/k3s-setup.yml`
- Configuration files are applied via the Kubernetes CLI and set as the current cluster: `config/cluster-management.yml`

### 3. Create Registry in Docker and Register Nodes
- A Docker registry is created and all cluster nodes are registered: `/scripts/setup-registry.sh`

### 4. Deploy Application on the Cluster
- The application's **frontend** is built with **HTML**, and the **backend** is written in **Python**.
- The two services of the application are located under `my-app`
- A registry is created in Docker: `scripts/setup-cluster.sh`