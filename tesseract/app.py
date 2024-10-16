from flask import Flask, request, Response
from pdf2image import convert_from_path
import pytesseract
import os
import subprocess
from concurrent.futures import ThreadPoolExecutor

app = Flask(__name__)

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

# Function to process each page
def process_page(page_number, page):
    # Save the page as an image
    page_path = f"/tmp/page_{page_number}.png"
    page.save(page_path, 'PNG')

    # Preprocess the image using ImageMagick
    preprocessed_path = f"/tmp/preprocessed_{page_number}.png"
    subprocess.run(["convert", page_path, "-resize", "150%", "-threshold", "50%", preprocessed_path])

    # Use OCR on the preprocessed image
    text = pytesseract.image_to_string(preprocessed_path, lang='tha', config='--psm 6')

    # Replace Unicode escape sequences with Thai characters
    for unicode_seq, thai_char in unicode_to_thai.items():
        text = text.replace(unicode_seq, thai_char)

    # Clean up the saved files
    os.remove(page_path)
    os.remove(preprocessed_path)

    return f"\n--- Page {page_number} ---\n{text}"

@app.route('/extract_text', methods=['POST'])
def extract_text():
    if 'pdf' not in request.files:
        return Response("No PDF file uploaded", status=400)

    file = request.files['pdf']
    file_path = "/tmp/uploaded.pdf"
    file.save(file_path)

    try:
        # Convert PDF to images
        pages = convert_from_path(file_path, dpi=150)

        extracted_text = ""
        with ThreadPoolExecutor() as executor:
            results = list(executor.map(lambda p: process_page(*p), enumerate(pages, start=1)))

        extracted_text = "".join(results)

        return Response(extracted_text, content_type='text/plain; charset=utf-8')

    except Exception as e:
        return Response(f"Error: {str(e)}", status=500)

    finally:
        # Clean up the saved file
        os.remove(file_path)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)