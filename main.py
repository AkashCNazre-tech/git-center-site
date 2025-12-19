import argparse
import pandas as pd
import joblib
import json
import sys
import os
from src.analytics import AnalyticsEngine


MODEL_PATH = 'models/completion_model.pkl'
SCALER_PATH = 'models/scaler.pkl'

def load_resources():
    """Loads the saved ML model and Scaler."""
    if not os.path.exists(MODEL_PATH) or not os.path.exists(SCALER_PATH):
        print("\n[ERROR] Model files missing!")
        print("Please run: python src/train.py")
        sys.exit(1)
    return joblib.load(MODEL_PATH), joblib.load(SCALER_PATH)

def run_analysis(input_file, output_file):
    print("\n--- AI Learning Intelligence Tool ---")
    
 
    print(f"[1/4] Loading data from {input_file}...")
    try:
        df = pd.read_csv(input_file)
    except Exception as e:
        print(f"[ERROR] Could not read CSV: {e}")
        sys.exit(1)

   
    model, scaler = load_resources()

   
    print("[2/4] Running AI Inference...")
    features = ['avg_score', 'avg_time_spent', 'chapter_retries']
    
    try:
        X_scaled = scaler.transform(df[features])
    except KeyError as e:
        print(f"[ERROR] Input CSV is missing required columns: {e}")
        sys.exit(1)
        
    predictions = model.predict(X_scaled)          
    probs = model.predict_proba(X_scaled)[:, 1]    

    
    print("[3/4] Generating Analytics...")
    analytics = AnalyticsEngine()
    
    
    risk_list = analytics.identify_at_risk_students(df, predictions, probs)
    
    
    difficulty_stats = analytics.detect_chapter_difficulty(df)

    
    final_report = {
        "summary": {
            "total_students": len(df),
            "at_risk_count": len(risk_list),
            "predicted_completion_rate": f"{((len(df) - len(risk_list)) / len(df)) * 100:.1f}%"
        },
        "course_insights": difficulty_stats,
        "action_items": {
            "high_risk_students": risk_list
        }
    }

   
    print(f"[4/4] Saving report to {output_file}...")
    with open(output_file, 'w') as f:
        json.dump(final_report, f, indent=4)

    print("\nSUCCESS! Analysis Complete.")
    print(f"View results: {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run AI Analysis on Student Data")
    parser.add_argument('--input', type=str, required=True, help="Path to input CSV")
    parser.add_argument('--output', type=str, default='data/final_report.json', help="Path to output JSON")
    
    args = parser.parse_args()
    
    run_analysis(args.input, args.output)