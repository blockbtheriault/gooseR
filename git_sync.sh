#!/bin/bash
# git_sync.sh - Quick GitHub synchronization for gooseR development

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== gooseR GitHub Sync ===${NC}"

# Check if we're in the right directory
if [ ! -f "DESCRIPTION" ] || [ ! -d "R" ]; then
    echo -e "${RED}Error: Not in gooseR directory!${NC}"
    echo "Please run from /Users/btheriault/Documents/R/gooseR"
    exit 1
fi

# Function to check status
check_status() {
    echo -e "\n${YELLOW}Current Status:${NC}"
    git status --short
    
    # Count uncommitted changes
    CHANGES=$(git status --short | wc -l | tr -d ' ')
    if [ "$CHANGES" -gt 0 ]; then
        echo -e "${YELLOW}You have $CHANGES uncommitted changes${NC}"
    else
        echo -e "${GREEN}Working directory clean${NC}"
    fi
}

# Function to sync with GitHub
sync_github() {
    echo -e "\n${YELLOW}Syncing with GitHub...${NC}"
    
    # Fetch latest
    git fetch origin
    
    # Check if we're behind
    BEHIND=$(git rev-list HEAD..origin/main_branch --count)
    if [ "$BEHIND" -gt 0 ]; then
        echo -e "${YELLOW}You are $BEHIND commits behind GitHub${NC}"
        read -p "Pull latest changes? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git pull origin main_branch
        fi
    else
        echo -e "${GREEN}Already up to date with GitHub${NC}"
    fi
    
    # Check if we're ahead
    AHEAD=$(git rev-list origin/main_branch..HEAD --count)
    if [ "$AHEAD" -gt 0 ]; then
        echo -e "${YELLOW}You are $AHEAD commits ahead of GitHub${NC}"
        read -p "Push to GitHub? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push origin main_branch
            echo -e "${GREEN}Pushed to GitHub successfully${NC}"
        fi
    fi
}

# Function to quick commit
quick_commit() {
    if [ "$1" == "" ]; then
        echo -e "${RED}Please provide a commit message${NC}"
        echo "Usage: ./git_sync.sh commit \"your message\""
        return
    fi
    
    echo -e "\n${YELLOW}Committing changes...${NC}"
    git add .
    git commit -m "$1"
    echo -e "${GREEN}Committed successfully${NC}"
    
    read -p "Push to GitHub now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin main_branch
        echo -e "${GREEN}Pushed to GitHub${NC}"
    fi
}

# Main menu
if [ "$1" == "commit" ]; then
    quick_commit "$2"
elif [ "$1" == "status" ]; then
    check_status
elif [ "$1" == "sync" ]; then
    sync_github
elif [ "$1" == "help" ]; then
    echo "Usage:"
    echo "  ./git_sync.sh          - Interactive sync"
    echo "  ./git_sync.sh status   - Check current status"
    echo "  ./git_sync.sh sync     - Sync with GitHub"
    echo "  ./git_sync.sh commit \"message\" - Quick commit and push"
    echo "  ./git_sync.sh help     - Show this help"
else
    # Interactive mode
    check_status
    echo
    echo "What would you like to do?"
    echo "1) Sync with GitHub"
    echo "2) Commit changes"
    echo "3) Just check status"
    echo "4) Exit"
    
    read -p "Choice (1-4): " choice
    
    case $choice in
        1)
            sync_github
            ;;
        2)
            read -p "Commit message: " msg
            quick_commit "$msg"
            ;;
        3)
            check_status
            ;;
        4)
            echo -e "${GREEN}Goodbye!${NC}"
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
fi

echo -e "\n${GREEN}Done!${NC}"
echo -e "${YELLOW}Remember: Commit often, push frequently!${NC}"
