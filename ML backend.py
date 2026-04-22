from flask import Flask, request, jsonify
import numpy as np
import joblib

app = Flask(__name__)

# Load model and encoders
model = joblib.load("stress_model.pkl")
wp_encoder = joblib.load("workpressure_encoder.pkl")
y_encoder = joblib.load("target_encoder.pkl")


@app.route("/")
def home():
    return "Stress Prediction API Running"


@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.json

        # Extract inputs
        sleep = float(data["SleepHours"])
        work = float(data["WorkHours"])
        screen = float(data["ScreenTime"])
        work_pressure = data["WorkPressure"]

        # Avoid zero
        sleep = 0.1 if sleep == 0 else sleep
        work = 0.1 if work == 0 else work
        screen = 0.1 if screen == 0 else screen

        # Feature Engineering
        screen_sleep_ratio = screen / sleep
        work_sleep_ratio = work / sleep

        # Encode WorkPressure
        wp_encoded = wp_encoder.transform([[work_pressure]])[0][0]

        # Final feature array (order must match training)
        features = np.array([[sleep, work, screen,
                              screen_sleep_ratio,
                              work_sleep_ratio,
                              wp_encoded]])

        # Prediction
        pred = model.predict(features)

        # Decode label
        stress_level = y_encoder.inverse_transform(pred.reshape(-1, 1))[0][0]

        return jsonify({
            "prediction": stress_level
        })

    except Exception as e:
        return jsonify({"error": str(e)})
        

if __name__ == "__main__":
    app.run(debug=True)