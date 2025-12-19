# 🏗️ System Architecture Diagrams

## 1. Complete System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        END USER                                 │
│                    (Uses Web Browser)                           │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  LOCAL BROWSER       │
                    │  http://localhost:5000
                    │  /index.html         │
                    └──────────────┬───────┘
                                   │
                        HTTP/REST/JSON Protocol
                                   │
                    ┌──────────────▼───────────────┐
                    │   FLASK WEB SERVER          │
                    │   Port 5000                 │
                    │   flask_backend.py          │
                    │                             │
                    │  Routes:                    │
                    │  • /api/predict  [POST]    │
                    │  • /api/health   [GET]     │
                    │  • /api/sample-csv [GET]   │
                    │  • /api/export   [POST]    │
                    │  • /api/model-info [GET]   │
                    └──────────────┬──────────────┘
                                   │
                       Python Function Calls
                                   │
                    ┌──────────────▼──────────────┐
                    │  CORE ML PIPELINE           │
                    │                             │
                    │  1. pandas.read_csv()       │
                    │  2. Feature Extraction      │
                    │  3. sklearn.Scaler          │
                    │  4. Model.predict()         │
                    │  5. Analytics Engine        │
                    │  6. JSON Report Build       │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │  ARTIFACTS & DATA           │
                    │                             │
                    │  • completion_model.pkl    │
                    │  • scaler.pkl              │
                    │  • analytics.py            │
                    │  • train.py                │
                    └─────────────────────────────┘
```

---

## 2. Frontend-Backend Communication Flow

```
                    FRONTEND (index.html)
                            │
                            │ User uploads CSV
                            ▼
                    ┌─────────────────────┐
                    │ File Input Handler  │
                    │ • Validate format   │
                    │ • Check file size   │
                    │ • Store in memory   │
                    └──────────┬──────────┘
                               │
                               │ User clicks "Analyze"
                               ▼
                    ┌──────────────────────────┐
                    │ FormData Construction    │
                    │ • Append CSV file        │
                    │ • Create FormData object │
                    └──────────┬───────────────┘
                               │
                HTTP POST Request (multipart/form-data)
                    fetch('/api/predict')
                               │
                               ▼
                    ┌──────────────────────────┐
                    │  BACKEND (flask_backend) │
                    │  predict() function      │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ 1. Request Validation    │
                    │    • Check file exists   │
                    │    • Check MIME type     │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ 2. CSV Parsing           │
                    │    • Read stream         │
                    │    • Create DataFrame    │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ 3. Column Validation     │
                    │    • Check required cols │
                    │    • Handle missing data │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ 4. Feature Extraction    │
                    │    • avg_score           │
                    │    • avg_time_spent      │
                    │    • chapter_retries     │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ 5. Data Scaling          │
                    │    • StandardScaler.     │
                    │      transform()         │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ 6. Model Prediction      │
                    │    • Random Forest       │
                    │    • predict()           │
                    │    • predict_proba()     │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ 7. Analytics Engine      │
                    │    • identify_at_risk()  │
                    │    • detect_difficulty() │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ 8. Report Generation     │
                    │    • Summary stats       │
                    │    • Risk list           │
                    │    • Difficulty metrics  │
                    └──────────┬───────────────┘
                               │
                HTTP Response (JSON)
                    {"success": true, ...}
                               │
                               ▼
                    ┌──────────────────────────┐
                    │  FRONTEND Response       │
                    │  Handler                 │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ Parse JSON Response      │
                    │ • Check success flag     │
                    │ • Extract metrics        │
                    │ • Extract risk data      │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ Build HTML Elements      │
                    │ • Metric cards           │
                    │ • Risk table             │
                    │ • Difficulty section     │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │ Apply CSS Styling        │
                    │ • Colors & gradients     │
                    │ • Animations             │
                    │ • Responsive layout      │
                    └──────────┬───────────────┘
                               │
                               ▼
                    ┌──────────────────────────┐
                    │  Display Results         │
                    │  • Show metrics          │
                    │  • Render tables         │
                    │  • Update dashboard      │
                    └──────────────────────────┘
