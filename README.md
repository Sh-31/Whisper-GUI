# 🎙️ Whisper GUI - Audio Transcription Tool

A user-friendly web interface for OpenAI's Whisper speech recognition model that generates both SRT (subtitle) and TXT (plain text) files from audio.

## ✨ Features

- **Easy-to-use Web Interface** - Built with Gradio for a clean, intuitive experience
- **Multiple Output Formats** - Generates both SRT subtitle files and plain text files
- **Multiple Model Options** - Choose between Tiny, Small, Medium, and Large models
- **Audio Recording Support** - Record audio directly or upload files
- **Wide Format Support** - Supports both audio and video files
- **Real-time Progress** - See transcription progress with detailed status updates
- **Offline Operation** - Works completely offline once models are downloaded
- **Instant Downloads** - Download generated files directly from the interface

## 🚀 Quick Start

### 1. Installation

**Windows (Recommended):**
```cmd
install.bat
```

**Linux/macOS:**
```bash
chmod +x install.sh
./install.sh
```

**PowerShell (Windows):**
```powershell
.\install.ps1
```

This will:
- Check Python installation and version
- Create a Python virtual environment
- Install all required dependencies
- Download the Whisper tiny model for quick start

### 2. Launch the Application

**Windows (Recommended):**
```cmd
run.bat
```

**Linux/macOS:**
```bash
chmod +x run.sh
./run.sh
```

**PowerShell (Windows):**
```powershell
.\run.ps1
```

The web interface will open in your browser at `http://127.0.0.1:7860`

## 🎯 How to Use

1. **Upload Audio/Video File** - Click "Upload Audio/Video File" and select your file, or
2. **Record Audio** - Use the microphone to record audio directly in the browser
3. **Choose Model** - Select from Tiny (fastest), Small, Medium, or Large (most accurate)
4. **Start Transcription** - Click "Start Transcription" button
5. **Download Results** - Download both SRT and TXT files when complete

## 🤖 Model Comparison

| Model | Size | Speed | Accuracy | Memory | Best For |
|-------|------|-------|----------|--------|----------|
| **Tiny** | ~39 MB | Very Fast | Good | ~1GB | Quick transcriptions, testing |
| **Small** | ~244 MB | Fast | Better | ~2GB | General purpose, good balance |
| **Medium** | ~769 MB | Moderate | Very Good | ~5GB | High quality transcriptions |
| **Large** | ~1550 MB | Slow | Excellent | ~10GB | Professional use, best accuracy |

## 📁 File Outputs

### SRT Format (Subtitles)
```
1
00:00:00,000 --> 00:00:04,000
Hello, this is a sample transcription.

2
00:00:04,000 --> 00:00:08,000
The audio has been converted to text with timestamps.
```

### TXT Format (Plain Text)
```
Hello, this is a sample transcription.
The audio has been converted to text with timestamps.
```

## 🔧 System Requirements

- **Python 3.8+**
- **Windows 10/11**
- **2GB RAM minimum** (4GB for Small, 8GB for Medium, 16GB for Large)
- **3GB free disk space** (for models and temporary files)
- **Internet connection** (for initial model download only)
- **Microphone** (optional, for audio recording feature)

## 📦 Dependencies

- `gradio` - Web interface framework
- `openai-whisper` - Speech recognition model
- `torch` - PyTorch for model inference
- `ffmpeg-python` - Audio processing

## 🛠️ Manual Installation

If you prefer manual installation:

**Linux/macOS (Bash):**
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python whisper_gui.py
```

**Windows (PowerShell):**
```powershell
# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt

# Run the application
python whisper_gui.py
```

**Windows (Command Prompt):**
```cmd
# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate.bat

# Install dependencies
pip install -r requirements.txt

# Run the application
python whisper_gui.py
```

## 🎵 Supported Formats

### Audio Files
- MP3, WAV, M4A, FLAC, OGG, WMA
- AIFF, AU, AC3

### Video Files  
- MP4, AVI, MOV, MKV, WEBM, FLV
- WMV, ASF, 3GP

### Recording
- Direct microphone recording in browser
- Real-time audio capture

## 💡 Tips for Best Results

- **Use clear audio** with minimal background noise
- **Choose the right model** - Tiny for speed, Medium/Large for accuracy
- **For long files** (>30 minutes), consider using Medium or Large models
- **Audio quality matters** - Higher bitrate audio gives better results
- **Record in quiet environments** when using the microphone feature
- **Video files work too** - Whisper extracts audio automatically

## 🐛 Troubleshooting

### Common Issues

**"Python is not installed"**
- Install Python 3.8+ from [python.org](https://python.org)
- Make sure Python is added to your system PATH

**"Failed to install requirements"**
- Check your internet connection
- Try running `install.bat` as administrator
- Ensure you have sufficient disk space
- On Windows, make sure PowerShell execution policy allows scripts

**"Model loading failed"**
- Ensure you have enough free disk space
- Check your internet connection for initial download

**"Audio file not supported"**
- Try converting your file to MP3 or WAV format
- Ensure the file is not corrupted
- Check if it's a valid audio/video file

**"Recording not working"**
- Allow microphone permissions in your browser
- Check if your microphone is properly connected
- Try refreshing the page
