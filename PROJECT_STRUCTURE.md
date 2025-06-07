# 📁 Whisper GUI Project Structure

This document outlines the complete structure and purpose of each file in the Whisper GUI project.

```
Whisper-Gui/
├── 📄 whisper_gui.py          # Main application file
├── 📄 requirements.txt        # Python dependencies
├── 📄 README.md              # Project documentation
├── 📄 PROJECT_STRUCTURE.md   # This file - project overview
├── 🪟 install.bat            # Windows installation script (batch)
├── 🪟 run.bat                # Windows run script (batch)
├── 🔷 install.ps1            # PowerShell installation script
├── 🔷 run.ps1                # PowerShell run script
├── 🐧 install.sh             # Linux/macOS installation script (bash)
├── 🐧 run.sh                 # Linux/macOS run script (bash)
├── 📁 venv/                  # Python virtual environment (created after install)
└── 📁 temp/                  # Temporary files (created at runtime)
```

## 📋 File Descriptions

### Core Application Files

- **`whisper_gui.py`** - The main Python application containing:
  - WhisperGUI class with transcription logic
  - Gradio web interface setup
  - Audio/video processing functions
  - SRT and TXT file generation

- **`requirements.txt`** - Python package dependencies:
  - gradio (web interface)
  - openai-whisper (AI model)
  - torch (PyTorch framework)
  - ffmpeg-python (audio processing)

### Installation Scripts

- **`install.bat`** - Windows batch script for easy setup (most compatible)
- **`install.ps1`** - PowerShell script for advanced Windows users
- **`install.sh`** - Linux/macOS bash script for setup

### Run Scripts

- **`run.bat`** - Windows batch script to start the application (most compatible)
- **`run.ps1`** - PowerShell script to start the application
- **`run.sh`** - Linux/macOS bash script to start the application

### Documentation

- **`README.md`** - Complete project documentation with:
  - Feature overview
  - Installation instructions
  - Usage guide
  - Troubleshooting

## 🔄 Workflow

1. **Installation**: Run appropriate install script for your OS
2. **Execution**: Run appropriate run script for your OS
3. **Usage**: Open browser to http://127.0.0.1:7860
4. **Transcription**: Upload audio/video or record directly

## 🗂️ Generated Directories

- **`venv/`** - Created during installation, contains Python virtual environment
- **`temp/`** - Created at runtime, stores temporary transcription files

## 🎯 Cross-Platform Support

| Platform | Installation | Run | Notes |
|----------|-------------|-----|-------|
| Windows 10/11 | `install.bat` | `run.bat` | Recommended - most compatible |
| Windows (PS) | `install.ps1` | `run.ps1` | Requires execution policy change |
| Linux | `install.sh` | `run.sh` | Requires chmod +x first |
| macOS | `install.sh` | `run.sh` | Requires chmod +x first |

## 🔧 Technical Details

- **Language**: Python 3.8+
- **Framework**: Gradio for web UI
- **AI Model**: OpenAI Whisper
- **Audio Processing**: FFmpeg
- **Package Management**: pip with virtual environment
