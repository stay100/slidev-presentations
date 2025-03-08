#!/bin/bash

# Script to sync slides from the Slides directory to the GitHub repository
# and manually deploy them to GitHub Pages
SLIDES_DIR="/Users/scotttaylor/w1/Slides"
SLIDE_DEV_DIR="/Users/scotttaylor/slide-dev"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Syncing Slidev presentations to GitHub...${NC}"

# Verify SSH key is loaded
if ! ssh-add -l | grep -q "SHA256:yqXOnZn9VClw/M142iYvrM8sfL2HGIw/6Z2tAwGAALI"; then
    echo "Your SSH key is not loaded in the SSH agent. Loading it now..."
    eval "$(ssh-agent -s)"
    ssh-add
fi

# Create slides directory if it doesn't exist
mkdir -p "$SLIDE_DEV_DIR/slides"

# Copy all markdown files from Slides directory
echo "Copying slides from $SLIDES_DIR to $SLIDE_DEV_DIR/slides..."
cp "$SLIDES_DIR"/*.md "$SLIDE_DEV_DIR/slides/"

# Check if there are any changes in the main branch
cd "$SLIDE_DEV_DIR" || exit
git checkout main
if git status --porcelain | grep -q .; then
    echo "Changes detected. Committing to main branch..."
    git add .
    git commit -m "Update slides: $(date +%Y-%m-%d)"
    echo "Pushing changes to GitHub main branch..."
    git push origin main
else
    echo "No changes detected in main branch."
fi

# Build the slides locally
echo -e "${BLUE}Building slides locally...${NC}"
./build-all.sh

# Deploy to GitHub Pages manually
echo -e "${BLUE}Deploying to GitHub Pages...${NC}"
git checkout gh-pages

# Clean the branch except for the dist directory
git rm -rf --cached .
rm -rf advanced_presentation liverpool-vs-southampton presentation1 presentation2 index.html .nojekyll 2>/dev/null

# Create .nojekyll file
touch dist/.nojekyll

# Copy the dist contents to the root
cp -r dist/* .
cp dist/.nojekyll .

# Add and commit changes
git add .
git commit -m "Deploy Slidev presentations to GitHub Pages: $(date +%Y-%m-%d)"

# Push to GitHub Pages
echo -e "${BLUE}Pushing to GitHub Pages...${NC}"
git push -f origin gh-pages

# Switch back to main branch
git checkout main

echo -e "${GREEN}Sync and deployment complete!${NC}"
echo -e "Your slides have been deployed to GitHub Pages."
echo -e "They will be available at: https://stay100.github.io/slidev-presentations/"
echo -e "It may take a few minutes for GitHub to process and publish your site."
