#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Setting up /etc/hosts entries...${NC}"

# Get minikube IP
MINIKUBE_IP=$(minikube ip)

if [ -z "$MINIKUBE_IP" ]; then
    echo -e "${YELLOW}Could not determine minikube IP. Is minikube running?${NC}"
    exit 1
fi

echo -e "Minikube IP: ${GREEN}$MINIKUBE_IP${NC}"

# Check if entries already exist
if grep -q "fastnews.local" /etc/hosts && grep -q "api.fastnews.local" /etc/hosts; then
    echo -e "${GREEN}✓ Hosts entries already exist${NC}"
    exit 0
fi

# Prepare the hosts entries
HOSTS_ENTRY="$MINIKUBE_IP fastnews.local api.fastnews.local"

echo ""
echo -e "${YELLOW}The following entries need to be added to /etc/hosts:${NC}"
echo -e "${BLUE}$HOSTS_ENTRY${NC}"
echo ""
echo -e "${YELLOW}Please run the following command with sudo:${NC}"
echo -e "${GREEN}echo '$HOSTS_ENTRY' | sudo tee -a /etc/hosts${NC}"
echo ""
echo -e "${YELLOW}Or add these lines manually to /etc/hosts:${NC}"
echo -e "${BLUE}$MINIKUBE_IP fastnews.local${NC}"
echo -e "${BLUE}$MINIKUBE_IP api.fastnews.local${NC}" 