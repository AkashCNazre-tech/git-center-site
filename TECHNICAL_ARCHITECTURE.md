# 🏗️ Technical Architecture & Implementation Guide

## Overview

This document explains the recursive architecture and design patterns used in the AI Learning Intelligence Tool deployment.

---

## Part 1: System Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     USER BROWSER                             │
│                      (index.html)                            │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Frontend UI                                            │ │
│  │ • File Upload (Drag & Drop)                          │ │
│  │ • Form Validation                                    │ │
│  │ • Results Visualization                             │ │
│  │ • Export Functionality                              │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP/CORS
                           │ JSON Payloads
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              FLASK API SERVER (Port 5000)                    │
│              (flask_backend.py)                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ REST API Endpoints                                    │ │
│  │ /api/predict         [POST] - Main analysis          │ │
│  │ /api/health          [GET]  - Status check           │ │
│  │ /api/sample-csv      [GET]  - Sample data            │ │
│  │ /api/export-report   [POST] - Export results         │ │
│  │ /api/model-info      [GET]  - Model metadata         │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────┬──────────────────────────────────┘
                           │ Core Logic
                           │ Data Processing
                           ▼
┌─────────────────────────────────────────────────────────────┐
│            PYTHON CORE LOGIC (src/ folder)                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Data Pipeline:                                        │ │
│  │  1. CSV Read (pandas)                               │ │
│  │  2. Feature Scaling (sklearn.StandardScaler)        │ │
│  │  3. Model Prediction (sklearn.RandomForest)         │ │
│  │  4. Analytics Engine (src/analytics.py)             │ │
│  │  5. JSON Report Generation                          │ │
│  │                                                      │ │
│  │ Files:                                              │ │
│  │ • src/train.py - Model training                    │ │
│  │ • src/analytics.py - Risk & difficulty analysis    │ │
│  │ • src/data_generator.py - Sample data              │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ ML Models:                                            │ │
│  │ • models/completion_model.pkl (Random Forest)        │ │
│  │ • models/scaler.pkl (StandardScaler)                 │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Part 2: Data Flow (Recursive Processing)

### Request-Response Cycle

```
USER UPLOADS CSV
    ↓
[Frontend Validation]
  • File type check (.csv)
  • File size check
  • Format preview
    ↓
[Send HTTP POST to /api/predict]
  • FormData with file
  • CORS headers
    ↓
[Backend Receives Request]
  • Extract file from request
  • Validate MIME type
    ↓
[Parse CSV Data]
  • Read CSV with pandas
  • Validate required columns
  • Handle missing/invalid data
    ↓
[Feature Extraction]
  • Extract: avg_score, avg_time_spent, chapter_retries
  • Create feature matrix X
    ↓
[Data Scaling]
  • Apply StandardScaler (fit from training)
  • Normalize features to zero mean, unit variance
    ↓
[ML Prediction]
  • Random Forest Classifier.predict(X_scaled)
  • Random Forest Classifier.predict_proba(X_scaled)
  • Get binary predictions + probabilities
    ↓
[Analytics Processing]
  • AnalyticsEngine.identify_at_risk_students()
    - Combine predictions with business rules
    - Flag students with dropout probability > threshold
  • AnalyticsEngine.detect_chapter_difficulty()
    - Calculate difficulty index
    - Determine difficulty level (Easy/Medium/Hard)
    ↓
[Report Generation]
  • Aggregate summary statistics
  • Build action items list
  • Structure JSON response
    ↓
[Send Response to Frontend]
  • JSON with predictions, risk flags, difficulty metrics
    ↓
[Frontend Processing]
  • Parse JSON response
  • Render metric cards
  • Display risk table (color-coded)
  • Show course insights
    ↓
[Display Results to User]
  • Interactive dashboard
  • Export options (JSON, CSV)
    ↓
USER MAKES DECISION BASED ON INSIGHTS
```

---

## Part 3: Recursive Architecture Design

### What is "Recursive Thinking" in This Context?

1. **Nested Data Structures**
   ```
   CSV Data
    ├─ Student Records
    │  ├─ Features
    │  │  ├─ avg_score
    │  │  ├─ avg_time_spent
    │  │  └─ chapter_retries
    │  └─ Predictions
    │     ├─ Completion Status
    │     └─ Probability
    └─ Aggregated Insights
       ├─ Risk Analysis
       └─ Difficulty Metrics
   ```

2. **Layered Processing Pipeline**
   ```
   Level 1: Raw Data Input (CSV)
     ↓ Transform
   Level 2: Structured DataFrame
     ↓ Feature Selection
   Level 3: Feature Matrix
     ↓ Scaling
   Level 4: Normalized Data
     ↓ Model Inference
   Level 5: Predictions & Probabilities
     ↓ Analytics
   Level 6: Risk Flags & Insights
     ↓ Aggregation
   Level 7: JSON Report
     ↓ Visualization
   Level 8: User-Facing Dashboard
   ```

