# Install necessary libraries


# 1. IMPORT LIBRARIES
from flask import Flask   # ✅ ADDED (fix for your error)

import pytesseract
import cv2
import numpy as np
from PIL import Image
import os

# 2. CONFIGURE TESSERACT PATH (IMPORTANT for Windows)
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# 3. INITIALIZE APP
app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# 4. IMAGE PREPROCESSING FUNCTION
def preprocess_image(image_path):
    img = cv2.imread(image_path)

    # Convert to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Noise removal
    blur = cv2.GaussianBlur(gray, (5,5), 0)

    # Thresholding
    _, thresh = cv2.threshold(blur, 150, 255, cv2.THRESH_BINARY)

    return thresh

# 5. OCR FUNCTION
def extract_text(image_path):
    processed_img = preprocess_image(image_path)

    # Convert OpenCV image to PIL
    pil_img = Image.fromarray(processed_img)

    # OCR
    text = pytesseract.image_to_string(pil_img)

    return text