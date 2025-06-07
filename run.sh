#!/bin/bash

# Whisper GUI Run Script for Linux/macOS
# This script activates the virtual environment and runs the application

set -e  # Exit on any error

echo "🎙️ Starting Whisper GUI..."
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    print_error "Virtual environment not found!"
    echo "Please run the installation script first:"
    echo "  ./install.sh"
    exit 1
fi

# Check if whisper_gui.py exists
if [ ! -f "whisper_gui.py" ]; then
    print_error "whisper_gui.py not found in current directory"
    exit 1
fi

# Activate virtual environment
print_status "Activating virtual environment..."
source venv/bin/activate

# Check if required packages are installed
print_status "Checking dependencies..."
python -c "import gradio, whisper" 2>/dev/null || {
    print_error "Required packages not found. Please run install.sh first."
    exit 1
}

print_success "Dependencies verified"

# Function to handle cleanup on exit
cleanup() {
    print_status "Shutting down Whisper GUI..."
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Run the application
print_status "Starting Whisper GUI application..."
print_status "The web interface will be available at: http://127.0.0.1:7860"
print_warning "Press Ctrl+C to stop the application"
echo ""

# Start the application
python whisper_gui.py
