#!/bin/bash

docker compose up --build

docker tag travel-guide-backend:latest localhost:5001/travel-guide-backend:latest

docker tag travel-guide-frontend:latest localhost:5001/travel-guide-Frontend:latest