"""
Flask API Backend for AI Learning Intelligence Tool
Bridges HTML frontend with Python ML core logic
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import joblib
import json
import os
import sys
import io
from datetime import datetime

# Import core analytics
sys.path.insert(0, os.path.dirname(__file__))
from src.analytics import AnalyticsEngine

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for frontend-backend communication

# Model configuration
MODEL_PATH = 'models/completion_model.pkl'
SCALER_PATH = 'models/scaler.pkl'

# Global variables for loaded models
model = None
scaler = None

def load_resources():
    """Load ML model and scaler once at startup"""
    global model, scaler
    try:
        if os.path.exists(MODEL_PATH) and os.path.exists(SCALER_PATH):
            model = joblib.load(MODEL_PATH)
            scaler = joblib.load(SCALER_PATH)
            return True
    except Exception as e:
        print(f"Error loading models: {e}")
    return False

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    model_loaded = model is not None and scaler is not None
    return jsonify({
        'status': 'healthy',
        'model_loaded': model_loaded,
        'timestamp': datetime.now().isoformat()
    })

@app.route('/api/predict', methods=['POST'])
def predict():
    """
    Main prediction endpoint
    Expects CSV file in request
    Returns risk analysis and difficulty metrics
    """
    try:
        # Check if model is loaded
        if model is None or scaler is None:
            return jsonify({
                'success': False,
                'error': 'Models not loaded. Run src/train.py first.'
            }), 500
        
        # Check for file in request
        if 'file' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No file provided'
            }), 400
        
        file = request.files['file']
        
        if file.filename == '':
            return jsonify({
                'success': False,
                'error': 'No file selected'
            }), 400
        
        # Read CSV from uploaded file
        try:
            stream = io.StringIO(file.stream.read().decode('utf-8'), newline=None)
            df = pd.read_csv(stream)
        except Exception as e:
            return jsonify({
                'success': False,
                'error': f'Error reading CSV: {str(e)}'
            }), 400
        
        # Validate required columns
        required_features = ['student_id', 'avg_score', 'avg_time_spent', 'chapter_retries']
        missing_cols = [col for col in required_features if col not in df.columns]
        
        if missing_cols:
            return jsonify({
                'success': False,
                'error': f'Missing required columns: {", ".join(missing_cols)}'
            }), 400
        
        # Extract features for prediction
        features = ['avg_score', 'avg_time_spent', 'chapter_retries']
        
        try:
            X_scaled = scaler.transform(df[features])
        except Exception as e:
            return jsonify({
                'success': False,
                'error': f'Error scaling data: {str(e)}'
            }), 400
        
        # Run predictions
        predictions = model.predict(X_scaled)
        probs = model.predict_proba(X_scaled)[:, 1]
        
        # Run analytics
        analytics = AnalyticsEngine()
        risk_list = analytics.identify_at_risk_students(df, predictions, probs)
        difficulty_stats = analytics.detect_chapter_difficulty(df)
        
        # Build response
        response = {
            'success': True,
            'summary': {
                'total_students': len(df),
                'at_risk_count': len(risk_list),
                'predicted_completion_rate': f"{((len(df) - len(risk_list)) / len(df)) * 100:.1f}%"
            },
            'course_insights': difficulty_stats,
            'high_risk_students': risk_list,
            'timestamp': datetime.now().isoformat()
        }
        
        return jsonify(response), 200
    
    except Exception as e:
        return jsonify({
            'success': False,
            'error': f'Server error: {str(e)}'
        }), 500

@app.route('/api/sample-csv', methods=['GET'])
def get_sample_csv():
    """Provide sample CSV format for user reference"""
    sample_data = {
        'student_id': [5000, 5001, 5002],
        'avg_score': [85.5, 72.3, 45.8],
        'avg_time_spent': [12.5, 8.3, 5.2],
        'chapter_retries': [2, 3, 8]
    }
    df = pd.DataFrame(sample_data)
    
    # Return as CSV string
    csv_content = df.to_csv(index=False)
    return csv_content, 200, {'Content-Type': 'text/csv'}

@app.route('/api/export-report', methods=['POST'])
def export_report():
    """Export analysis results as JSON file"""
    try:
        data = request.get_json()
        
        report = {
            'generated_at': datetime.now().isoformat(),
            'summary': data.get('summary'),
            'course_insights': data.get('course_insights'),
            'high_risk_students': data.get('high_risk_students')
        }
        
        return jsonify(report), 200
    
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/model-info', methods=['GET'])
def model_info():
    """Get model metadata and feature information"""
    return jsonify({
        'model_type': 'Random Forest Classifier',
        'n_estimators': 100,
        'features': ['avg_score', 'avg_time_spent', 'chapter_retries'],
        'feature_descriptions': {
            'avg_score': 'Average student score (0-100)',
            'avg_time_spent': 'Average hours spent per chapter',
            'chapter_retries': 'Number of chapter retakes/failures'
        },
        'output': 'Completion probability (0-1)'
    }), 200

if __name__ == '__main__':
    # Load models at startup
    if load_resources():
        print("✓ Models loaded successfully")
        app.run(debug=True, host='0.0.0.0', port=5000)
    else:
        print("✗ Failed to load models")
        app.run(debug=True, host='0.0.0.0', port=5000)
