@echo off
REM Quick Start Script for AI Learning Intelligence Tool
REM Windows Batch Script

echo.
echo ====================================================
echo  AI Learning Intelligence Tool - Quick Start
echo ====================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python 3.8+ from https://www.python.org/
    pause
    exit /b 1
)

echo [1/5] Checking Python installation...
python --version
echo.

echo [2/5] Installing/Updating dependencies...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo ✓ Dependencies installed
echo.

echo [3/5] Checking if models exist...
if not exist "models\completion_model.pkl" (
    echo [WARNING] Model files not found. Training new model...
    python src/train.py
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to train model
        pause
        exit /b 1
    )
) else (
    echo ✓ Model files found
)
echo.

echo [4/5] Starting Flask backend server...
echo.
echo ====================================================
echo  Server is starting on http://localhost:5000
echo ====================================================
echo.
echo The browser will open automatically...
timeout /t 2 /nobreak
start http://localhost:5000/index.html

echo.
echo [5/5] Running Flask backend...
python flask_backend.py

pause
