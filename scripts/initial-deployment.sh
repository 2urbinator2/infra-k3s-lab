## Setup Deployment Regsitry

kubectl create namespace my-app

kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=2urbinator2 \
  --docker-password=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 \
  --docker-email=2urbinator2@gmail.com \
  -n my-app

kubectl apply -f config/backend-deployment.yaml
kubectl apply -f config/backend-service.yaml
kubectl apply -f config/frontend-deployment.yaml
kubectl apply -f config/frontend-service.yaml