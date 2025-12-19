class AnalyticsEngine:
    
    @staticmethod
    def detect_chapter_difficulty(df):
        """
        Analyzes student performance to estimate chapter difficulty.
        Since we don't have raw chapter logs, we infer it from average student struggle.
        """
        avg_score = df['avg_score'].mean()
        avg_retries = df['chapter_retries'].mean()
        
        
        difficulty_index = (avg_retries * 20) + (100 - avg_score)
        
        status = "Medium"
        if difficulty_index > 60:
            status = "Hard"
        elif difficulty_index < 30:
            status = "Easy"
            
        return {
            "overall_difficulty": status,
            "avg_student_score": round(avg_score, 1),
            "avg_retries_per_chapter": round(avg_retries, 1)
        }

    @staticmethod
    def identify_at_risk_students(df, predictions, probabilities):
        """
        Combines AI predictions with rules to flag high-risk students.
        """
        risk_report = []
        
        for idx, row in df.iterrows():
            is_completing = predictions[idx]
            confidence = probabilities[idx]
            
          
            if is_completing == 0 or row['avg_score'] < 40:
                risk_report.append({
                    "student_id": int(row['student_id']),
                    "predicted_outcome": "Dropout",
                    "risk_probability": f"{round((1 - confidence) * 100, 1)}%",
                    "current_score": row['avg_score']
                })
                
        return risk_report