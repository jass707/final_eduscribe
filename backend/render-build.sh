#!/bin/bash
# Render build script for EduScribe backend

echo "🚀 Starting Render build..."

# Upgrade pip
echo "📦 Upgrading pip..."
pip install --upgrade pip

# Install dependencies
echo "📦 Installing dependencies..."
pip install -r requirements-railway.txt

echo "✅ Build complete!"
