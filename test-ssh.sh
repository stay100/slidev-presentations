#!/bin/bash

# Script to test SSH connection to GitHub
# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Testing SSH connection to GitHub...${NC}"

# Verify SSH key is loaded
if ! ssh-add -l | grep -q "SHA256:yqXOnZn9VClw/M142iYvrM8sfL2HGIw/6Z2tAwGAALI"; then
    echo "Your SSH key is not loaded in the SSH agent. Loading it now..."
    eval "$(ssh-agent -s)"
    ssh-add
fi

# Test connection to GitHub
echo "Attempting to connect to GitHub via SSH..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${GREEN}SSH connection to GitHub successful!${NC}"
    echo "Your SSH key is properly configured for GitHub."
else
    echo -e "${RED}SSH connection to GitHub failed.${NC}"
    echo "Please check your SSH key configuration:"
    echo "1. Make sure your SSH key is added to your GitHub account"
    echo "2. Verify that ssh-agent is running with 'ssh-add -l'"
    echo "3. Test the connection manually with 'ssh -T git@github.com'"
fi
