#!/bin/bash
# Deploy to GitHub Pages + Heroku
# Mac/Linux script

set -e  # Exit on error

echo "========================================="
echo "  GitHub Pages + Heroku Deployment"
echo "========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'  # No Color

# Function to print colored output
print_step() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Step 1: Check prerequisites
echo "Checking prerequisites..."
echo ""

if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed"
    exit 1
fi
print_step "Python 3 is installed"

if ! command -v git &> /dev/null; then
    print_error "Git is not installed"
    exit 1
fi
print_step "Git is installed"

if ! command -v heroku &> /dev/null; then
    print_warning "Heroku CLI is not installed"
    echo "Install from: https://devcenter.heroku.com/articles/heroku-cli"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_step "Heroku CLI is installed"
fi

echo ""
echo "========================================="
echo "  Step 1: Install Dependencies"
echo "========================================="

pip3 install -r requirements.txt
print_step "Dependencies installed"

echo ""
echo "========================================="
echo "  Step 2: Setup for Heroku"
echo "========================================="

# Create Procfile if it doesn't exist
if [ ! -f "Procfile" ]; then
    echo "web: gunicorn flask_backend:app" > Procfile
    print_step "Created Procfile"
else
    print_step "Procfile already exists"
fi

# Install gunicorn
pip3 install gunicorn
print_step "Gunicorn installed"

# Update requirements.txt
pip3 freeze > requirements.txt
print_step "Updated requirements.txt"

echo ""
echo "========================================="
echo "  Step 3: Git Setup"
echo "========================================="

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    git init
    print_step "Git repository initialized"
else
    print_step "Git repository already exists"
fi

# Check if there are changes to commit
if ! git diff-index --quiet HEAD --; then
    git add .
    git commit -m "Setup for Heroku deployment"
    print_step "Changes committed"
else
    print_step "No changes to commit"
fi

echo ""
echo "========================================="
echo "  Step 4: Heroku Deployment"
echo "========================================="

# Ask for app name
read -p "Enter Heroku app name (e.g., ai-learning-demo): " heroku_app_name

if [ -z "$heroku_app_name" ]; then
    print_error "App name cannot be empty"
    exit 1
fi

# Check if app already exists
if heroku apps | grep -q "^$heroku_app_name$"; then
    print_step "Heroku app '$heroku_app_name' already exists"
else
    heroku create "$heroku_app_name"
    print_step "Heroku app created: $heroku_app_name"
fi

# Deploy to Heroku
git push heroku main || git push heroku master
print_step "App deployed to Heroku"

# Get app URL
heroku_url="https://${heroku_app_name}.herokuapp.com"
echo ""
print_step "Backend deployed at: $heroku_url"

echo ""
echo "========================================="
echo "  Step 5: Update Frontend API URL"
echo "========================================="

# Update index.html with Heroku URL
sed -i.bak "s|const API_BASE_URL = 'http://localhost:5000'|const API_BASE_URL = '$heroku_url'|g" index.html
rm -f index.html.bak
print_step "Updated API URL in index.html"

echo ""
echo "========================================="
echo "  Step 6: GitHub Pages Setup"
echo "========================================="

# Ask for GitHub info
read -p "Enter your GitHub username: " github_user
read -p "Enter repository name (e.g., ai-learning-tool): " repo_name

if [ -z "$github_user" ] || [ -z "$repo_name" ]; then
    print_error "GitHub username and repository name cannot be empty"
    exit 1
fi

# Add GitHub remote
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${github_user}/${repo_name}.git"
print_step "GitHub remote added"

# Commit changes
git add index.html
git commit -m "Update API URL for production"

# Push to GitHub
git branch -M main
git push -u origin main
print_step "Code pushed to GitHub"

echo ""
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "✓ Backend deployed to: $heroku_url"
echo "✓ Code pushed to GitHub"
echo ""
echo "Next steps:"
echo "1. Go to https://github.com/${github_user}/${repo_name}"
echo "2. Click Settings → Pages"
echo "3. Under 'Source', select 'main' branch"
echo "4. Click Save"
echo ""
echo "Your app will be live at:"
echo "https://${github_user}.github.io/${repo_name}"
echo ""
echo "This usually takes 1-2 minutes to deploy."
echo ""