```

---

## 3. Data Processing Pipeline (Recursive)

```
Input Layer (Raw Data)
│
├─ CSV File
│  ├─ Header row
│  └─ Data rows (one per student)
│
▼
Parse & Load Layer
│
├─ pandas.read_csv()
│  ├─ Read from stream
│  ├─ Create DataFrame
│  └─ Infer data types
│
▼
Validation Layer
│
├─ Check columns
│  ├─ student_id present?
│  ├─ avg_score present?
│  ├─ avg_time_spent present?
│  └─ chapter_retries present?
├─ Check data types
├─ Check for NaN values
└─ Return validation result
│
▼
Feature Selection Layer
│
├─ Select feature columns
│  ├─ avg_score
│  ├─ avg_time_spent
│  └─ chapter_retries
├─ Create feature matrix X
└─ Shape: (n_students, 3)
│
▼
Scaling Layer
│
├─ Apply StandardScaler
│  ├─ Center: subtract mean
│  ├─ Scale: divide by std dev
│  └─ Result: mean=0, std=1
└─ Output: X_scaled
│
▼
Prediction Layer
│
├─ Random Forest Classifier
│  ├─ predictions = model.predict(X_scaled)
│  │  └─ Output: [0 or 1 per student]
│  └─ probs = model.predict_proba(X_scaled)
│     └─ Output: [prob_dropout, prob_completion]
├─ For each student:
│  ├─ Binary classification result
│  └─ Confidence score
│
▼
Analytics Layer
│
├─ Risk Identification
│  ├─ For each student:
│  │  ├─ Is predictions[i] == 0? (dropout)
│  │  ├─ Is avg_score < 40?
│  │  ├─ Calculate risk probability
│  │  └─ Flag as "at-risk" if true
│  └─ Result: risk_list
│
├─ Difficulty Detection
│  ├─ Calculate avg_score across all students
│  ├─ Calculate avg_retries across all students
│  ├─ Compute difficulty_index
│  │  └─ = (avg_retries × 20) + (100 - avg_score)
│  ├─ Classify difficulty
│  │  ├─ If index > 60: "Hard"
│  │  ├─ If index < 30: "Easy"
│  │  └─ Else: "Medium"
│  └─ Result: difficulty_stats
│
▼
Aggregation Layer
│
├─ Build Summary
│  ├─ total_students: len(df)
│  ├─ at_risk_count: len(risk_list)
│  └─ completion_rate: ((len(df)-len(risk_list))/len(df))*100
│
├─ Prepare Risk Report
│  ├─ For each at-risk student:
│  │  ├─ student_id
│  │  ├─ predicted_outcome
│  │  ├─ risk_probability
│  │  └─ current_score
│  └─ Result: high_risk_students list
│
└─ Combine all results
│
▼
Report Generation Layer
│
├─ Structure JSON
│  ├─ success: true
│  ├─ summary: {...}
│  ├─ course_insights: {...}
│  ├─ high_risk_students: [...]
│  └─ timestamp: ISO format
│
▼
Response Layer (Output)
│
└─ HTTP 200 OK + JSON payload
```

---

## 4. Project File Dependencies

```
index.html (Frontend)
    │
    ├─ Fetch API
    │  └─ Calls flask_backend.py endpoints
    │
    └─ JSON Processing
       └─ Expects response from /api/predict

flask_backend.py (Backend Server)
    │
    ├─ Imports:
    │  ├─ Flask (web framework)
    │  ├─ pandas (CSV processing)
    │  ├─ joblib (load model/scaler)
    │  └─ src.analytics (AnalyticsEngine)
    │
    ├─ Loads at startup:
    │  ├─ models/completion_model.pkl
    │  └─ models/scaler.pkl
    │
    └─ Calls:
       ├─ analytics.identify_at_risk_students()
       └─ analytics.detect_chapter_difficulty()

src/analytics.py (Core Logic)
    │
    ├─ AnalyticsEngine class
    │
    ├─ detect_chapter_difficulty(df)
    │  └─ Returns: difficulty stats
    │
    └─ identify_at_risk_students(df, pred, prob)
       └─ Returns: risk list

src/train.py (Model Training)
    │
    ├─ Load: data/train_dataset.csv
    ├─ Create: Random Forest model
    ├─ Save: models/completion_model.pkl
    └─ Save: models/scaler.pkl

requirements.txt
    │
    └─ Lists all dependencies:
       ├─ pandas
       ├─ numpy
       ├─ scikit-learn
       ├─ joblib
       ├─ flask
       └─ flask-cors

data/ (Input/Output)
    │
    ├─ train_dataset.csv (used by src/train.py)
    ├─ new_students_input.csv (example input)
    └─ final_report.json (example output)

models/ (ML Artifacts)
    │
    ├─ completion_model.pkl (trained Random Forest)
    └─ scaler.pkl (fitted StandardScaler)
```

---

## 5. API Endpoint Details

```
┌──────────────────────────────────────────────┐
│        REST API ENDPOINTS STRUCTURE           │
└──────────────────────────────────────────────┘

