#!/bin/bash

# .env laden
set -o allexport
source ../.env
set +o allexport

# Find out Host-Ports and write in .env
echo "Find out Host-IP and write in .env"
IP=$(ifconfig bridge100 | grep "inet " | awk '{print $2}')
grep -q "^HOST_IP=" ../.env && \
sed -i '' "s/^HOST_IP=.*/HOST_IP=$IP/" ../.env || \
echo "HOST_IP=$IP" >> ../.env

# echo "Die HOST_IP ist: $HOST_IP"

#!/bin/bash

# Host-IP der Registry
REGISTRY_IP="192.168.56.1"
REGISTRY_PORT="5001"

# Liste of all cluster nodes
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
EOF
    sudo systemctl restart k3s
  "

  echo "Configured $NODE"
done

echo "All nodes are registered!"
