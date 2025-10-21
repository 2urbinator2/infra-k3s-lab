#!/bin/bash

# This script automates the deployment of the application on the K3s cluster

echo "Setting up local Docker registry on host machine..."



# 1. Build Images: 
#       1. `cd my-app/frontend` with `docker build -t frontend:latest .` 
#       2. `cd ../backend` with `docker build -t backend:latest .`
#       3. `cd ../..`
#    2. Tag Images: `docker tag frontend:latest 192.168.56.3:5001/frontend:latest` and `docker tag backend:latest 192.168.56.3:5001/backend:latest`
#    3. Push Images: `docker push 192.168.56.3:5001/frontend:latest` and `docker push 192.168.56.3:5001/backend:latest`
#       1. Check Registry with: `curl http://192.168.56.3:5001/v2/_catalog`
#    4. Deploy Application on the Cluster: 
