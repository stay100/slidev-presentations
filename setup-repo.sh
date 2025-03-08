#!/bin/bash

# Script to set up a GitHub repository for Slidev presentations
# and push the initial content

# Configuration
REPO_NAME="slidev-presentations"
SLIDES_DIR="/Users/scotttaylor/w1/Slides"
SLIDE_DEV_DIR="/Users/scotttaylor/slide-dev"
GITHUB_USERNAME="stay100" # GitHub username

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up GitHub repository for Slidev presentations...${NC}"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Please install git first."
    exit 1
fi

# Initialize git repository if not already initialized
if [ ! -d "$SLIDE_DEV_DIR/.git" ]; then
    echo "Initializing git repository..."
    cd "$SLIDE_DEV_DIR" || exit
    git init
    git branch -M main
else
    echo "Git repository already initialized."
    cd "$SLIDE_DEV_DIR" || exit
fi

# Create .gitignore
echo "Creating .gitignore file..."
cat > .gitignore << EOF
node_modules/
dist/
.DS_Store
*.log
EOF

# Create a README.md file
echo "Creating README.md file..."
cat > README.md << EOF
# Slidev Presentations

This repository contains my Slidev presentations that are automatically deployed to GitHub Pages.

## Presentations

The presentations are sourced from \`$SLIDES_DIR\` and include:

$(for file in "$SLIDES_DIR"/*.md; do
    filename=$(basename "$file" .md)
    echo "- [$filename](./$filename/)"
done)

## Development

To run a presentation locally:

\`\`\`bash
# Install dependencies
npm install

# Start the slide show
npm run dev -- path/to/slides.md

# Build a specific presentation
npm run build:specific -- path/to/slides.md
\`\`\`

## Deployment

Presentations are automatically deployed to GitHub Pages when changes are pushed to the main branch.
The GitHub Actions workflow will build all presentations and create an index page.

Visit: https://yourusername.github.io/$REPO_NAME/
EOF

# Create a sync-slides script
echo "Creating sync-slides script..."
cat > sync-slides.sh << EOF
#!/bin/bash

# Script to sync slides from the Slides directory to the GitHub repository
SLIDES_DIR="$SLIDES_DIR"
SLIDE_DEV_DIR="$SLIDE_DEV_DIR"

# Verify SSH key is loaded
if ! ssh-add -l | grep -q "SHA256:yqXOnZn9VClw/M142iYvrM8sfL2HGIw/6Z2tAwGAALI"; then
    echo "Your SSH key is not loaded in the SSH agent. Loading it now..."
    eval "$(ssh-agent -s)"
    ssh-add
fi

# Create slides directory if it doesn't exist
mkdir -p "\$SLIDE_DEV_DIR/slides"

# Copy all markdown files from Slides directory
echo "Copying slides from \$SLIDES_DIR to \$SLIDE_DEV_DIR/slides..."
cp "\$SLIDES_DIR"/*.md "\$SLIDE_DEV_DIR/slides/"

# Check if there are any changes
cd "\$SLIDE_DEV_DIR" || exit
if git status --porcelain | grep -q .; then
    echo "Changes detected. Committing..."
    git add .
    git commit -m "Update slides: \$(date +%Y-%m-%d)"
    echo "Pushing changes to GitHub..."
    git push origin main
else
    echo "No changes detected."
fi

echo "Sync complete!"
EOF

# Make the script executable
chmod +x sync-slides.sh

# Create slides directory and copy current slides
mkdir -p "$SLIDE_DEV_DIR/slides"
echo "Copying slides from $SLIDES_DIR to $SLIDE_DEV_DIR/slides..."
cp "$SLIDES_DIR"/*.md "$SLIDE_DEV_DIR/slides/"

echo -e "${GREEN}Setup complete!${NC}"
echo -e "Next steps:"
echo -e "1. Create a new repository on GitHub named '$REPO_NAME'"
echo -e "2. Run the following commands to push your repository:"
echo -e "   cd $SLIDE_DEV_DIR"
echo -e "   git add ."
echo -e "   git commit -m \"Initial commit\""
echo -e "   git remote add origin git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
echo -e "   git push -u origin main"
echo -e "3. Enable GitHub Pages in your repository settings (Settings > Pages)"
echo -e "   - Set source to 'GitHub Actions'"
echo -e "4. To sync your slides in the future, run: ./sync-slides.sh"
