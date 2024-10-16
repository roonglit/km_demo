# Dockerfile for OCR API using Flask and Tesseract

# Step 1: Use the official Python image as the base
FROM python:3.9-slim

# Step 2: Install system dependencies for Tesseract and PDF tools
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-tha \
    libsm6 libxext6 libxrender-dev \
    poppler-utils \
    imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Step 3: Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Step 4: Set up the application directory
WORKDIR /app
COPY . /app

# Step 5: Expose the port the app will run on
EXPOSE 5000

# Step 6: Command to run the application
CMD ["python", "app.py"]