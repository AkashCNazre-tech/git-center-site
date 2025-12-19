import pandas as pd
import numpy as np
import os

def generate_data():
    """Generates synthetic student data for training and testing."""
    np.random.seed(42)
    
   
    os.makedirs('data', exist_ok=True)

   
    print("Generating training data...")
    data = []
    for i in range(1000):
        student_id = 1000 + i
        avg_score = np.random.normal(70, 15)      
        avg_score = np.clip(avg_score, 0, 100)
        time_spent = np.random.normal(45, 10)     
        chapter_retries = np.random.randint(0, 5)  
        
        
        if avg_score > 60 and chapter_retries < 4:
            completed = 1
        else:
            completed = 0
            
        data.append([student_id, avg_score, time_spent, chapter_retries, completed])

    df_train = pd.DataFrame(data, columns=['student_id', 'avg_score', 'avg_time_spent', 'chapter_retries', 'completed'])
    df_train.to_csv('data/train_dataset.csv', index=False)
    

    print("Generating input data for the tool...")
    input_data = []
    for i in range(50):
        student_id = 5000 + i
        avg_score = np.random.normal(65, 20)
        avg_score = np.clip(avg_score, 0, 100)
        time_spent = np.random.normal(40, 15)
        chapter_retries = np.random.randint(0, 6)
       
        input_data.append([student_id, avg_score, time_spent, chapter_retries])

    df_input = pd.DataFrame(input_data, columns=['student_id', 'avg_score', 'avg_time_spent', 'chapter_retries'])
    df_input.to_csv('data/new_students_input.csv', index=False)

    print("SUCCESS: Data generated in 'data/' folder.")

if __name__ == "__main__":
    generate_data()