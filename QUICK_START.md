# 🚀 Quick Reference - 5-Minute Setup

## Fastest Way to Deploy

### Windows Users
```bash
# 1. Open Command Prompt in project folder
# 2. Run this single command:
start.bat
```

### Mac/Linux Users
```bash
# 1. Open Terminal in project folder
# 2. Run:
chmod +x start.sh
./start.sh
```

### Manual Setup (All Platforms)
```bash
# Terminal/Command Prompt
pip install -r requirements.txt
python src/train.py          # Train model (first time only)
python flask_backend.py      # Start server
# Then open: http://localhost:5000/index.html
```

---

## Project Files At A Glance

| File | Purpose | Language |
|------|---------|----------|
| `index.html` | **Web UI Dashboard** | HTML/CSS/JavaScript |
| `flask_backend.py` | **REST API Server** | Python |
| `src/analytics.py` | **Risk & Difficulty Analysis** | Python |
| `src/train.py` | **ML Model Training** | Python |
| `requirements.txt` | **Dependencies** | Text |

---

## Key API Endpoints

```
POST   /api/predict          Upload CSV → Get predictions
GET    /api/health           Check backend status
GET    /api/sample-csv       Download example format
POST   /api/export-report    Export results as JSON
GET    /api/model-info       Get model details
```

---

## How It Works

```
1. User uploads CSV file with student data
           ↓
2. Browser sends file to Flask backend (/api/predict)
           ↓
3. Backend runs ML predictions using trained model
           ↓
4. Analytics engine identifies at-risk students
           ↓
5. JSON response sent back to browser
           ↓
6. Dashboard displays results with visualizations
           ↓
7. User can export/download the analysis report
```

---

## Sample CSV Format

```csv
student_id,avg_score,avg_time_spent,chapter_retries
5000,85.5,12.5,2
5001,72.3,8.3,3
5002,45.8,5.2,8
```

**Required Columns:**
- `student_id` - Student identifier
- `avg_score` - Average test score (0-100)
- `avg_time_spent` - Hours per chapter
- `chapter_retries` - Number of retakes

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Models not found" | Run: `python src/train.py` |
| Port 5000 in use | Edit flask_backend.py, change `port=5000` |
| File upload fails | Ensure CSV has all required columns |
| CORS errors | Already configured, should work |
| Python not found | Install Python 3.8+, add to PATH |

---

## Output Explained

### Summary Section
- **Total Students**: Count of all students in dataset
- **Students at Risk**: Predicted to dropout
- **Completion Rate**: Percentage likely to finish

### Risk Students Table
- **Student ID**: Identifier
- **Predicted Outcome**: Dropout or Completion
- **Risk Probability**: % chance of dropout
- **Current Score**: Student's average score

### Course Difficulty
- **Easy**: Low difficulty (students succeeding)
- **Medium**: Moderate challenge
- **Hard**: High difficulty (many retries)

---

## Architecture Summary

```
Browser (HTML/JS)
    ↑↓ HTTP/JSON
Flask API (Python)
    ↑↓ Python calls
ML Model + Analytics
```

---

## Advanced Options

### Use Different Port
Edit `flask_backend.py`, change line:
```python
app.run(debug=True, host='0.0.0.0', port=5000)  # Change 5000
```

### Disable Debug Mode
```python
app.run(debug=False, host='0.0.0.0', port=5000)
```

### Production Deployment
```bash
pip install gunicorn
gunicorn -w 4 flask_backend:app
```

---

## File Structure

```
ai-learning-too/
├── index.html                    # 👈 Main web interface
├── flask_backend.py              # 👈 API server
├── requirements.txt              # Dependencies
├── src/
│   ├── analytics.py              # Risk analysis logic
│   ├── train.py                  # Model training
│   └── data_generator.py         # Data utilities
├── models/
│   ├── completion_model.pkl      # Trained model
│   └── scaler.pkl                # Data scaler
├── data/
│   ├── train_dataset.csv         # Training data
│   └── final_report.json         # Sample output
├── start.bat                     # Windows startup
├── start.sh                      # Mac/Linux startup
├── DEPLOYMENT_GUIDE.md           # Full setup guide
└── TECHNICAL_ARCHITECTURE.md     # Deep dive docs
```

---

## Feature List

✅ **Frontend**
- Drag & drop file upload
- Real-time analysis
- Interactive dashboard
- Color-coded risk levels
- Export as JSON
- Responsive design

✅ **Backend**
- REST API with CORS
- File validation
- ML predictions
- Risk scoring
- Difficulty analysis
- Error handling

✅ **ML**
- Random Forest Classifier
- StandardScaler normalization
- Probability-based risk scoring
- Course difficulty detection

---

## Success Indicators

After running `start.bat` or `start.sh`:

1. ✅ Terminal shows "Models loaded successfully"
2. ✅ Browser opens to dashboard
3. ✅ File upload area visible
4. ✅ "Analyze Data" button enabled after selecting CSV
5. ✅ Results display with metrics and tables

---

## Next Steps

1. **Install**: `pip install -r requirements.txt`
2. **Train**: `python src/train.py`
3. **Run**: `python flask_backend.py`
4. **Open**: http://localhost:5000/index.html
5. **Upload**: Select CSV file
6. **Analyze**: Click button and see results

---

## Support Files

- 📖 **DEPLOYMENT_GUIDE.md** - Complete setup & deployment
- 📐 **TECHNICAL_ARCHITECTURE.md** - System design & deep dive
- 🎓 **README.md** - Project overview
- 📝 **This file** - Quick reference

---

**Version**: 1.0 | **Status**: Ready to Deploy | **Last Updated**: December 2025
