# Whisper GUI Run Script for PowerShell# This script activates the virtual environment and runs the applicationparam(    [switch]$Verbose,    [string]$Port = "7860",    [string]$Host = "127.0.0.1")# Enable verbose output if requestedif ($Verbose) {    $VerbosePreference = "Continue"}Write-Host "🎙️ Starting Whisper GUI..." -ForegroundColor BlueWrite-Host "==========================" -ForegroundColor Blue# Function to write colored outputfunction Write-Status {    param($Message)    Write-Host "[INFO] $Message" -ForegroundColor Cyan}function Write-Success {    param($Message)    Write-Host "[SUCCESS] $Message" -ForegroundColor Green}function Write-Warning {    param($Message)    Write-Host "[WARNING] $Message" -ForegroundColor Yellow}function Write-Error-Custom {    param($Message)    Write-Host "[ERROR] $Message" -ForegroundColor Red}# Check if virtual environment existsif (-not (Test-Path "venv")) {    Write-Error-Custom "Virtual environment not found!"    Write-Host "Please run the installation script first:" -ForegroundColor Yellow    Write-Host "  .\install.ps1" -ForegroundColor Cyan    exit 1}# Check if whisper_gui.py existsif (-not (Test-Path "whisper_gui.py")) {    Write-Error-Custom "whisper_gui.py not found in current directory"    exit 1}# Activate virtual environmentWrite-Status "Activating virtual environment..."try {    & ".\venv\Scripts\Activate.ps1"    Write-Success "Virtual environment activated"}catch {    Write-Error-Custom "Failed to activate virtual environment"
    Write-Warning "You may need to change PowerShell execution policy:"
    Write-Host "Run as Administrator: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
    exit 1
}

# Check if required packages are installed
Write-Status "Checking dependencies..."
try {
    python -c "import gradio, whisper" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Dependencies verified"
    }
    else {
        throw "Dependencies not found"
    }
}
catch {
    Write-Error-Custom "Required packages not found. Please run install.ps1 first."
    exit 1
}

# Function to handle cleanup on exit
function Cleanup {
    Write-Status "Shutting down Whisper GUI..."
    exit 0
}

# Set up Ctrl+C handler
[Console]::TreatControlCAsInput = $false
[Console]::CancelKeyPress += {
    Cleanup
}

# Run the application
Write-Status "Starting Whisper GUI application..."
Write-Status "The web interface will be available at: http://${Host}:${Port}"
Write-Warning "Press Ctrl+C to stop the application"
Write-Host ""

# Start the application
try {
    python whisper_gui.py
}
catch {
    Write-Error-Custom "Failed to start the application: $_"
    exit 1
}
finally {
    Cleanup
}
