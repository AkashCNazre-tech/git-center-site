# 🚀 COMPLETE RUN & DEPLOYMENT GUIDE

## Part 1: Local Development Setup & Running

### Prerequisites Check

```bash
# 1. Verify Python is installed
python --version
# Should show: Python 3.8 or higher

# 2. Verify pip is working
pip --version
# Should show pip version
```

### Step-by-Step Local Setup

#### Step 1: Navigate to Project Directory
```bash
# Windows (Command Prompt or PowerShell)
cd C:\Users\USER\OneDrive\Desktop\ai-learning-too

# Mac/Linux (Terminal)
cd ~/Desktop/ai-learning-too
```

#### Step 2: Create & Activate Virtual Environment (Optional but Recommended)

**Windows (Command Prompt)**:
```bash
# Create virtual environment
python -m venv venv

# Activate it
venv\Scripts\activate
```

**Windows (PowerShell)**:
```bash
# Create virtual environment
python -m venv venv

# Activate it
venv\Scripts\Activate.ps1
```

**Mac/Linux**:
```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate
```

#### Step 3: Install Dependencies
```bash
# Windows
pip install -r requirements.txt

# Mac/Linux
pip3 install -r requirements.txt
```

**What this installs**:
- pandas - Data processing
- numpy - Numerical computing
- scikit-learn - Machine learning
- joblib - Model persistence
- flask - Web framework (NEW)
- flask-cors - CORS support (NEW)

#### Step 4: Train the ML Model (First Time Only)

```bash
# Windows
python src/train.py

# Mac/Linux
python3 src/train.py
```

**Expected Output**:
```
Training AI Model...
Model Accuracy: 0.XX
SUCCESS: Model saved to 'models/completion_model.pkl'
```

**This creates**:
- `models/completion_model.pkl` - Trained Random Forest model
- `models/scaler.pkl` - Fitted data scaler

#### Step 5: Start the Flask Backend Server

```bash
# Windows
python flask_backend.py

# Mac/Linux
python3 flask_backend.py
```

**Expected Output**:
```
✓ Models loaded successfully
 * Running on http://0.0.0.0:5000
 * Debug mode: on
```

**Server is now running!** Keep this terminal open.

#### Step 6: Open the Frontend Interface

**Option A: Automatic** (if supported on your system)
- The browser should open automatically at `http://localhost:5000/index.html`

**Option B: Manual**
- Open a new browser tab
- Navigate to: `http://localhost:5000/index.html`

---

## Part 2: Using the Application Locally

### Upload & Analyze Data

1. **Prepare your CSV file** with columns:
   - `student_id`
   - `avg_score`
   - `avg_time_spent`
   - `chapter_retries`

   **Example**:
   ```csv
   student_id,avg_score,avg_time_spent,chapter_retries
   5000,85.5,12.5,2
   5001,72.3,8.3,3
   5002,45.8,5.2,8
   ```

2. **Upload the file**:
   - Drag & drop CSV file into the upload area, OR
   - Click to browse and select file

3. **Analyze**:
   - Click "🚀 Analyze Data" button
   - Wait for results (typically < 5 seconds)

4. **Review Results**:
   - Summary metrics at top
   - Risk student table in middle
   - Course difficulty section
   - Export buttons at bottom

5. **Export Data**:
   - Click "💾 Export as JSON"
   - Save the JSON report to your computer

---

## Part 3: GitHub Pages Deployment (Complete Guide)

### Important: GitHub Pages Limitations

GitHub Pages hosts **static files only** (HTML, CSS, JavaScript). It cannot run Python servers like Flask.

**Solution**: We'll convert the app to use a **backend service** (Heroku, Azure, or serverless functions) while hosting the frontend on GitHub Pages.

---

### Option A: GitHub Pages + Heroku Backend (Easiest)

#### Phase 1: Deploy Backend to Heroku

##### 1.1: Create Heroku Account
- Visit: https://www.heroku.com
- Sign up (free account works)
- Verify email

##### 1.2: Install Heroku CLI

**Windows**:
- Download from: https://devcenter.heroku.com/articles/heroku-cli
- Run installer
- Restart terminal

**Mac**:
```bash
brew tap heroku/brew && brew install heroku
```

**Linux**:
```bash
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
```

##### 1.3: Login to Heroku
```bash
heroku login
# Opens browser for authentication
# Follow prompts
```

##### 1.4: Create Procfile

In project root (`ai-learning-too/`), create file named `Procfile` (no extension):

```
web: gunicorn flask_backend:app
```

##### 1.5: Install Gunicorn
```bash
pip install gunicorn
pip freeze > requirements.txt  # Update requirements
```

