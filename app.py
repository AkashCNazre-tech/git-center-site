import streamlit as st
import pandas as pd
import joblib
import os
import sys

# This line ensures we can import from your existing 'src' folder
sys.path.append(os.path.abspath(os.path.dirname(__file__)))

from src.analytics import AnalyticsEngine

# --- Page Configuration ---
st.set_page_config(
    page_title="AI Learning Intelligence Tool",
    page_icon="🎓",
    layout="wide"
)

# --- Header ---
st.title("🎓 AI Learning Intelligence Tool")
st.markdown("""
**Internship Assessment Project** This tool predicts student dropout risks and analyzes course difficulty using a Random Forest Classifier.
""")

# --- Model Loading ---
@st.cache_resource
def load_assets():
    # Check if models exist
    if not os.path.exists('models/completion_model.pkl'):
        return None, None
    
    try:
        model = joblib.load('models/completion_model.pkl')
        scaler = joblib.load('models/scaler.pkl')
        return model, scaler
    except Exception as e:
        return None, None

model, scaler = load_assets()

# --- Main Logic ---
if model is None:
    st.error("⚠️ **Model files not found!**")
    st.warning("Please run `python src/train.py` locally and push the `models/` folder to GitHub.")
else:
    # Sidebar for Input
    st.sidebar.header("Upload Data")
    uploaded_file = st.sidebar.file_uploader("Upload Student CSV", type=['csv'])

    # Show sample data format helper
    if not uploaded_file:
        st.info("👋 Please upload a CSV file to start.")
        st.markdown("**Expected CSV Columns:** `student_id`, `avg_score`, `avg_time_spent`, `chapter_retries`")
        
    else:
        # 1. Read Data
        try:
            df = pd.read_csv(uploaded_file)
            st.subheader("1. Raw Data Preview")
            st.dataframe(df.head())

            # 2. Run Analysis Button
            if st.button("🚀 Run AI Analysis", type="primary"):
                with st.spinner("Processing data..."):
                    
                    # --- AI PREDICTION PIPELINE ---
                    # (This logic matches your main.py perfectly)
                    features = ['avg_score', 'avg_time_spent', 'chapter_retries']
                    
                    # Validate columns
                    if not all(col in df.columns for col in features):
                        st.error(f"Missing columns! Input must contain: {features}")
                    else:
                        # Scale and Predict
                        X_scaled = scaler.transform(df[features])
                        predictions = model.predict(X_scaled)
                        probs = model.predict_proba(X_scaled)[:, 1]

                        # --- ANALYTICS ENGINE ---
                        analytics = AnalyticsEngine()
                        risk_list = analytics.identify_at_risk_students(df, predictions, probs)
                        difficulty = analytics.detect_chapter_difficulty(df)

                        # --- DISPLAY RESULTS ---
                        st.success("Analysis Complete!")
                        
                        # Top Metrics
                        m1, m2, m3 = st.columns(3)
                        m1.metric("Total Students", len(df))
                        m2.metric("At Risk Students", len(risk_list), delta_color="inverse")
                        m3.metric("Course Difficulty", difficulty['overall_difficulty'])

                        # Split Layout for details
                        col_left, col_right = st.columns([1, 1])

                        with col_left:
                            st.subheader("⚠️ High Risk Alerts")
                            if risk_list:
                                risk_df = pd.DataFrame(risk_list)
                                st.dataframe(risk_df, use_container_width=True)
                            else:
                                st.success("No high-risk students detected.")

                        with col_right:
                            st.subheader("📊 Difficulty Insights")
                            st.json(difficulty)
                            
        except Exception as e:
            st.error(f"An error occurred during processing: {e}")