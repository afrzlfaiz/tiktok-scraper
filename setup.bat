@echo off
setlocal enabledelayedexpansion

:: TikTok Scraper Setup Script for Windows
title TikTok Scraper - Setup

echo.
echo ================================================================
echo                    TikTok Scraper Setup
echo ================================================================
echo.

:: Check Python
echo [1/4] Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python not found! Please install Python 3.8+
    echo         Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)
python --version
echo [OK] Python found
echo.

:: Install Python dependencies
echo [2/4] Installing Python dependencies...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [WARNING] Some Python dependencies may have failed to install
)
echo [OK] Python dependencies installed
echo.

:: Clone/download tiktok-signature-python
echo [3/4] Setting up tiktok-signature-python...
if exist "tiktok-signature-python" (
    echo tiktok-signature-python already exists
) else (
    echo Downloading tiktok-signature-python...

    :: Try git first
    git --version >nul 2>&1
    if %errorlevel% equ 0 (
        git clone https://github.com/afrzlfaiz/tiktok-signature-python.git
    ) else (
        :: Fallback to PowerShell download
        echo Git not found, downloading via PowerShell...
        powershell -Command "Invoke-WebRequest -Uri 'https://github.com/afrzlfaiz/tiktok-signature-python/archive/refs/heads/main.zip' -OutFile 'tiktok-signature-python.zip'"
        powershell -Command "Expand-Archive -Path 'tiktok-signature-python.zip' -DestinationPath '.'"
        move tiktok-signature-python-main tiktok-signature-python
        del tiktok-signature-python.zip
    )
)

cd tiktok-signature-python
echo Installing Python dependencies...
call pip install -r requirements.txt
echo Installing Chromium for Playwright...
python -m playwright install chromium
cd ..

echo [OK] tiktok-signature-python setup complete
echo.

echo ================================================================
echo                      SETUP COMPLETE!
echo ================================================================
echo.
echo To start scraping, run: start.bat
echo.
echo Or manually:
echo   Terminal 1: cd tiktok-signature-python ^&^& python -m uvicorn main:app --port 8080
echo   Terminal 2: python tiktok_cli.py
echo.

pause