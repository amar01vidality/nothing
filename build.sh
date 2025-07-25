#!/usr/bin/env bash
# Build script for Render deployment

set -o errexit  # Exit on error

echo "🚀 Starting build process..."

# Upgrade pip
echo "📦 Upgrading pip..."
pip install --upgrade pip

# Install system dependencies
echo "🔧 Installing system dependencies..."
apt-get update
apt-get install -y \
    tesseract-ocr \
    poppler-utils \
    build-essential \
    wget \
    gcc \
    make \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    libta-lib0 \
    libta-lib0-dev

# Optional: Build TA-Lib from source if the system package doesn't work
# echo "🧱 Building TA-Lib from source..."
# wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
# tar -xvzf ta-lib-0.4.0-src.tar.gz
# cd ta-lib/
# ./configure --prefix=/usr
# make
# make install
# cd ..

# Install Python dependencies
echo "📚 Installing Python dependencies..."
pip install -r requirements.txt

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p logs data qlib_data temp

# Set proper permissions
echo "🔐 Setting permissions..."
chmod +x main.py

# Initialize database if needed
echo "🗄️ Initializing database..."
python -c "from models import init_db; init_db()" || echo "Database initialization skipped or failed"

# Setup qlib data
echo "📊 Setting up qlib data..."
python -c "from qlib_service import QlibService; QlibService().initialize_qlib()" || echo "Qlib initialization skipped"

echo "✅ Build completed successfully!"
