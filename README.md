# TikTok Search Scraper

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](https://python.org)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-green)](https://nodejs.org)

A CLI scraper for searching TikTok videos by keyword using an external signature server. Search results can be exported to JSON, CSV, or Excel.

## Features

- Search TikTok videos by keyword
- Collect video stats such as views, likes, comments, shares, and collects
- Export results to `JSON`, `CSV`, or `XLSX`
- Interactive CLI with scraping progress output
- Setup and start scripts for Windows and Linux/macOS

## Requirements

- Python 3.8+
- Node.js 18+
- npm
- Internet connection
- Git is optional because the setup script includes a download fallback in some cases

## Quick Start

### Windows

```powershell
git clone https://github.com/afrzlfaiz/tiktok-scraper.git
cd tiktok-scraper
.\setup.bat
.\start.bat
```

### Linux/macOS

```bash
git clone https://github.com/afrzlfaiz/tiktok-scraper.git
cd tiktok-scraper
chmod +x setup.sh start.sh
./setup.sh
./start.sh
```

## Manual Setup

If you do not want to use the automated scripts, run the steps below.

### 1. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 2. Set up the signature server

```bash
git clone https://github.com/carcabot/tiktok-signature.git
cd tiktok-signature
npm install
npx puppeteer browsers install chromium
cd ..
```

### 3. Start the signature server

```bash
cd tiktok-signature
npm start
```

The default server runs at:

```text
http://localhost:8080
```

### 4. Run the scraper CLI

```bash
python tiktok_cli.py
```

## Usage Flow

When the CLI starts, it will prompt you to:

1. Enter a search keyword
2. Choose how many videos to fetch
3. Decide whether to export the results
4. Select an export format: `JSON`, `CSV`, or `XLSX`
5. Choose where to save the exported file

The default filename uses a format like:

```text
tiktok_export_YYYYMMDD_HHMMSS.json
```

## Example Output

### JSON

```json
{
  "total": 25,
  "exported_at": "2026-04-16T22:30:45",
  "videos": [
    {
      "no": 1,
      "video_id": "7604314750763224340",
      "url": "https://www.tiktok.com/@example/video/7604314750763224340",
      "username": "example",
      "nickname": "Example User",
      "caption": "Sample caption",
      "plays": 1600000,
      "likes": 16600,
      "comments": 240,
      "shares": 90
    }
  ]
}
```

### Exported fields

The exported data includes fields such as:

- `video_id`
- `url`
- `username`
- `nickname`
- `caption`
- `create_time`
- `duration`
- `plays`
- `likes`
- `comments`
- `shares`
- `collects`
- `followers`
- `music`
- `cover`
- `play_url`

## Troubleshooting

### Signature server is not running

If the CLI reports that the signature server is not active, run:

```bash
cd tiktok-signature
npm start
```

### Chromium is not installed

```bash
cd tiktok-signature
npx puppeteer browsers install chromium
```

### Port `8080` is already in use

The signature server uses port `8080` by default. Make sure no other process is already using that port.

Windows:

```powershell
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

Linux/macOS:

```bash
lsof -i :8080
kill -9 <PID>
```

### `tiktok-signature` directory is missing

Run the setup script first:

Windows:

```powershell
.\setup.bat
```

Linux/macOS:

```bash
./setup.sh
```

## Project Structure

```text
tiktok-scraper/
|-- tiktok_cli.py
|-- requirements.txt
|-- setup.bat
|-- setup.sh
|-- start.bat
|-- start.sh
|-- README.md
`-- tiktok-signature/   # created during setup
```

## Python Dependencies

Current contents of `requirements.txt`:

- `aiohttp`
- `openpyxl`

## Credits

This project depends on:

- `carcabot/tiktok-signature`: https://github.com/carcabot/tiktok-signature

## Disclaimer

This tool is intended for learning and experimentation. Make sure you follow TikTok's Terms of Service, rate limits, and any applicable data usage rules.
