#!/bin/bash

# TikTok Scraper Start Script
# Usage: ./start.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# PID files
SIGNATURE_PID=""
SCRAPER_PID=""

# Cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}Shutting down...${NC}"
    
    if [ ! -z "$SIGNATURE_PID" ] && kill -0 "$SIGNATURE_PID" 2>/dev/null; then
        kill "$SIGNATURE_PID" 2>/dev/null
        echo -e "${GREEN}✅ Signature server stopped${NC}"
    fi
    
    if [ ! -z "$SCRAPER_PID" ] && kill -0 "$SCRAPER_PID" 2>/dev/null; then
        kill "$SCRAPER_PID" 2>/dev/null
        echo -e "${GREEN}✅ Scraper stopped${NC}"
    fi
    
    exit 0
}

trap cleanup SIGINT SIGTERM EXIT

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                                  ║"
    echo "║              ${MAGENTA}TikTok Scraper - Starting Up${CYAN}                         ║"
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

# Check if setup is complete
check_setup() {
    if [ ! -d "tiktok-signature" ]; then
        print_error "tiktok-signature not found!"
        print_info "Please run setup first: ${YELLOW}./setup.sh${NC}"
        exit 1
    fi
    
    if [ ! -d "tiktok-signature/node_modules" ]; then
        print_error "tiktok-signature dependencies not installed!"
        print_info "Please run setup first: ${YELLOW}./setup.sh${NC}"
        exit 1
    fi
}

# Wait for signature server to be ready
wait_for_server() {
    local max_attempts=30
    local attempt=0
    
    print_info "Waiting for signature server to be ready..."
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s http://localhost:8080/health > /dev/null 2>&1; then
            print_success "Signature server is ready!"
            return 0
        fi
        
        sleep 1
        attempt=$((attempt + 1))
        echo -n "."
    done
    
    echo ""
    print_error "Signature server failed to start within ${max_attempts} seconds"
    return 1
}

# Main
main() {
    print_banner
    check_setup
    
    # Check if port 8080 is already in use
    if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 8080 is already in use!"
        print_info "Signature server may already be running"
    else
        # Start signature server
        echo -e "\n${CYAN}🚀 Starting signature server...${NC}"
        cd tiktok-signature
        npm start > ../signature.log 2>&1 &
        SIGNATURE_PID=$!
        cd ..
        
        echo -e "${GRAY}   PID: $SIGNATURE_PID${NC}"
        echo -e "${GRAY}   Log: signature.log${NC}"
    fi
    
    # Wait for server
    if ! wait_for_server; then
        print_error "Cannot connect to signature server"
        echo -e "${GRAY}Check signature.log for errors${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                   STARTING SCRAPER CLI                        ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Start Python scraper
    if command_exists python3; then
        PYTHON_CMD="python3"
    else
        PYTHON_CMD="python"
    fi
    
    $PYTHON_CMD tiktok_cli.py
    
    # Scraper finished
    echo ""
    print_success "Scraping session completed!"
}

# Run main
main