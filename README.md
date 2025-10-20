# K3sVMShowcase MT

![K3s Version](https://img.shields.io/badge/K3s-v1.30.0-blue)
![Vagrant](https://img.shields.io/badge/Vagrant-2.4.3-lightgrey)
![VirtualBox](https://img.shields.io/badge/VirtualBox-7.0-blue)
![Microservices](https://img.shields.io/badge/Microservices-2-orange)

## Prerequisites
- **Host:** MacOS (Not tested on other OSs)
- **Infrastructure:** VirtualBox, Vagrant, Docker
- **Configuration, Automation, Orchestration:** Ansible, Kubernetes CLI, Skaffold 

## Get Started
1. Creation of the infrastructure and cluster setup: `./scripts/setup-cluster.sh`
2. Deploy Application on the Cluster:
   1. Build Images: 
      1. `cd my-app/frontend` with `docker build -t frontend:latest .` 
      2. `cd ../backend` with `docker build -t backend:latest .`
      3. `cd ../..`
   2. Tag Images: `docker tag frontend:latest 192.168.56.3:5001/frontend:latest` and `docker tag backend:latest 192.168.56.3:5001/backend:latest`
   3. Push Images: `docker push 192.168.56.3:5001/frontend:latest` and `docker push 192.168.56.3:5001/backend:latest`
      1. Check Registry with: `curl http://192.168.56.3:5001/v2/_catalog`
   4. Deploy Application on the Cluster: 


kubectl apply -f config/frontend-deployment.yaml
kubectl apply -f config/backend-deployment.yaml

localhost

## Destroy Everything
- Execute: `./scripts/destroy.sh`

## Project Summary
### 1. Create VMs with Vagrantfile
- Two virtual machines are created using Ubuntu 24.04 (control-1 and worker-1)
- Connects the VM’s to the VirtualBox NAT network named NatNetwork
- Each VM also gets a Host-Only network for direct communication with the host.
```bash
vagrant status
vagrant destroy
vagrant ssh <vm_name>
```

### 2. Deploy K3s with Ansible and Set Kubernetes CLI
- Central script to discover ports, deploy K3s, and set up central cluster management: `scripts/setup-cluster.sh`
- The port number for the inventory file is written directly into the `.env` via a script: `scripts-ports.sh`
- Directly via the Vagrant file, K3s is deployed on the 2 VMs: `config/k3s-setup.yml`
- Configuration files are applied via the Kubernetes CLI and set as the current cluster: `config/cluster-management.yml`
```bash
ls ~/.kube/cs-cluster
nano ~/.kube/cs-cluster/my-cluster.yml
rm -rf ~/.kube/cs-cluster
kubectl config use-context my-cluster
kubectl config get-contexts
```

### 3. Create Registry in Docker
- A Docker registry is created in `/scripts/setup-cluster.sh`
- All cluster nodes are registered with `register-registry.sh`

### 4. Deploy Application on the Cluster
- The application's **frontend** is built with **HTML**, and the **backend** is written in **Python**.
- The two services of the application are located under `my-app`
- A registry is created in Docker: `scripts/setup-cluster.sh`
```bash
docker ps 
docker images
curl http://localhost:5001/v2/_catalog # Could also be tested from the VMs 
ifconfig bridge100 | grep "inet " | awk '{print $2}'
```