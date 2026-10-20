#!/bin/bash

docker run -d -p 5000:5001 --restart=always --name local-registry registry:2

for vm in $(vagrant status | grep running | awk '{print $1}'); do
  vagrant ssh $vm -c "
    sudo mkdir -p /etc/rancher/k3s && \
    echo -e 'mirrors:\n  \"192.168.56.1:5001\":\n    endpoint:\n      - \"http://192.168.56.1:5001\"' | sudo tee /etc/rancher/k3s/registries.yaml > /dev/null && \
    if systemctl list-units --full --all | grep -q 'k3s-agent.service'; then
      sudo systemctl restart k3s-agent
    else
      sudo systemctl restart k3s
    fi
  "
done



