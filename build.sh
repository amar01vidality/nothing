!/usr/bin/env bash
# Build script for Render deployment

set -o errexit  # Exit on error

echo "🚀 Starting build process..."

# Upgrade pip
echo "📦 Upgrading pip..."
python -m pip install --upgrade pip

# Install Python dependencies with specific flags for Render
echo "📚 Installing Python dependencies..."
pip install --no-cache-dir --upgrade -r requirements.txt

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p logs
mkdir -p data
mkdir -p temp
mkdir -p .config/matplotlib

# Set matplotlib backend for headless environment
echo "🎨 Configuring matplotlib..."
echo "backend: Agg" > .config/matplotlib/matplotlibrc

# Set proper permissions
echo "🔐 Setting permissions..."
chmod +x main.py

echo "✅ Build completed successfully!"
