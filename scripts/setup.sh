#!/bin/bash

set -e

echo "🚀 FastNews Setup Script"
echo "========================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if minikube is running
echo -e "${BLUE}Checking minikube status...${NC}"
if ! minikube status &> /dev/null; then
    echo -e "${YELLOW}Starting minikube...${NC}"
    minikube start --driver=docker
else
    echo -e "${GREEN}✓ Minikube is already running${NC}"
fi

# Enable Traefik addon
echo -e "${BLUE}Enabling Traefik ingress...${NC}"
minikube addons enable ingress

# Use minikube's Docker daemon
echo -e "${BLUE}Setting up Docker environment...${NC}"
eval $(minikube docker-env)

# Build Docker images
echo -e "${BLUE}Building Docker images...${NC}"

echo "Building backend image..."
cd ../backend
docker build -t fastnews-backend:latest .

echo "Building frontend image..."
cd ../frontend
docker build -t fastnews-frontend:latest .

cd ../scripts

echo -e "${GREEN}✓ Docker images built successfully${NC}"

# Deploy to Kubernetes
echo -e "${BLUE}Deploying to Kubernetes...${NC}"
./deploy.sh

# Setup hosts file
echo -e "${BLUE}Setting up hosts file...${NC}"
./hosts-setup.sh

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Setup complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}To access the application:${NC}"
echo -e "  Frontend: ${BLUE}http://fastnews.local${NC}"
echo -e "  Backend API: ${BLUE}http://api.fastnews.local${NC}"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo -e "  Check pods: ${BLUE}kubectl get pods -n fastnews${NC}"
echo -e "  Check services: ${BLUE}kubectl get svc -n fastnews${NC}"
echo -e "  View logs: ${BLUE}kubectl logs -f <pod-name> -n fastnews${NC}"
echo "" 