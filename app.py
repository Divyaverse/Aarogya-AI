import os
import requests
import fitz  # PyMuPDF for PDF parsing
from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import joblib
import cv2
import pytesseract
from werkzeug.utils import secure_filename

app = Flask(__name__)
# Enable CORS for the flutter app to call the API without cross-origin issues
CORS(app)

# --- Configuration & Initialization ---
UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), 'uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "pdf"}

# --- Supabase Configuration ---
# Note: Using the REST API via requests to bypass the python package installation error
SUPABASE_URL = "https://wrbddhbtzvqnscnckoxkq.supabase.co"
SUPABASE_KEY = "sb_publishable_AmgFX00vdM8ipW_4yCbhnA_OSyzcrOH" # Removed the '-publishable key' text

def save_to_supabase(table_name, data_payload):
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Content-Type": "application/json",
        "Prefer": "return=representation"
    }
    url = f"{SUPABASE_URL}/rest/v1/{table_name}"
    try:
        # Run asynchronously or just log errors if the table doesn't exist yet
        response = requests.post(url, json=data_payload, headers=headers)
        if response.status_code not in (200, 201):
            print(f"Failed to save to Supabase. Status: {response.status_code}, Response: {response.text}")
    except Exception as e:
        print(f"Supabase connection exception: {e}")


# Setup paths relative to current directory correctly finding the ML folder
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# Note: Models are in ../ML/ folder relative to Backend
MODEL_PATH = os.path.join(BASE_DIR, '..', 'ML', 'stress_model.pkl')

print(f"Loading model from: {MODEL_PATH}")
stress_model = joblib.load(MODEL_PATH)

def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS

# WorkPressure and Target Mapping as derived from XG_boost.py
wp_mapping = {'Low': 0.0, 'Medium': 1.0, 'High': 2.0, '0 = Minimal': 0.0, '1 = Manageable': 1.0, '2 = High': 2.0}
result_mapping = {0.0: 'Low', 1.0: 'Medium', 2.0: 'High'}

@app.route("/")
def home():
    return jsonify({"message": "Arogya AI API Running"})

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.json
        print("Received prediction request:", data)
        
        # Extract inputs from frontend JSON payload
        sleep = float(data.get("SleepHours", 0))
        work = float(data.get("WorkHours", 0))
        screen = float(data.get("ScreenTime", 0))
        physical_activity = float(data.get("PhysicalActivityMin", 0))
        mood_score = float(data.get("MoodScore", 5))
        caffeine_intake = float(data.get("CaffeineIntake", 0))
        
        # Ensure avoiding division by zero
        sleep = 0.1 if sleep == 0 else sleep
        work = 0.1 if work == 0 else work
        screen = 0.1 if screen == 0 else screen

        # Extract textual pressure, if 'WorkPressure' relies on dropdown strings
        work_pressure_str = data.get("WorkPressure", 'Medium')
        wp_encoded = wp_mapping.get(work_pressure_str, 1.0)
        
        # Feature Engineering from XG_boost.py
        screen_sleep_ratio = screen / sleep
        work_sleep_ratio = work / sleep

        # Final feature array (order MUST match training)
        # Order: SleepHours, WorkHours, ScreenTime, PhysicalActivityMin, MoodScore, WorkPressure, CaffeineIntake, Screen_Sleep_Ratio, Work_Sleep_Ratio
        features = np.array([[sleep, work, screen, physical_activity, mood_score, wp_encoded, caffeine_intake, screen_sleep_ratio, work_sleep_ratio]])

        # Prediction
        pred = stress_model.predict(features)
        
        # Decode label
        pred_value = float(pred[0])
        stress_level = result_mapping.get(pred_value, 'Medium')
        percentage = (pred_value + 1) * 33

        # Save assessment to Supabase
        db_payload = {
            "Sleephours": sleep,
            "workHours": work,
            "ScreenTime": screen,
            "WorkPressure": str(work_pressure_str),
            "StressLevel": stress_level
        }
        # Calling the REST API directly
        save_to_supabase("Predictions", db_payload)

        return jsonify({
            "prediction": stress_level,
            "percentage": percentage
        })

    except Exception as e:
        print("Error in /predict:", str(e))
        return jsonify({"error": str(e)}), 500


@app.route('/upload', methods=['POST'])
def upload():
    try:
        if 'file' not in request.files:
            print("Missing 'file' in request.files. payload:", request.files)
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files['file']

        if file.filename == "":
            print("Empty filename")
            return jsonify({"error": "Empty filename"}), 400

        if not allowed_file(file.filename):
            print(f"Invalid file type: {file.filename}")
            return jsonify({"error": "Invalid file type"}), 400

        filename = secure_filename(file.filename)
        path = os.path.join(UPLOAD_FOLDER, filename)
        file.save(path)

        text = ""

        # Handle PDF files
        if filename.lower().endswith('.pdf'):
            try:
                doc = fitz.open(path)
                for page in doc:
                    text += page.get_text() + "\n"
                text = text.strip()
                if not text:
                    text = "[System Notice: The PDF contains no text layer and OCR is unavailable. Mock Text below]\n\nPatient prescribed:\n- Amoxicillin 500mg\n- Paracetamol 650mg\nNotes: Rest and drink plenty of water."
            except Exception as e:
                print(f"Failed to read PDF via PyMuPDF: {e}")
                return jsonify({"error": "Failed to read PDF file."}), 400
        
        # Handle Image files
        else:
            img = cv2.imread(path)
            if img is None:
                 print(f"Failed to read image via cv2.imread: {path}")
                 return jsonify({"error": "Failed to read image. Ensure it is a valid format."}), 400
                 
            # Grayscale
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            # Noise removal
            gray = cv2.medianBlur(gray, 3)
            # Thresholding
            _, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY)
            
            try:
                text = pytesseract.image_to_string(thresh)
                text = text.strip()
                if not text:
                    text = "No text could be extracted."
            except Exception as e:
                print("Tesseract not installed or failed! Falling back to mock text. Error:", str(e))
                text = "[System Notice: Tesseract OCR is not installed. Mock Text below]\n\nPatient prescribed:\n- Amoxicillin 500mg\n- Paracetamol 650mg\nNotes: Rest and drink plenty of water."

        # Optionally cleanup the file to save space
        # os.remove(path)

        return jsonify({
            "extracted_text": text
        })

    except Exception as e:
        print("Error in /upload:", str(e))
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
