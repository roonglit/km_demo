from flask import Flask, request, Response
from pdf2image import convert_from_path
import pytesseract
import os
import subprocess
import logging
import threading
import requests
import uuid

app = Flask(__name__)

# Set up logging
logging.basicConfig(level=logging.INFO)

# Dictionary for simple Unicode to Thai character mapping
unicode_to_thai = {
    "\u0e01": "ก",
    "\u0e02": "ข",
    "\u0e03": "ฃ",
    "\u0e04": "ค",
    "\u0e05": "ฅ",
    "\u0e06": "ฆ",
    "\u0e07": "ง",
    "\u0e08": "จ",
    "\u0e09": "ฉ",
    "\u0e0a": "ช",
    "\u0e0b": "ซ",
    "\u0e0c": "ฌ",
    "\u0e0d": "ญ",
    "\u0e0e": "ฎ",
    "\u0e0f": "ฏ",
    "\u0e10": "ฐ",
    "\u0e11": "ฑ",
    "\u0e12": "ฒ",
    "\u0e13": "ณ",
    "\u0e14": "ด",
    "\u0e15": "ต",
    "\u0e16": "ถ",
    "\u0e17": "ท",
    "\u0e18": "ธ",
    "\u0e19": "น",
    "\u0e1a": "บ",
    "\u0e1b": "ป",
    "\u0e1c": "ผ",
    "\u0e1d": "ฝ",
    "\u0e1e": "พ",
    "\u0e1f": "ฟ",
    "\u0e20": "ภ",
    "\u0e21": "ม",
    "\u0e22": "ย",
    "\u0e23": "ร",
    "\u0e24": "ฤ",
    "\u0e25": "ล",
    "\u0e26": "ฦ",
    "\u0e27": "ว",
    "\u0e28": "ศ",
    "\u0e29": "ษ",
    "\u0e2a": "ส",
    "\u0e2b": "ห",
    "\u0e2c": "ฬ",
    "\u0e2d": "อ",
    "\u0e2e": "ฮ",
    "\u0e2f": "ฯ",
    "\u0e30": "ะ",
    "\u0e31": "ั",
    "\u0e32": "า",
    "\u0e33": "ำ",
    "\u0e34": "ิ",
    "\u0e35": "ี",
    "\u0e36": "ึ",
    "\u0e37": "ื",
    "\u0e38": "ุ",
    "\u0e39": "ู",
    "\u0e3a": "ฺ",
}

def process_pdf_in_background(file_path, callback_url):
    try:
        logging.info("Starting PDF to image conversion")
        # Convert PDF to images
        pages = convert_from_path(file_path, dpi=150)
        logging.info("PDF to image conversion completed")

        extracted_text = ""
        unique_id = str(uuid.uuid4())

        for page_number, page in enumerate(pages, start=1):
            logging.info(f"Processing page {page_number}")
            # Save the page as an image with a unique filename
            page_path = f"/tmp/{unique_id}_page_{page_number}.png"
            page.save(page_path, 'PNG')

            # Preprocess the image using ImageMagick
            preprocessed_path = f"/tmp/{unique_id}_preprocessed_{page_number}.png"
            subprocess.run(["convert", page_path, "-resize", "150%", "-threshold", "50%", preprocessed_path])
            logging.info(f"Preprocessing completed for page {page_number}")

            # Use OCR on the preprocessed image
            text = pytesseract.image_to_string(preprocessed_path, lang='tha', config='--psm 6')
            logging.info(f"OCR completed for page {page_number}")

            # Replace Unicode escape sequences with Thai characters
            for unicode_seq, thai_char in unicode_to_thai.items():
                text = text.replace(unicode_seq, thai_char)

            extracted_text += f"\n--- Page {page_number} ---\n{text}"

            # Clean up the saved files
            os.remove(page_path)
            os.remove(preprocessed_path)
            logging.info(f"Cleaned up temporary files for page {page_number}")

        logging.info("Text extraction completed")
        # Send the extracted text to the callback URL
        response = requests.post(callback_url, json={"extracted_text": extracted_text}, verify=False)
        logging.info(f"Callback response status: {response.status_code}")

    except Exception as e:
        logging.error(f"Error occurred: {str(e)}")
        # Send the error message to the callback URL
        requests.post(callback_url, json={"error": str(e)}, verify=False)

    finally:
        # Clean up the saved file
        os.remove(file_path)
        logging.info("Cleaned up temporary files")

@app.route('/extract_text', methods=['POST'])
def extract_text():
    if 'pdf' not in request.files or 'callback_url' not in request.form:
        logging.error("Missing PDF file or callback URL")
        return Response("Missing PDF file or callback URL", status=400)

    file = request.files['pdf']
    callback_url = request.form['callback_url']
    file_path = f"/tmp/{str(uuid.uuid4())}_uploaded.pdf"
    file.save(file_path)

    # Start background job for processing PDF
    threading.Thread(target=process_pdf_in_background, args=(file_path, callback_url)).start()

    logging.info("Acknowledging request and starting background processing")
    return Response("Request acknowledged. Processing will continue in the background.", status=200)

if __name__ == '__main__':
    # Ensure the 'requests' module is installed
    try:
        import requests
    except ModuleNotFoundError:
        import subprocess
        subprocess.check_call(["python", "-m", "pip", "install", "requests"])
    
    app.run(host='0.0.0.0', port=5000)