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
if not exist "tiktok-signature-python" (
    echo [ERROR] tiktok-signature-python not found!
    echo Please run setup.bat first
    pause
    exit /b 1
)

echo [1/3] Starting signature server...
start "TikTok Signature Server" cmd /k "cd tiktok-signature-python && python -m uvicorn main:app --port 8080"

echo Waiting for server to be ready...

:: Poll health endpoint (max ~60s, browser init can take a while)
set ATTEMPT=0

:health_loop
curl -s http://localhost:8080/health >nul 2>&1
if %errorlevel% equ 0 goto server_ready

set /a ATTEMPT+=1
if %ATTEMPT% geq 30 (
    echo [ERROR] Signature server failed to start within 60 seconds
    echo Check the signature server window for errors
    pause
    exit /b 1
)

timeout /t 2 /nobreak >nul
goto health_loop

:server_ready
echo [2/3] Server is ready!

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