1. POST /api/predict
   ├─ Input:
   │  └─ multipart/form-data
   │     └─ file: CSV file
   │
   ├─ Processing:
   │  ├─ Parse CSV
   │  ├─ Validate columns
   │  ├─ Scale features
   │  ├─ Predict
   │  └─ Analyze
   │
   └─ Output:
      └─ 200 OK
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
               "predicted_outcome": "Dropout",
               "risk_probability": "XX%",
               "current_score": float
             }
           ],
           "timestamp": "ISO-8601"
         }

2. GET /api/health
   ├─ Input: None
   ├─ Output:
   │  {
   │    "status": "healthy",
   │    "model_loaded": true,
   │    "timestamp": "ISO-8601"
   │  }
   └─ Use: Check if server is running

3. GET /api/sample-csv
   ├─ Input: None
   ├─ Output: CSV file with sample data
   └─ Use: Download example CSV format

4. POST /api/export-report
   ├─ Input:
   │  {
   │    "summary": {...},
   │    "course_insights": {...},
   │    "high_risk_students": [...]
   │  }
   ├─ Output:
   │  {
   │    "generated_at": "ISO-8601",
   │    "summary": {...},
   │    "course_insights": {...},
   │    "high_risk_students": [...]
   │  }
   └─ Use: Export analysis as JSON

5. GET /api/model-info
   ├─ Input: None
   ├─ Output:
   │  {
   │    "model_type": "Random Forest Classifier",
   │    "n_estimators": 100,
   │    "features": ["avg_score", "avg_time_spent", "chapter_retries"],
   │    "feature_descriptions": {...},
   │    "output": "Completion probability (0-1)"
   │  }
   └─ Use: Get model metadata
```

---

## 6. State Management Flow

```
FRONTEND STATE
│
├─ currentFile
│  ├─ null (initial)
│  └─ File object (after upload)
│
├─ analysisResults
│  ├─ null (initial)
│  └─ JSON object (after analysis)
│
└─ UI State
   ├─ emptyState (visible)
   ├─ resultsSection (hidden)
   ├─ statusMessage (varies)
   └─ analyzeBtn (disabled/enabled)

State Transitions:
│
├─ 1. User selects file
│  └─ currentFile = file → analyzeBtn.disabled = false
│
├─ 2. User clicks analyze
│  ├─ statusMessage = "Loading..."
│  └─ analyzeBtn.disabled = true
│
├─ 3. Backend returns results
│  ├─ analysisResults = response
│  ├─ statusMessage = "Success!"
│  ├─ emptyState.hidden = true
│  ├─ resultsSection.hidden = false
│  └─ render results
│
└─ 4. User exports
   ├─ Format results
   ├─ Download file
   └─ statusMessage = "Exported!"
```

---

## 7. Error Handling Flow

```
┌─────────────────────────────────────────┐
│          ERROR HANDLING PATHS             │
└─────────────────────────────────────────┘

Frontend Errors:
│
├─ File not selected
│  └─ showError("Please select a file first")
│
├─ Network error
│  └─ catch(error) → showError(error.message)
│
├─ Invalid JSON response
│  └─ catch(error) → showError("Invalid response")
│
└─ Missing required fields
   └─ showError("Missing data")

Backend Errors:
│
├─ Models not loaded
│  └─ return {"success": false, "error": "Models not found"}
│     │ HTTP 500
│
├─ File not in request
│  └─ return {"success": false, "error": "No file provided"}
│     │ HTTP 400
│
├─ CSV parse error
│  └─ return {"success": false, "error": "Error reading CSV: ..."}
│     │ HTTP 400
│
├─ Missing columns
│  └─ return {"success": false, "error": "Missing columns: ..."}
│     │ HTTP 400
│
└─ Scaling/prediction error
   └─ return {"success": false, "error": "Error scaling data: ..."}
      │ HTTP 400

Recovery:
│
├─ User sees error message
├─ Can retry with different file
├─ Or review error details
└─ And try again
```

---

## 8. Deployment Architecture Options

```
LOCAL DEVELOPMENT
│
├─ python flask_backend.py
├─ Debug mode enabled
├─ Hot reload enabled
└─ localhost:5000

PRODUCTION (Gunicorn)
│
├─ gunicorn -w 4 flask_backend:app
├─ 4 worker processes
├─ Load balancing
└─ 0.0.0.0:5000

DOCKER CONTAINER
│
├─ Docker image with Python 3.9
├─ Dependencies installed
├─ Model artifacts included
└─ Container port 5000

CLOUD DEPLOYMENT
│
├─ Azure App Service
│  └─ Python 3.9 runtime
├─ Heroku
│  └─ Procfile: web: gunicorn ...
└─ AWS EC2
   └─ Flask server on port 5000
```

---

This comprehensive visualization shows the complete system architecture, data flow, and how all components interact with each other.
