# K3sVMShowcase MT

![K3s Version](https://img.shields.io/badge/K3s-v1.30.0-blue)
![Vagrant](https://img.shields.io/badge/Vagrant-2.4.3-lightgrey)
![VirtualBox](https://img.shields.io/badge/VirtualBox-7.0-blue)
![Microservices](https://img.shields.io/badge/Microservices-2-orange)

## Prerequisites
- **Infrastructure:** VirtualBox, Vagrant, Docker
- **Configuration, Automation, Orchestration:** Ansible, Kubernetes CLI, Skaffold 

## Get Started
1. Creation of the infrastructure and cluster setup: `./scripts/setup-cluster.sh`
2. Deploy Application on the Cluster:
   1. Build Images: 
      1. `cd my-app/frontend` with `docker build -t frontend:latest .` 
      2. `cd ../backend` with `docker build -t backend:latest .`
      3. `cd ../..`
   2. Tag Images: `docker tag frontend:latest localhost:5001/frontend:latest` and `docker tag backend:latest localhost:5001/backend:latest`
   3. Push Images: `docker push localhost:5001/frontend:latest` and `docker push localhost:5001/backend:latest`
      1. Check Registry with: `curl http://localhost:5001/v2/_catalog`


localhost

## Destroy Everything
- Execute: `./scripts/destroy.sh`






```bash
# 1. Prepare Cluster
./setup.sh get_ports

# 2. Login to Registry 
docker login ghcr.io -u <github-username>

# 3. Deploy application on cluster 
skaffold run

# Start and stop port-forwarding application
kubectl port-forward service/backend-service 5000:5000 -n my-app &
kubectl port-forward service/frontend-service 8080:80 -n my-app &

kill %1
kill %2
```



## Changes in the application
```bash 
# Every Change is immidiately live 
skaffold dev
```


hier noch prüfen
## Container -> Registry
```bash
# Build Images
docker build -t frontend:1.0 .
docker build -t backend:1.0 .

# Globales Taggen der Images 
docker tag frontend:1.0 ghcr.io/2urbinator2/frontend:1.0
docker tag backend:1.0 ghcr.io/2urbinator2/backend:1.0 

# GHCR Push
docker push ghcr.io/2urbinator2/backend:1.0
docker push ghcr.io/2urbinator2/frontend:1.0
```

## Registry -> Cluster 
1. Namespace with secret
2. apply 



## Changes (manuel)
docker build -t ghcr.io/2urbinator2/backend:1.1 ./my-app/backend
docker build -t ghcr.io/2urbinator2/frontend:1.1 ./my-app/frontend

docker push ghcr.io/2urbinator2/backend:1.1
docker push ghcr.io/2urbinator2/frontend:1.1

kubectl set image deployment/backend backend=ghcr.io/2urbinator2/backend:1.1 -n my-app
kubectl set image deployment/frontend frontend=ghcr.io/2urbinator2/frontend:1.1 -n my-app

kubectl set image deployment/backend backend=ghcr.io/2urbinator2/backend:1.1 -n my-app
kubectl set image deployment/frontend frontend=ghcr.io/2urbinator2/frontend:1.1 -n my-app



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

### 3. Create Registry in Docker and Deploy 
- The application's **frontend** is built with **HTML**, and the **backend** is written in **Python**.
- The two services of the application are located under `my-app`
- A registry is created in Docker: `scripts/setup-cluster.sh`
```bash
docker ps 
docker images
curl http://localhost:5001/v2/_catalog # Could also be tested from the VMs 
```


