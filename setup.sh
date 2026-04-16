#!/bin/bash

# TikTok Scraper Setup Script
# Usage: ./setup.sh

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                                  ║"
    echo "║        ${GREEN}TikTok Scraper - Automated Setup${CYAN}                         ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_step() {
    echo -e "\n${CYAN}📦 $1${NC}"
}

# Check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup
main() {
    clear
    print_banner
    
    # Check Python
    print_step "Checking Python..."
    if command_exists python3; then
        PYTHON_CMD="python3"
        print_success "Python 3 found: $(python3 --version)"
    elif command_exists python; then
        PYTHON_CMD="python"
        print_success "Python found: $(python --version)"
    else
        print_error "Python not found! Please install Python 3.8+"
        exit 1
    fi
    
    # Check pip
    print_step "Checking pip..."
    if command_exists pip3; then
        PIP_CMD="pip3"
        print_success "pip3 found"
    elif command_exists pip; then
        PIP_CMD="pip"
        print_success "pip found"
    else
        print_error "pip not found! Please install pip"
        exit 1
    fi
    
    # Check Node.js
    print_step "Checking Node.js..."
    if command_exists node; then
        print_success "Node.js found: $(node --version)"
    else
        print_error "Node.js not found! Please install Node.js 18+"
        echo "  Download from: https://nodejs.org/"
        exit 1
    fi
    
    # Check npm
    if command_exists npm; then
        print_success "npm found: $(npm --version)"
    else
        print_error "npm not found!"
        exit 1
    fi
    
    # Check Git
    print_step "Checking Git..."
    if command_exists git; then
        print_success "Git found: $(git --version)"
    else
        print_warning "Git not found. Will download signature server using HTTP fallback"
    fi
    
    # Install Python dependencies
    print_step "Installing Python dependencies..."
    $PIP_CMD install -r requirements.txt
    print_success "Python dependencies installed"
    
    # Setup tiktok-signature
    print_step "Setting up tiktok-signature server..."
    
    if [ -d "tiktok-signature" ]; then
        print_info "tiktok-signature already exists"
        cd tiktok-signature
        
        # Update if git repo
        if [ -d ".git" ]; then
            print_info "Updating to latest version..."
            git pull origin main 2>/dev/null || true
        fi
    else
        print_info "Downloading tiktok-signature..."
        
        if command_exists git; then
            git clone https://github.com/carcabot/tiktok-signature.git
            cd tiktok-signature
        else
            # Fallback to wget/curl
            if command_exists wget; then
                wget https://github.com/carcabot/tiktok-signature/archive/refs/heads/main.zip -O tiktok-signature.zip
            elif command_exists curl; then
                curl -L https://github.com/carcabot/tiktok-signature/archive/refs/heads/main.zip -o tiktok-signature.zip
            else
                print_error "Neither git, wget, nor curl found!"
                exit 1
            fi
            
            unzip -q tiktok-signature.zip
            mv tiktok-signature-main tiktok-signature
            rm tiktok-signature.zip
            cd tiktok-signature
        fi
    fi
    
    print_info "Installing Node.js dependencies..."
    npm install
    
    print_info "Installing Chromium for Puppeteer..."
    npx puppeteer browsers install chromium
    
    cd ..
    
    print_success "tiktok-signature setup complete!"
    
    # Make scripts executable
    chmod +x start.sh 2>/dev/null || true
    chmod +x setup.sh 2>/dev/null || true
    
    # Done
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                     SETUP COMPLETE!                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}To start scraping:${NC}"
    echo -e "  ${YELLOW}./start.sh${NC}"
    echo ""
    echo -e "${CYAN}Or manually:${NC}"
    echo -e "  Terminal 1: ${YELLOW}cd tiktok-signature && npm start${NC}"
    echo -e "  Terminal 2: ${YELLOW}python tiktok_cli.py${NC}"
    echo ""
}

# Run main
main