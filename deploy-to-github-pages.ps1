# Deploy to GitHub Pages + Heroku (Windows PowerShell)
# Run with: powershell -ExecutionPolicy Bypass -File deploy-to-github-pages.ps1

Write-Host "=========================================" -ForegroundColor Green
Write-Host "  GitHub Pages + Heroku Deployment" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Function to print colored output
function Print-Step {
    param([string]$message)
    Write-Host "[OK]" -ForegroundColor Green -NoNewline
    Write-Host " $message"
}

function Print-Warning {
    param([string]$message)
    Write-Host "[!]" -ForegroundColor Yellow -NoNewline
    Write-Host " $message"
}

function Print-Error {
    param([string]$message)
    Write-Host "[X]" -ForegroundColor Red -NoNewline
    Write-Host " $message"
}

# Step 1: Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Cyan
Write-Host ""

# Check Python
try {
    $pythonVersion = python --version 2>&1
    Print-Step "Python is installed: $pythonVersion"
} catch {
    Print-Error "Python is not installed"
    exit 1
}

# Check Git
try {
    $gitVersion = git --version 2>&1
    Print-Step "Git is installed"
} catch {
    Print-Error "Git is not installed"
    exit 1
}

# Check Heroku
try {
    $herokuVersion = heroku --version 2>&1
    Print-Step "Heroku CLI is installed"
} catch {
    Print-Warning "Heroku CLI is not installed"
    Write-Host "Install from: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor Yellow
    $response = Read-Host "Continue anyway? (y/n)"
    if ($response -ne "y" -and $response -ne "Y") {
        exit 1
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Step 1: Install Dependencies" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

pip install -r requirements.txt
Print-Step "Dependencies installed"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Step 2: Setup for Heroku" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Create Procfile if it doesn't exist
if (-not (Test-Path "Procfile")) {
    Set-Content -Path "Procfile" -Value "web: gunicorn flask_backend:app"
    Print-Step "Created Procfile"
} else {
    Print-Step "Procfile already exists"
}

# Install gunicorn
pip install gunicorn
Print-Step "Gunicorn installed"

# Update requirements.txt
pip freeze | Out-File -FilePath "requirements.txt"
Print-Step "Updated requirements.txt"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Step 3: Git Setup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Check if git repo exists
$gitDir = Test-Path ".git"
if (-not $gitDir) {
    git init
    Print-Step "Git repository initialized"
} else {
    Print-Step "Git repository already exists"
}

# Check for changes
$status = git status --porcelain
if ($status) {
    git add .
    git commit -m "Setup for Heroku deployment"
    Print-Step "Changes committed"
} else {
    Print-Step "No changes to commit"
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Step 4: Heroku Deployment" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Ask for app name
$herokuAppName = Read-Host "Enter Heroku app name (e.g., ai-learning-demo)"

if ([string]::IsNullOrEmpty($herokuAppName)) {
    Print-Error "App name cannot be empty"
    exit 1
}

# Check if app already exists
try {
    $existingApps = heroku apps --json | ConvertFrom-Json | Select-Object -ExpandProperty name
    if ($existingApps -contains $herokuAppName) {
        Print-Step "Heroku app '$herokuAppName' already exists"
    } else {
        heroku create $herokuAppName
        Print-Step "Heroku app created: $herokuAppName"
    }
} catch {
    heroku create $herokuAppName
    Print-Step "Heroku app created: $herokuAppName"
}

# Deploy to Heroku
Write-Host "Deploying to Heroku..." -ForegroundColor Yellow
git push heroku main -f 2>$null
if ($LASTEXITCODE -ne 0) {
    git push heroku master -f 2>$null
}
Print-Step "App deployed to Heroku"

# Get app URL
$herokuUrl = "https://${herokuAppName}.herokuapp.com"
Write-Host ""
Print-Step "Backend deployed at: $herokuUrl"
Write-Host ""
Write-Host "Testing Heroku deployment..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "$herokuUrl/api/health" -ErrorAction SilentlyContinue | Out-Null
if ($?) {
    Print-Step "Heroku backend is responding"
} else {
    Print-Warning "Heroku backend is still starting up. This is normal."
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Step 5: Update Frontend API URL" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Update index.html with Heroku URL
$indexHtmlPath = "index.html"
if (Test-Path $indexHtmlPath) {
    $content = Get-Content $indexHtmlPath -Raw
    $content = $content -replace "const API_BASE_URL = 'http://localhost:5000'", "const API_BASE_URL = '$herokuUrl'"
    Set-Content -Path $indexHtmlPath -Value $content
    Print-Step "Updated API URL in index.html"
} else {
    Print-Error "index.html not found"
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Step 6: GitHub Pages Setup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Ask for GitHub info
$githubUser = Read-Host "Enter your GitHub username"
$repoName = Read-Host "Enter repository name (e.g., ai-learning-tool)"

if ([string]::IsNullOrEmpty($githubUser) -or [string]::IsNullOrEmpty($repoName)) {
    Print-Error "GitHub username and repository name cannot be empty"
    exit 1
}

# Add GitHub remote
git remote remove origin 2>$null
git remote add origin "https://github.com/${githubUser}/${repoName}.git"
Print-Step "GitHub remote added"

# Commit changes
git add index.html
git commit -m "Update API URL for production" 2>$null

# Set main branch
git branch -M main 2>$null

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main -f 2>$null
if ($LASTEXITCODE -eq 0) {
    Print-Step "Code pushed to GitHub"
} else {
    Print-Error "Failed to push to GitHub"
    Write-Host "Make sure the repository exists at: https://github.com/${githubUser}/${repoName}" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "✓ Backend deployed to: $herokuUrl" -ForegroundColor Green
Write-Host "✓ Code pushed to GitHub" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT - Next steps:" -ForegroundColor Yellow
Write-Host "1. Go to https://github.com/${githubUser}/${repoName}" -ForegroundColor Cyan
Write-Host "2. Click 'Settings'" -ForegroundColor Cyan
Write-Host "3. Scroll to 'Pages' in the left menu" -ForegroundColor Cyan
Write-Host "4. Under 'Source', select 'Deploy from a branch'" -ForegroundColor Cyan
Write-Host "5. Select branch: 'main' and folder: '/ (root)'" -ForegroundColor Cyan
Write-Host "6. Click 'Save'" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your app will be live at:" -ForegroundColor Green
Write-Host "https://${githubUser}.github.io/${repoName}" -ForegroundColor Green
Write-Host ""
Write-Host "This usually takes 1-2 minutes to deploy." -ForegroundColor Yellow
Write-Host ""
Write-Host "Need help? Check RUN_AND_DEPLOY_GUIDE.md" -ForegroundColor Cyan