3. **Function Composition (Recursive Functions)**
   ```python
   # Backend: flask_backend.py
   def predict():
       # Level 1: Read CSV
       df = pd.read_csv(...)
       # Level 2: Validate features
       validate_columns(df)
       # Level 3: Scale data
       X_scaled = scaler.transform(df)
       # Level 4: Predict
       predictions = model.predict(X_scaled)
       # Level 5: Analyze
       risk_list = analytics.identify_at_risk_students(...)
       # Level 6: Aggregate
       report = build_report(...)
       # Level 7: Return
       return jsonify(report)
   ```

---

## Part 4: File-by-File Component Breakdown

### Frontend: `index.html`

**Sections:**
```
1. HTML Structure
   ├─ Header (Title & Description)
   ├─ Main Layout
   │  ├─ Sidebar: Upload Section
   │  └─ Main: Results Section
   └─ Footer (Credits)

2. CSS Styling
   ├─ Root variables (colors, spacing)
   ├─ Component styles
   ├─ Responsive design (mobile-first)
   └─ Animations & transitions

3. JavaScript (1500+ lines)
   ├─ Configuration
   │  └─ API_BASE_URL, state variables
   ├─ Utility Functions
   │  ├─ showStatus()
   │  ├─ showError()
   │  ├─ downloadJSON()
   │  └─ formatRiskLabel()
   ├─ File Handling
   │  ├─ File input change handler
   │  ├─ Drag & drop handlers
   │  └─ File validation
   ├─ Analysis Engine
   │  ├─ analyzeData() [Main function]
   │  ├─ displayResults() [UI rendering]
   │  └─ exportReport() [Data export]
   └─ Event Listeners
      └─ Button clicks, key presses, drag events
```

**Key Functions:**
- `analyzeData()`: Sends CSV to backend, handles response
- `displayResults()`: Renders metrics, tables, charts
- `showStatus()`: Displays loading/success/error messages
- `downloadJSON()`: Exports analysis as JSON file

---

### Backend: `flask_backend.py`

**Structure:**
```
1. Imports
   ├─ Flask, CORS
   ├─ pandas, joblib
   └─ src.analytics

2. App Configuration
   ├─ Flask instance
   ├─ CORS enablement
   ├─ Model paths
   └─ Resource loading

3. Endpoints
   ├─ GET /api/health
   │  └─ Check backend status
   ├─ POST /api/predict
   │  └─ Main analysis endpoint
   ├─ GET /api/sample-csv
   │  └─ Download sample format
   ├─ POST /api/export-report
   │  └─ Export results as JSON
   └─ GET /api/model-info
      └─ Return model metadata

4. Helper Functions
   ├─ load_resources()
   │  └─ Load model and scaler on startup
   └─ Error handling

5. Server Launch
   └─ app.run() with debug mode
```

**Endpoint Details:**

#### `/api/predict` (POST)
```python
Request:
  • Method: POST
  • Body: multipart/form-data
  • Content: CSV file

Processing:
  1. Validate file exists
  2. Parse CSV
  3. Validate columns
  4. Scale features
  5. Predict outcomes
  6. Run analytics
  7. Build report

Response:
  {
    "success": true,
    "summary": {
      "total_students": int,
      "at_risk_count": int,
      "predicted_completion_rate": "XX%"
    },
    "course_insights": {
      "overall_difficulty": "Hard|Medium|Easy",
      "avg_student_score": float,
      "avg_retries_per_chapter": float
    },
    "high_risk_students": [
      {
        "student_id": int,
        "predicted_outcome": "Dropout|Completion",
        "risk_probability": "XX%",
        "current_score": float
      }
    ]
  }
```

---

### Core Logic: `src/analytics.py`

**Purpose**: Business logic for risk and difficulty analysis

```python
class AnalyticsEngine:

1. detect_chapter_difficulty(df)
   ├─ Calculate avg_score
   ├─ Calculate avg_retries
   ├─ Compute difficulty_index
   └─ Return difficulty level + metrics

2. identify_at_risk_students(df, predictions, probs)
   ├─ Iterate through students
   ├─ Check predictions & scores
   ├─ Flag high-risk students
   └─ Return risk report list
```

**Risk Logic:**
```
Student is flagged as "Dropout" if:
  • Model predicts 0 (dropout) OR
  • avg_score < 40 (low performance)

Risk Probability = 1 - model_confidence
```

**Difficulty Logic:**
```
difficulty_index = (avg_retries × 20) + (100 - avg_score)

If index > 60: "Hard"
If index < 30: "Easy"
Else:          "Medium"
```

---

### Model Training: `src/train.py`

```python
1. Load training data
   └─ read data/train_dataset.csv

2. Feature selection
   └─ ['avg_score', 'avg_time_spent', 'chapter_retries']

3. Data scaling
   └─ StandardScaler.fit_transform()

4. Train/test split
   └─ 80% train, 20% test

5. Train model
   └─ RandomForestClassifier(n_estimators=100)

6. Evaluate
   └─ Print accuracy score

7. Save artifacts
   └─ models/completion_model.pkl
   └─ models/scaler.pkl
```

