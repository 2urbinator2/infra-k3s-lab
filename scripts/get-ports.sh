#!/bin/bash

# This script retrieves the host ports for the Vagrant VMs

ENV_FILE="./.env"

# Extract VM names
control_vm=$(vagrant status | awk 'NR>2 && $1 ~ /^cluster-control/ {print $1}')
worker_vm=$(vagrant status | awk 'NR>2 && $1 ~ /^cluster-worker/ {print $1}')

# Extract host ports
control_port=$(vagrant port "$control_vm" 2>/dev/null | grep '=>' | awk '{gsub(/\(|\)/,"",$4); print $4}')
worker_port=$(vagrant port "$worker_vm" 2>/dev/null | grep '=>' | awk '{gsub(/\(|\)/,"",$4); print $4}')

# Write to .env file
grep -q '^CONTROL_PORT=' "$ENV_FILE" && \
    sed -i "s/^CONTROL_PORT=.*/CONTROL_PORT=$control_port/" "$ENV_FILE" || \
    echo "CONTROL_PORT=$control_port" >> "$ENV_FILE"

grep -q '^WORKER_PORT=' "$ENV_FILE" && \
    sed -i "s/^WORKER_PORT=.*/WORKER_PORT=$worker_port/" "$ENV_FILE" || \
    echo "WORKER_PORT=$worker_port" >> "$ENV_FILE"
