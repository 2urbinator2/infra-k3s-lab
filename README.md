# K3sVMShowcase MT

![K3s Version](https://img.shields.io/badge/K3s-v1.30.0-blue)
![Vagrant](https://img.shields.io/badge/Vagrant-2.4.3-lightgrey)
![VirtualBox](https://img.shields.io/badge/VirtualBox-7.0-blue)
![Microservices](https://img.shields.io/badge/Microservices-2-orange)


## Prerequisites
- **Infrastructure:** VirtualBox, Vagrant
- **Configuration Management:** Ansible 



- , 
- Skafford 
- Kubernetes CLI



ip addr show enp0s9

## Create Infrastructure and Deploy K3s
```bash 
# 1. Create the infrastructure
vagrant up

# 2. Install K3s on the clusters
./setup.sh get ports # Fill out port variables in .env
./setup.sh setup_cluster 

# (Optional:) Check on control VM if cluster is working
vagrant ssh cluster-control
sudo k3s kubectl get nodes -o wide # Check whether nodes are shown
exit

# (Optional:) Check if cluster management is working
kubectl get ns # Should give you some ns
```

## Application Deployment on the Cluster
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


# To-do:
- Simplifie some functions
- add a description 
- test everything



### Create VMs with Vagrantfile
- Two virtual machines are created using Ubuntu 24.04 (control-1 and worker-1)
- Connects the VM’s to the VirtualBox NAT network named NatNetwork
- Each VM also gets a Host-Only network for direct communication with the host.

### Deploy K3s with Ansible 