---

## Part 5: Routing & Communication Protocol

### Frontend-Backend Routing

```
URL Routing (Frontend):
  http://localhost:5000/index.html
    ↓
  Loads HTML, CSS, JavaScript
    ↓
  JavaScript event listeners ready

API Routing (Backend):
  Flask app registers endpoints
    ├─ GET /api/health → health_check()
    ├─ POST /api/predict → predict()
    ├─ GET /api/sample-csv → get_sample_csv()
    ├─ POST /api/export-report → export_report()
    └─ GET /api/model-info → model_info()

Request Flow:
  Browser (JavaScript fetch API)
    → HTTP POST/GET to Flask endpoint
    → Flask receives and processes
    → Backend executes Python logic
    → Returns JSON response
    → JavaScript parses and renders
    → User sees results
```

### CORS (Cross-Origin Resource Sharing)

```
Enabled by: flask_cors.CORS(app)

Allows:
  • Browser (index.html) → API (port 5000)
  • Different origins/ports communication
  • Credentials and custom headers
```

---

## Part 6: Error Handling & Validation

### Frontend Validation

```javascript
1. File existence check
2. File type validation (.csv)
3. API response validation
4. JSON parsing error handling
5. User-friendly error messages
```

### Backend Validation

```python
1. Model/scaler existence
2. File presence in request
3. CSV parse-ability
4. Required columns presence
5. Data type validation
6. Feature scaling compatibility
```

### Error Response Format

```json
{
  "success": false,
  "error": "Descriptive error message"
}
```

---

## Part 7: Deployment Architecture

### Local Development
```
python flask_backend.py
  ↓
http://localhost:5000/index.html
  ↓
Dev mode with auto-reload
```

### Production (Gunicorn)
```
gunicorn -w 4 -b 0.0.0.0:5000 flask_backend:app
  ↓
Multi-worker process
  ↓
Load balancing
```

### Docker Containerization
```
Dockerfile
  ├─ Base image: python:3.9-slim
  ├─ Install dependencies
  ├─ Copy application
  └─ Run flask_backend:app

Docker Compose
  ├─ Service definition
  ├─ Port mapping
  ├─ Volume mounting
  └─ Environment variables
```

### Cloud Deployment (Azure)
```
Azure App Service
  ├─ Linux runtime
  ├─ Python 3.9 stack
  └─ Startup command: python flask_backend.py

Environment Variables
  ├─ Flask debug mode
  ├─ Model paths
  └─ CORS settings
```

---

## Part 8: Performance Optimization

### Frontend
```
• Lazy loading for images/CSS
• Minified JavaScript
• CSS Grid for responsive layout
• Efficient DOM manipulation
• Event delegation for buttons
```

### Backend
```
• Cached model loading (@cache_resource equivalent)
• Vectorized operations (pandas/numpy)
• Efficient scaling (fit once, transform many)
• Connection pooling (if using DB)
```

### ML Model
```
• Random Forest: Fast inference (~100ms per 50 students)
• Binary classification: Simpler than multi-class
• StandardScaler: O(n) complexity
• In-memory processing: No disk I/O during inference
```

---

## Part 9: Security Considerations

### Current Implementation
```
✓ CORS enabled (localhost)
✓ Error messages sanitized
✓ File type validation
✓ No SQL injection (no database)
```

### Production Hardening Needed
```
• Add file size limits
• Implement authentication
• Rate limiting on API endpoints
• HTTPS/TLS encryption
• Input sanitization enhancements
• CORS whitelist specific origins
• Add request timeouts
```

---

## Part 10: Testing & Validation

### Frontend Testing
```
1. Upload a test CSV file
2. Verify file display
3. Click analyze button
4. Check response parsing
5. Validate table rendering
6. Test export functionality
```

### Backend Testing
```bash
# Test health endpoint
curl http://localhost:5000/api/health

# Test with sample file
curl -X POST -F "file=@test.csv" http://localhost:5000/api/predict

# Test model info
curl http://localhost:5000/api/model-info
```

### Sample CSV Format
```
student_id,avg_score,avg_time_spent,chapter_retries
5000,85.5,12.5,2
5001,72.3,8.3,3
5002,45.8,5.2,8
```

---

## Summary

This is a **three-tier recursive architecture**:

1. **Presentation Tier**: HTML/CSS/JavaScript UI
2. **Application Tier**: Flask REST API
3. **Data Tier**: Python ML Core (models, analytics, processing)

Each tier is **loosely coupled** (communicates via JSON/HTTP) and **highly cohesive** (internal logic is organized hierarchically).

The **recursive thinking** manifests as:
- Nested data structures (CSV → DataFrame → Features → Predictions)
- Layered processing (Raw → Scaled → Predicted → Analyzed → Reported)
- Function composition (Each layer transforms data for the next)
