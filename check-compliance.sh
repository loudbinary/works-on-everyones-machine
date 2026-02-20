#!/bin/bash

# Compliance Checker Script
# This script checks if the workstation meets all compliance requirements

# Note: We don't use 'set -e' because we want to continue checking even if some checks fail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${CONFIG_FILE:-$SCRIPT_DIR/config.yml}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Print functions
print_check() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED++))
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED++))
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNINGS++))
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

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

echo "=================================="
echo "  Compliance Checker"
echo "=================================="
echo ""

# Check Git
print_check "Git installation and configuration"
if command_exists git; then
    GIT_VERSION=$(git --version | grep -oP '\d+\.\d+(\.\d+)?')
    if version_ge "$GIT_VERSION" "2.30.0"; then
        print_pass "Git $GIT_VERSION (>= 2.30.0)"
    else
        print_fail "Git $GIT_VERSION (< 2.30.0 required)"
    fi
    
    # Check Git user config
    GIT_USER_NAME=$(git config --global user.name 2>/dev/null || echo "")
    GIT_USER_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
    if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then
        print_pass "Git user.name and user.email configured"
    else
        print_fail "Git user.name or user.email not configured"
    fi
else
    print_fail "Git is not installed"
fi

# Check Docker (optional)
print_check "Docker installation (optional)"
if command_exists docker; then
    DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+(\.\d+)?')
    print_pass "Docker $DOCKER_VERSION is installed"
else
    print_warn "Docker is not installed (optional)"
fi

# Check Node.js (optional)
print_check "Node.js installation (optional)"
if command_exists node; then
    NODE_VERSION=$(node --version | grep -oP '\d+\.\d+(\.\d+)?')
    if version_ge "$NODE_VERSION" "14.0.0"; then
        print_pass "Node.js $NODE_VERSION (>= 14.0.0)"
    else
        print_warn "Node.js $NODE_VERSION (< 14.0.0 recommended)"
    fi
else
    print_warn "Node.js is not installed (optional)"
fi

# Check Python (optional)
print_check "Python installation (optional)"
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version | grep -oP '\d+\.\d+(\.\d+)?')
    if version_ge "$PYTHON_VERSION" "3.8.0"; then
        print_pass "Python $PYTHON_VERSION (>= 3.8.0)"
    else
        print_warn "Python $PYTHON_VERSION (< 3.8.0 recommended)"
    fi
else
    print_warn "Python is not installed (optional)"
fi

# Check SSH key
print_check "SSH key configuration"
if [ -f ~/.ssh/id_rsa ] || [ -f ~/.ssh/id_ed25519 ]; then
    print_pass "SSH key exists"
else
    print_warn "No SSH key found"
fi

# Check disk space
print_check "Disk space requirements"
AVAILABLE_SPACE=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -ge 10 ]; then
    print_pass "Sufficient disk space (${AVAILABLE_SPACE}GB available)"
else
    print_warn "Low disk space (${AVAILABLE_SPACE}GB available, 10GB recommended)"
fi

# Check Git configurations
print_check "Git configuration settings"
AUTOCRLF=$(git config --global core.autocrlf 2>/dev/null || echo "not set")
PULL_REBASE=$(git config --global pull.rebase 2>/dev/null || echo "not set")

if [ "$AUTOCRLF" = "input" ]; then
    print_pass "core.autocrlf is set to 'input'"
else
    print_warn "core.autocrlf is '$AUTOCRLF' (recommended: 'input')"
fi

if [ "$PULL_REBASE" = "false" ]; then
    print_pass "pull.rebase is set to 'false'"
else
    print_warn "pull.rebase is '$PULL_REBASE' (recommended: 'false')"
fi

# Summary
echo ""
echo "=================================="
echo "  Summary"
echo "=================================="
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Failed:${NC} $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some critical checks failed. Please run './setup.sh' to fix issues.${NC}"
    exit 1
fi
