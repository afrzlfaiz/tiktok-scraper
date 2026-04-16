# 🎵 TikTok Search Scraper

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](https://python.org)
[![Node](https://img.shields.io/badge/Node.js-18%2B-green)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

API-based TikTok video scraper with signature generation and multiple export formats.

## ✨ Features

- 🔍 Search TikTok videos by keyword
- 📊 Get detailed video stats (views, likes, comments, shares)
- 💾 Export to JSON, CSV, or Excel format
- 🎨 Beautiful CLI with colored output
- 🚀 Fast async scraping
- 🔄 Automatic pagination handling

## 📋 Requirements

- Python 3.8+
- Node.js 18+
- npm
- Git (optional, for auto-download)

## 🚀 Quick Start

### One-Command Setup & Run

**Linux/Mac:**

git clone https://github.com/afrzlfaiz/tiktok-scraper.git
cd tiktok-scraper
chmod +x setup.sh start.sh
./setup.sh
./start.sh

**Windows:**

git clone https://github.com/afrzlfaiz/tiktok-scraper.git
cd tiktok-scraper
setup.bat
start.bat

### Manual Setup

# 1. Install Python dependencies
pip install -r requirements.txt

# 2. Clone & setup signature server
git clone https://github.com/carcabot/tiktok-signature.git
cd tiktok-signature
npm install
npx puppeteer browsers install chromium
cd ..

# 3. Run signature server (Terminal 1)
cd tiktok-signature && npm start

# 4. Run scraper (Terminal 2)
python tiktok_cli.py

## 📖 Usage Example

After starting both servers, you'll see:

============================================================
  T I K T O K   S E A R C H   S C R A P E R
============================================================

📋 SEARCH PARAMETERS
──────────────────────────────────────────────────
🔍 Keyword: iran
📊 Number of videos (default 30): 25

💾 EXPORT OPTIONS
──────────────────────────────────────────────────
Select format:
  [1] JSON (.json)
  [2] CSV (.csv)
  [3] Excel (.xlsx)

## 📁 Output Example

### JSON Output
{
  "total": 25,
  "exported_at": "2026-04-16T22:30:45",
  "videos": [
    {
      "no": 1,
      "video_id": "7604314750763224340",
      "username": "ijomah77",
      "caption": "EmBeGe 😎 #minecraft",
      "plays": 1600000,
      "likes": 16600,
      "url": "https://www.tiktok.com/@ijomah77/video/7604314750763224340"
    }
  ]
}

### Excel Output
- 📊 Header merah dengan teks putih
- 📏 Auto-width columns
- 📈 Ready for analysis

## 🔧 Troubleshooting

### "Signature server not running"
Make sure the signature server is started:
cd tiktok-signature
npm start

### "Chromium not found"
Install Chromium manually:
cd tiktok-signature
npx puppeteer browsers install chromium

### Port 8080 already in use
Change the port or kill the existing process:

Linux/Mac:
lsof -i :8080
kill -9 PID

Windows:
netstat -ano | findstr :8080
taskkill /PID PID /F

## 📦 Project Structure

tiktok-scraper/
├── tiktok_cli.py          # Main CLI application
├── requirements.txt       # Python dependencies
├── setup.sh               # Linux/Mac setup script
├── start.sh               # Linux/Mac start script
├── setup.bat              # Windows setup script
├── start.bat              # Windows start script
├── README.md              # Documentation
└── tiktok-signature/      # Signature server (setup creates this)

## 🙏 Credits

This project relies on the amazing work of others:

- carcabot/tiktok-signature - https://github.com/carcabot/tiktok-signature
  Signature generation service that makes TikTok API access possible
  
- TikTok API research from various open-source contributors

If you find this tool useful, please consider starring both repositories!

## ⚠️ Disclaimer

This tool is for educational purposes only. Please respect TikTok's Terms of Service and rate limits. The author is not responsible for any misuse of this tool.