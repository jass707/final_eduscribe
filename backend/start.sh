#!/bin/bash
# Render start script for EduScribe backend

echo "🚀 Starting EduScribe Backend..."
echo "📍 PORT: ${PORT:-8001}"
echo "🌐 Host: 0.0.0.0"

# Start the application
exec python optimized_main.py
