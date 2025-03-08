#!/bin/bash

# Script to build all Slidev presentations locally
SLIDES_DIR="/Users/scotttaylor/w1/Slides"
OUTPUT_DIR="dist"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Building all Slidev presentations...${NC}"

# Make sure we have the dependencies installed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Build each slide
for slide in "$SLIDES_DIR"/*.md; do
    slidename=$(basename "$slide" .md)
    echo -e "${BLUE}Building $slidename...${NC}"
    npx slidev build "$slide" --base "/slidev-presentations/$slidename/" --out "$OUTPUT_DIR/$slidename"
done

# Create index page
echo "Creating index page..."
cat > "$OUTPUT_DIR/index.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Slidev Presentations</title>
    <style>
        body {
            font-family: system-ui, -apple-system, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        h1 {
            border-bottom: 1px solid #eee;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            margin: 1rem 0;
            padding: 1rem;
            border: 1px solid #eee;
            border-radius: 8px;
        }
        a {
            color: #3b82f6;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Slidev Presentations</h1>
    <ul>
EOF

# Add links to each presentation
for dir in "$OUTPUT_DIR"/*/; do
    dirname=$(basename "$dir")
    echo "        <li><a href=\"./$dirname/\">$dirname</a></li>" >> "$OUTPUT_DIR/index.html"
done

# Close HTML tags
cat >> "$OUTPUT_DIR/index.html" << EOF
    </ul>
</body>
</html>
EOF

echo -e "${GREEN}Build complete!${NC}"
echo -e "You can preview the site by serving the dist directory:"
echo -e "npx serve dist"
