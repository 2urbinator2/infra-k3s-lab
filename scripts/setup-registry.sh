#!/bin/bash

# This script sets up a local Docker registry andregisters the local Docker registry on all K3s cluster nodes

echo "Creating local Docker registry on host machine..."
docker run -d \
  -p 0.0.0.0:5001:5000 \
  --name registry \
  --restart=always \
  -v ./registry-data:/var/lib/registry \
  registry:2

echo "Find out Host-IP and write in .env"
IP=$(ifconfig bridge100 | grep "inet " | awk '{print $2}')
grep -q "^HOST_IP=" ./.env && \
sed -i '' "s/^HOST_IP=.*/HOST_IP=$IP/" ./.env || \
echo "HOST_IP=$IP" >> ./.env

echo "Loading .env file..."
set -o allexport
source ./.env
set +o allexport

echo "Registering registry $HOST_IP:5001 on all cluster nodes..."
NODES=("cluster-control" "cluster-worker")  

for NODE in "${NODES[@]}"; do
  echo "Configuring registry on $NODE..."

  vagrant ssh $NODE -c "
    sudo mkdir -p /etc/rancher/k3s && \
    sudo tee /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  \"$HOST_IP:5001\":
    endpoint:
      - \"http://$HOST_IP:5001\"
configs:
  \"$HOST_IP:5001\":
    tls:
      insecure_skip_verify: true
EOF
  "
  echo "Configured $NODE successfully."
done

echo "Restarting K3s on control node and worker node..."
vagrant ssh cluster-control -c "sudo systemctl restart k3s"
vagrant ssh cluster-worker -c "sudo systemctl restart k3s-agent"

echo "All nodes are registered!"