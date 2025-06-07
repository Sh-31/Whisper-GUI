#!/bin/bash

# Whisper GUI Installation Script for Linux/macOS
# This script sets up the Python environment and installs dependencies

set -e  # Exit on any error

echo "🚀 Whisper GUI Installation Script"
echo "=================================="

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

# Check if Python is installed
print_status "Checking Python installation..."
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed or not in PATH"
    echo "Please install Python 3.8+ from your package manager:"
    echo "  Ubuntu/Debian: sudo apt install python3 python3-pip python3-venv"
    echo "  CentOS/RHEL: sudo yum install python3 python3-pip"
    echo "  macOS: brew install python3"
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
REQUIRED_VERSION="3.8"

if ! python3 -c "import sys; exit(0 if sys.version_info >= (3,8) else 1)"; then
    print_error "Python version $PYTHON_VERSION is too old. Python 3.8+ is required."
    exit 1
fi

print_success "Python $PYTHON_VERSION found"

# Check if virtual environment already exists
if [ -d "venv" ]; then
    print_warning "Virtual environment already exists"
    read -p "Do you want to recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Removing existing virtual environment..."
        rm -rf venv
    else
        print_status "Using existing virtual environment..."
    fi
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    print_status "Creating Python virtual environment..."
    python3 -m venv venv
    print_success "Virtual environment created"
fi

# Activate virtual environment
print_status "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
print_status "Upgrading pip..."
python -m pip install --upgrade pip

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    print_warning "requirements.txt not found. Creating default requirements..."
    cat > requirements.txt << EOF
gradio>=4.0.0
openai-whisper
torch
torchvision
torchaudio
ffmpeg-python
numpy
EOF
fi

# Install requirements
print_status "Installing Python dependencies..."
pip install -r requirements.txt

# Check for ffmpeg
print_status "Checking for ffmpeg..."
if ! command -v ffmpeg &> /dev/null; then
    print_warning "ffmpeg not found. Installing via package manager..."
    
    # Detect OS and install ffmpeg
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y ffmpeg
        elif command -v yum &> /dev/null; then
            sudo yum install -y ffmpeg
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y ffmpeg
        elif command -v pacman &> /dev/null; then
            sudo pacman -S ffmpeg
        else
            print_error "Could not detect package manager. Please install ffmpeg manually."
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install ffmpeg
        else
            print_error "Homebrew not found. Please install ffmpeg manually."
        fi
    fi
else
    print_success "ffmpeg found"
fi

# Download tiny model for quick start
print_status "Pre-downloading Whisper tiny model for quick start..."
python3 -c "import whisper; whisper.load_model('tiny')" 2>/dev/null || {
    print_warning "Could not pre-download model. It will be downloaded on first use."
}

print_success "Installation completed successfully!"
echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo "To run the application:"
echo "  ./run.sh"
echo ""
echo "Or manually:"
echo "  source venv/bin/activate"
echo "  python whisper_gui.py"
