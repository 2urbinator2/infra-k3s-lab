# K3sVMShowcase MT

![K3s Version](https://img.shields.io/badge/K3s-v1.30.0-blue)
![Vagrant](https://img.shields.io/badge/Vagrant-2.4.3-lightgrey)
![VirtualBox](https://img.shields.io/badge/VirtualBox-7.0-blue)
![Microservices](https://img.shields.io/badge/Microservices-2-orange)

## Prerequisites
- **Host:** MacOS (Not tested on other OSs)
- **Infrastructure:** VirtualBox, Vagrant, Docker
- **Configuration, Automation, Orchestration:** Ansible, Kubernetes CLI

## Get Started
1. Set-up infrastructure and deploy application: `./scripts/setup-cluster.sh` and then `./scripts/deploy-app.sh`
    - VM-commands: `vagrant ssh cluster-control`
    - K3s-commands: `kubectl get ns/po/svc`, `kubectl config use-context my-cluster`, `kubectl config get-contexts`
    - Docker-commands: `docker ps`, `docker images`
2. Stop and restart (VMs in VBox and Docker): `./scripts/startstop.sh stop` and `./scripts/startstop.sh start`
3. Destroy infrastructure and deployments: `./scripts/destroy.sh`

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