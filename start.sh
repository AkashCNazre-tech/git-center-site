#!/bin/bash

# Quick Start Script for AI Learning Intelligence Tool
# Linux/Mac Bash Script

echo ""
echo "===================================================="
echo " AI Learning Intelligence Tool - Quick Start"
echo "===================================================="
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python3 is not installed"
    echo "Please install Python 3.8+ using:"
    echo "  macOS: brew install python3"
    echo "  Linux: sudo apt-get install python3 python3-pip"
    exit 1
fi

echo "[1/5] Checking Python installation..."
python3 --version
echo ""

echo "[2/5] Installing/Updating dependencies..."
pip3 install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to install dependencies"
    exit 1
fi
echo "✓ Dependencies installed"
echo ""

echo "[3/5] Checking if models exist..."
if [ ! -f "models/completion_model.pkl" ]; then
    echo "[WARNING] Model files not found. Training new model..."
    python3 src/train.py
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to train model"
        exit 1
    fi
else
    echo "✓ Model files found"
fi
echo ""

echo "[4/5] Starting Flask backend server..."
echo ""
echo "===================================================="
echo " Server is starting on http://localhost:5000"
echo "===================================================="
echo ""

# Open browser if possible
if command -v xdg-open &> /dev/null; then
    # Linux
    xdg-open http://localhost:5000/index.html &
elif command -v open &> /dev/null; then
    # macOS
    open http://localhost:5000/index.html &
fi

echo "The browser will open automatically..."
sleep 2

echo ""
echo "[5/5] Running Flask backend..."
python3 flask_backend.py
