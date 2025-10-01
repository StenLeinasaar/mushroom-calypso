#!/bin/bash

set -e

echo "📦 Deploying FastNews to Kubernetes"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create namespace
echo -e "${BLUE}Creating namespace...${NC}"
kubectl apply -f ../k8s/namespace.yaml

# Deploy database
echo -e "${BLUE}Deploying PostgreSQL database...${NC}"
kubectl apply -f ../database/k8s/configmap.yaml
kubectl apply -f ../database/k8s/pvc.yaml
kubectl apply -f ../database/k8s/statefulset.yaml
kubectl apply -f ../database/k8s/service.yaml

# Wait for database to be ready
echo -e "${BLUE}Waiting for database to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=postgres -n fastnews --timeout=120s

# Deploy backend
echo -e "${BLUE}Deploying backend API...${NC}"
kubectl apply -f ../backend/k8s/deployment.yaml
kubectl apply -f ../backend/k8s/service.yaml

# Wait for backend to be ready
echo -e "${BLUE}Waiting for backend to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=backend -n fastnews --timeout=120s

# Deploy frontend
echo -e "${BLUE}Deploying frontend...${NC}"
kubectl apply -f ../frontend/k8s/deployment.yaml
kubectl apply -f ../frontend/k8s/service.yaml

# Wait for frontend to be ready
echo -e "${BLUE}Waiting for frontend to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=frontend -n fastnews --timeout=120s

# Deploy Traefik IngressRoute
echo -e "${BLUE}Deploying Traefik IngressRoutes...${NC}"
kubectl apply -f ../k8s/traefik/ingressroute.yaml

echo ""
echo -e "${GREEN}✓ Deployment complete!${NC}"
echo ""
echo "Current pod status:"
kubectl get pods -n fastnews
echo ""
echo "Current services:"
kubectl get svc -n fastnews 