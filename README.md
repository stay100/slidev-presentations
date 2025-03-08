# Slidev Presentations

This repository contains my Slidev presentations that are automatically deployed to GitHub Pages.

## Presentations

The presentations are sourced from `/Users/scotttaylor/w1/Slides` and include:

- [advanced_presentation](./advanced_presentation/)
- [advanced_simple](./advanced_simple/)
- [liverpool-vs-southampton](./liverpool-vs-southampton/)
- [presentation1](./presentation1/)
- [presentation2](./presentation2/)

## Development

To run a presentation locally:

```bash
# Install dependencies
npm install

# Start the slide show
npm run dev -- path/to/slides.md

# Build a specific presentation
npm run build:specific -- path/to/slides.md
```

## Deployment

Presentations are automatically deployed to GitHub Pages when changes are pushed to the main branch.
The GitHub Actions workflow will build all presentations and create an index page.

Visit: https://yourusername.github.io/slidev-presentations/
