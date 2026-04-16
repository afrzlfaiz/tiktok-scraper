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
echo [1/5] Checking Python...
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

:: Check Node.js
echo [2/5] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js not found! Please install Node.js 18+
    echo         Download from: https://nodejs.org/
    pause
    exit /b 1
)
node --version
echo [OK] Node.js found
echo.

:: Install Python dependencies
echo [3/5] Installing Python dependencies...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [WARNING] Some Python dependencies may have failed to install
)
echo [OK] Python dependencies installed
echo.

:: Clone/download tiktok-signature
echo [4/5] Setting up tiktok-signature...
if exist "tiktok-signature" (
    echo tiktok-signature already exists
) else (
    echo Downloading tiktok-signature...
    
    :: Try git first
    git --version >nul 2>&1
    if %errorlevel% equ 0 (
        git clone https://github.com/carcabot/tiktok-signature.git
    ) else (
        :: Fallback to PowerShell download
        echo Git not found, downloading via PowerShell...
        powershell -Command "Invoke-WebRequest -Uri 'https://github.com/carcabot/tiktok-signature/archive/refs/heads/main.zip' -OutFile 'tiktok-signature.zip'"
        powershell -Command "Expand-Archive -Path 'tiktok-signature.zip' -DestinationPath '.'"
        move tiktok-signature-main tiktok-signature
        del tiktok-signature.zip
    )
)

cd tiktok-signature
echo Installing Node.js dependencies...
call npm install
echo Installing Chromium...
call npx puppeteer browsers install chromium
cd ..

echo [OK] tiktok-signature setup complete
echo.

echo ================================================================
echo                      SETUP COMPLETE!
echo ================================================================
echo.
echo To start scraping, run: start.bat
echo.
echo Or manually:
echo   Terminal 1: cd tiktok-signature ^&^& npm start
echo   Terminal 2: python tiktok_cli.py
echo.

pause