#!/bin/bash

# Workstation Setup Script
# This script sets up a standardized development environment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${CONFIG_FILE:-$SCRIPT_DIR/config.yml}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running with bash
if [ -z "$BASH_VERSION" ]; then
    print_error "This script requires bash"
    exit 1
fi

print_info "Starting workstation setup..."
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to parse version
parse_version() {
    echo "$@" | grep -oP '\d+\.\d+(\.\d+)?' | head -n1
}

# Function to compare versions
version_ge() {
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

# Check Git
print_info "Checking Git installation..."
if command_exists git; then
    GIT_VERSION=$(git --version | grep -oP '\d+\.\d+(\.\d+)?')
    print_success "Git $GIT_VERSION is installed"
    
    # Check Git configuration
    if ! git config --global user.name >/dev/null 2>&1; then
        print_warning "Git user.name is not configured"
        read -p "Enter your name for Git: " git_name
        git config --global user.name "$git_name"
        print_success "Git user.name configured"
    fi
    
    if ! git config --global user.email >/dev/null 2>&1; then
        print_warning "Git user.email is not configured"
        read -p "Enter your email for Git: " git_email
        git config --global user.email "$git_email"
        print_success "Git user.email configured"
    fi
else
    print_error "Git is not installed. Please install Git first."
    exit 1
fi

# Check Docker (optional)
print_info "Checking Docker installation..."
if command_exists docker; then
    DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+(\.\d+)?')
    print_success "Docker $DOCKER_VERSION is installed"
else
    print_warning "Docker is not installed (optional)"
fi

# Check Node.js (optional)
print_info "Checking Node.js installation..."
if command_exists node; then
    NODE_VERSION=$(node --version | grep -oP '\d+\.\d+(\.\d+)?')
    print_success "Node.js $NODE_VERSION is installed"
else
    print_warning "Node.js is not installed (optional)"
fi

# Check Python (optional)
print_info "Checking Python installation..."
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version | grep -oP '\d+\.\d+(\.\d+)?')
    print_success "Python $PYTHON_VERSION is installed"
else
    print_warning "Python is not installed (optional)"
fi

# Check SSH key
print_info "Checking SSH key..."
if [ -f ~/.ssh/id_rsa ] || [ -f ~/.ssh/id_ed25519 ]; then
    print_success "SSH key exists"
else
    print_warning "No SSH key found"
    read -p "Do you want to generate an SSH key? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your email for SSH key: " ssh_email
        ssh-keygen -t ed25519 -C "$ssh_email" -f ~/.ssh/id_ed25519 -N ""
        print_success "SSH key generated"
        print_info "Add this public key to your GitHub/GitLab account:"
        cat ~/.ssh/id_ed25519.pub
    fi
fi

# Check disk space
print_info "Checking disk space..."
AVAILABLE_SPACE=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -ge 10 ]; then
    print_success "Sufficient disk space available (${AVAILABLE_SPACE}GB)"
else
    print_warning "Low disk space (${AVAILABLE_SPACE}GB available, 10GB recommended)"
fi

# Set recommended Git configurations
print_info "Setting recommended Git configurations..."
git config --global core.autocrlf input
git config --global pull.rebase false
print_success "Git configurations applied"

echo ""
print_success "Workstation setup completed!"
print_info "Run './check-compliance.sh' to verify compliance with all requirements"
