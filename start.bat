@echo off
setlocal enabledelayedexpansion

:: TikTok Scraper Start Script for Windows
title TikTok Scraper

echo.
echo ================================================================
echo                   Starting TikTok Scraper
echo ================================================================
echo.

:: Check if setup exists
if not exist "tiktok-signature" (
    echo [ERROR] tiktok-signature not found!
    echo Please run setup.bat first
    pause
    exit /b 1
)

if not exist "tiktok-signature\node_modules" (
    echo [ERROR] tiktok-signature dependencies not installed!
    echo Please run setup.bat first
    pause
    exit /b 1
)

echo [1/3] Starting signature server...
start "TikTok Signature Server" cmd /k "cd tiktok-signature && npm start"

echo Waiting for server to be ready...
timeout /t 5 /nobreak >nul

:: Check if server is running
echo [2/3] Checking server health...
curl -s http://localhost:8080/health >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Server may not be fully ready yet
    echo Waiting additional 5 seconds...
    timeout /t 5 /nobreak >nul
)

echo [3/3] Starting scraper CLI...
echo.
echo ================================================================
echo.

python tiktok_cli.py

echo.
echo ================================================================
echo Scraping session completed!
echo Close the signature server window when done.
echo ================================================================
pause