#!/bin/bash

# Script to sync slides from the Slides directory to the GitHub repository
SLIDES_DIR="/Users/scotttaylor/w1/Slides"
SLIDE_DEV_DIR="/Users/scotttaylor/slide-dev"

# Verify SSH key is loaded
if ! ssh-add -l | grep -q "SHA256:yqXOnZn9VClw/M142iYvrM8sfL2HGIw/6Z2tAwGAALI"; then
    echo "Your SSH key is not loaded in the SSH agent. Loading it now..."
    eval "SSH_AUTH_SOCK=/var/folders/0j/m6356m295f3f0pkhplzsljf00000gn/T//ssh-m4rQ9iPNecX4/agent.44593; export SSH_AUTH_SOCK;
SSH_AGENT_PID=44594; export SSH_AGENT_PID;
echo Agent pid 44594;"
    ssh-add
fi

# Create slides directory if it doesn't exist
mkdir -p "$SLIDE_DEV_DIR/slides"

# Copy all markdown files from Slides directory
echo "Copying slides from $SLIDES_DIR to $SLIDE_DEV_DIR/slides..."
cp "$SLIDES_DIR"/*.md "$SLIDE_DEV_DIR/slides/"

# Check if there are any changes
cd "$SLIDE_DEV_DIR" || exit
if git status --porcelain | grep -q .; then
    echo "Changes detected. Committing..."
    git add .
    git commit -m "Update slides: $(date +%Y-%m-%d)"
    echo "Pushing changes to GitHub..."
    git push origin main
else
    echo "No changes detected."
fi

echo "Sync complete!"