##### 1.6: Update requirements.txt

Add this line to `requirements.txt`:
```
gunicorn
```

##### 1.7: Initialize Git Repository (if not already done)
```bash
cd C:\Users\USER\OneDrive\Desktop\ai-learning-too
git init
git add .
git commit -m "Initial commit"
```

##### 1.8: Create Heroku App
```bash
heroku create your-app-name
# Replace 'your-app-name' with something unique
# Examples: ai-learning-5000, student-risk-analyzer
```

##### 1.9: Deploy to Heroku
```bash
git push heroku main
# or: git push heroku master
# (depending on your default branch name)
```

**Expected Output**:
```
-----> Building on the Heroku platform from buildpacks...
...
remote: -----> Launching...
remote:        Released v1
remote: Deployed to Heroku
```

##### 1.10: Get Backend URL
```bash
heroku open
# Opens your app in browser
# Note the URL, e.g., https://your-app-name.herokuapp.com
```

**Your backend is now live!** 🎉

Test it:
```bash
curl https://your-app-name.herokuapp.com/api/health
# Should return: {"status": "healthy", "model_loaded": true}
```

---

#### Phase 2: Deploy Frontend to GitHub Pages

##### 2.1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `ai-learning-tool` (or any name)
3. Description: "AI Student Risk Analysis Tool"
4. Choose Public (required for free GitHub Pages)
5. Click "Create repository"

##### 2.2: Update Frontend for Backend API

Edit `index.html` and change the API URL:

```javascript
// Find this line (around line 160 in the <script> section):
const API_BASE_URL = 'http://localhost:5000';

// Change it to:
const API_BASE_URL = 'https://your-app-name.herokuapp.com';
// Replace 'your-app-name' with your actual Heroku app name
```

##### 2.3: Push to GitHub

```bash
# Add GitHub remote
git remote add origin https://github.com/YOUR-USERNAME/ai-learning-tool.git
# Replace YOUR-USERNAME with your GitHub username

# Push code
git branch -M main
git push -u origin main
```

##### 2.4: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** tab
3. Scroll to **Pages** section
4. Under "Source", select `main` branch
5. Click Save

**GitHub Pages is now enabled!** 🎉

##### 2.5: Access Your App

Your app is now live at:
```
https://YOUR-USERNAME.github.io/ai-learning-tool
```

**Example**: `https://john-doe.github.io/ai-learning-tool`

---

### Option B: GitHub Pages + Azure Functions Backend

#### Prerequisites
- Azure account (free tier available)
- Azure CLI installed

#### Steps Similar to Heroku

1. Deploy Flask app to Azure Functions
2. Get the Azure Function URL
3. Update `API_BASE_URL` in `index.html`
4. Push frontend to GitHub Pages

[Detailed Azure guide available on request]

---

### Option C: GitHub Pages + Backend Service (No Backend Setup)

Use a third-party backend service that's already set up:

1. Deploy frontend to GitHub Pages (Steps 2.1-2.5 above)
2. Use a pre-built API service
3. Update `API_BASE_URL` accordingly

---

## Part 4: Complete Step-by-Step Deployment Walkthrough

### Full Walkthrough Example

Let's say you want to deploy to GitHub Pages with Heroku backend.

#### Prerequisites
- GitHub account (free)
- Heroku account (free)
- Git installed
- Your project ready

#### Step 1: Deploy Backend to Heroku (10 minutes)

```bash
# 1. Navigate to project
cd C:\Users\USER\OneDrive\Desktop\ai-learning-too

# 2. Install Heroku CLI and login
heroku login

# 3. Create Procfile
# Create file "Procfile" (no extension) with content:
# web: gunicorn flask_backend:app

# 4. Add gunicorn to requirements
pip install gunicorn
pip freeze > requirements.txt

# 5. Commit changes
git add Procfile requirements.txt
git commit -m "Add Heroku configuration"

# 6. Create Heroku app
heroku create ai-learning-demo

# 7. Deploy
git push heroku main
# Wait for deployment to complete

# 8. Get URL
heroku open
# Note the URL from browser, e.g., https://ai-learning-demo.herokuapp.com
```

#### Step 2: Update Frontend for Backend URL (2 minutes)

```bash
# Open index.html in text editor
# Find: const API_BASE_URL = 'http://localhost:5000';
# Replace with: const API_BASE_URL = 'https://ai-learning-demo.herokuapp.com';
# Save file

git add index.html
git commit -m "Update API URL for Heroku"
```

#### Step 3: Deploy Frontend to GitHub Pages (5 minutes)

