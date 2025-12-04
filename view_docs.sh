#!/bin/bash
# Open gooseR documentation in browser

echo "🦆 Opening gooseR documentation..."

# Check if index exists
if [ -f "docs/articles/index.html" ]; then
    # Try to open in default browser
    if command -v open &> /dev/null; then
        # macOS
        open "docs/articles/index.html"
    elif command -v xdg-open &> /dev/null; then
        # Linux
        xdg-open "docs/articles/index.html"
    elif command -v start &> /dev/null; then
        # Windows
        start "docs/articles/index.html"
    else
        echo "Could not detect system browser command."
        echo "Please open manually: docs/articles/index.html"
    fi
    echo "✅ Documentation opened in browser"
else
    echo "❌ Documentation not found. Run build_vignettes.R first."
fi
