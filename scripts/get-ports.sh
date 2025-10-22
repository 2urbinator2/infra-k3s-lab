#!/bin/bash

ENV_FILE="./.env"

echo "Extracting Vagrant VM port mappings..."
control_vm=$(vagrant status | awk 'NR>2 && $1 ~ /^cluster-control/ {print $1}')
worker_vm=$(vagrant status | awk 'NR>2 && $1 ~ /^cluster-worker/ {print $1}')

echo "Control VM: $control_vm"
# control_port=$(vagrant port "$control_vm" 2>/dev/null | grep '=>' | awk '{gsub(/\(|\)/,"",$4); print $4}')
control_port=$(vagrant port "$control_vm" 2>/dev/null | grep '(guest)' | head -n 1 | awk '{print $4}' | tr -d '\r\n')
worker_port=$(vagrant port "$worker_vm" 2>/dev/null | grep '=>' | awk '{gsub(/\(|\)/,"",$4); print $4}')

echo "Control Port: $control_port"
grep -q '^CONTROL_PORT=' "$ENV_FILE" && \
    sed -i '' "s/^CONTROL_PORT=.*/CONTROL_PORT=$control_port/" "$ENV_FILE" || \
    echo "CONTROL_PORT=$control_port" >> "$ENV_FILE"

grep -q '^WORKER_PORT=' "$ENV_FILE" && \
    sed -i '' "s/^WORKER_PORT=.*/WORKER_PORT=$worker_port/" "$ENV_FILE" || \
    echo "WORKER_PORT=$worker_port" >> "$ENV_FILE"