```bash
# 1. Create GitHub repository (via GitHub website)
# Name: ai-learning-tool

# 2. Add GitHub remote
git remote add origin https://github.com/YOUR-USERNAME/ai-learning-tool.git

# 3. Push to GitHub
git branch -M main
git push -u origin main

# 4. Enable GitHub Pages in repository settings
# Settings → Pages → Branch: main → Save

# 5. Your app is live at:
# https://YOUR-USERNAME.github.io/ai-learning-tool
```

---

## Part 5: Troubleshooting

### Local Development Issues

#### "Models not found" error
```bash
# Solution: Train the model
python src/train.py
```

#### "Port 5000 already in use"
```bash
# Solution: Kill the process using port 5000
# Windows:
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Mac/Linux:
lsof -ti :5000 | xargs kill -9
```

#### "ModuleNotFoundError"
```bash
# Solution: Install missing modules
pip install -r requirements.txt
```

### GitHub Pages + Heroku Issues

#### "CORS error" in browser console
**Problem**: Frontend (GitHub Pages) can't talk to backend (Heroku)

**Solution**: CORS is already configured in Flask, but verify:
1. Backend URL is correct in `index.html`
2. Heroku app is running: `heroku logs --tail`
3. Check network tab in browser DevTools

#### "404 Not Found" on api/predict
**Problem**: Backend URL is wrong

**Solution**:
1. Test backend: `curl https://your-app-name.herokuapp.com/api/health`
2. Should return JSON, not 404
3. If error, check Heroku deployment: `git push heroku main`

#### GitHub Pages shows blank page
**Problem**: index.html not found

**Solution**:
1. Check repository settings → Pages
2. Ensure branch is set to `main`
3. File must be `index.html` in root directory
4. Wait 1-2 minutes for GitHub Pages to rebuild

---

## Part 6: Production Checklist

Before sharing your app:

- [ ] Backend deployed to Heroku/Azure
- [ ] Frontend deployed to GitHub Pages
- [ ] API URL updated in index.html
- [ ] CORS enabled on backend
- [ ] Tested file upload in production
- [ ] Tested analysis in production
- [ ] Tested export in production
- [ ] All features working
- [ ] No console errors
- [ ] Share link with team

---

## Part 7: Cost Breakdown

### Local Development
- **Cost**: FREE
- **Limitations**: Only your machine

### GitHub Pages + Heroku

**GitHub Pages**: FREE (static hosting)

**Heroku Free Tier** (as of 2024):
- Free dynos discontinued
- Cheapest option: $5-7/month per dyno
- OR use alternatives:
  - **Render.com**: Free tier available
  - **Railway**: $5 credit/month free
  - **Replit**: Free tier available

---

## Part 8: Updating Your App

### After Making Changes Locally

```bash
# 1. Test locally
python flask_backend.py

# 2. When satisfied with changes
git add .
git commit -m "Description of changes"

# 3. Deploy backend to Heroku
git push heroku main

# 4. Deploy frontend to GitHub
git push origin main

# GitHub Pages auto-rebuilds in 1-2 minutes
```

---

## Part 9: Custom Domain (Optional)

To use your own domain instead of `github.io`:

### Using GitHub Pages with Custom Domain

1. **Buy domain** (GoDaddy, Namecheap, etc.)
2. **Configure DNS** to point to GitHub Pages
3. **Add CNAME file** to repository:
   ```
   your-domain.com
   ```
4. **Enable HTTPS** in GitHub Pages settings

### Using Custom Domain with Heroku Backend

Heroku backend gets auto HTTPS, no additional steps needed.

---

## Quick Reference: Commands to Remember

### Local Development
```bash
python src/train.py              # Train model (first time)
python flask_backend.py          # Start backend server
# Open: http://localhost:5000/index.html
```

### Deploy to Heroku
```bash
heroku create app-name
git push heroku main
heroku open
heroku logs --tail
```

### Deploy to GitHub Pages
```bash
git add .
git commit -m "message"
git push origin main
# Enable Pages in Settings
# Access at: https://username.github.io/repo-name
```

---

## Support & Resources

- **Heroku Docs**: https://devcenter.heroku.com
- **GitHub Pages Docs**: https://pages.github.com
- **Flask Docs**: https://flask.palletsprojects.com
- **GitHub Desktop**: https://desktop.github.com (GUI alternative to git CLI)

---

## Next Steps

1. **Test locally** first (Part 1-2)
2. **Deploy backend** to Heroku (Part 3, Option A)
3. **Update frontend API URL** (Part 4, Step 2)
4. **Deploy frontend** to GitHub Pages (Part 4, Step 3)
5. **Test in production** and share link!

---

**You're all set!** 🚀 Your app is ready for the world to use.
