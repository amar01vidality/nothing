#!/usr/bin/env bash
# Build script for Render deployment

set -o errexit  # Exit on error

echo "🚀 Starting build process..."

# Upgrade pip
echo "📦 Upgrading pip..."
pip install --upgrade pip

# Install system dependencies for TA-Lib and image processing
echo "🔧 Installing system dependencies..."
apt-get update
apt-get install -y tesseract-ocr poppler-utils build-essential wget

# Install TA-Lib from source
echo "📈 Installing TA-Lib C library..."
wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
tar -xvzf ta-lib-0.4.0-src.tar.gz
cd ta-lib
./configure --prefix=/usr
make
make install
cd ..

# Export environment variables for compiler
export CFLAGS="-I/usr/include"
export LDFLAGS="-L/usr/lib"

# Install Python dependencies
echo "📚 Installing Python dependencies..."
pip install -r requirements.txt

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p logs
mkdir -p data
mkdir -p qlib_data
mkdir -p temp

# Set proper permissions
echo "🔐 Setting permissions..."
chmod +x main.py

# Initialize database if needed
echo "🗄️ Initializing database..."
python -c "from models import init_db; init_db()" || echo "Database initialization skipped or failed"

# Download and setup qlib data (if needed)
echo "📊 Setting up qlib data..."
python -c "from qlib_service import QlibService; QlibService().initialize_qlib()" || echo "Qlib initialization skipped"

echo "✅ Build completed successfully!"
