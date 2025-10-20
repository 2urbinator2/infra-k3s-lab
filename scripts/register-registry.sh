#!/bin/bash

# Find out Host-Ports and write in .env
echo "Find out Host-IP and write in .env"
IP=$(ifconfig bridge100 | grep "inet " | awk '{print $2}')
grep -q "^HOST_IP=" ../.env && \
sed -i '' "s/^HOST_IP=.*/HOST_IP=$IP/" ../.env || \
echo "HOST_IP=$IP" >> ../.env

# .env laden
set -o allexport
source ../.env
set +o allexport

# Liste of all cluster nodes
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

echo "Restarting K3s on control node..."
vagrant ssh cluster-control -c "sudo systemctl restart k3s"

echo "All nodes are registered!"
