import pandas as pd
import joblib
import os
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report

def train_model():
    # 1. Load Data
    try:
        df = pd.read_csv('data/train_dataset.csv')
    except FileNotFoundError:
        print("Error: train_dataset.csv not found. Run src/data_generator.py first.")
        return

    print("Training AI Model...")
    
   
    features = ['avg_score', 'avg_time_spent', 'chapter_retries']
    X = df[features]
    y = df['completed']

  
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)


    X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)
    
    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)


    accuracy = model.score(X_test, y_test)
    print(f"Model Accuracy: {accuracy:.2f}")

  
    os.makedirs('models', exist_ok=True)
    joblib.dump(model, 'models/completion_model.pkl')
    joblib.dump(scaler, 'models/scaler.pkl')
    
    print("SUCCESS: Model saved to 'models/completion_model.pkl'")

if __name__ == "__main__":
    train_model()