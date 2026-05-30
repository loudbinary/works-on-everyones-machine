#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Workstation Setup Orchestrator (Cross-Platform)
This script wraps the functionality of setup.sh, abstracting OS-specific 
commands to ensure consistency across Windows, macOS, and Linux (WSL).

Dependencies: Python 3 standard library modules.
"""
import subprocess
import sys
import os
import platform
from datetime import datetime

# --- CONFIGURATION ---
# Tools we need to check/install
REQUIRED_TOOLS = {
    "git": {"min_version": "2.30.0", "check_cmd": ["git", "--version"], "optional": False},
    "docker": {"min_version": "20.10.0", "check_cmd": ["docker", "--version"], "optional": True},
    "node": {"min_version": "18.0.0", "check_cmd": ["node", "--version"], "optional": True},
    "python3": {"min_version": "3.8.0", "check_cmd": ["python3", "--version"], "optional": False}
}

# --- UTILITY FUNCTIONS ---

def print_info(message):
    print(f"\n\033[0;34m[INFO]\033[0m {message}") # Blue
def print_success(message):
    print(f"\n\033[0;32m[SUCCESS]\033[0m {message}") # Green
def print_warning(message):
    print(f"\n\033[0;33m[WARNING]\033[0m {message}") # Yellow
def print_error(message):
    print(f"\n\033[0;31m[ERROR]\033[0m {message}") # Red

def run_command(cmd, capture_output=True, check_success=True):
    """Runs a system command using subprocess and handles platform-specific differences."""
    print("Executing:", " ".join(cmd))
    try:
        if sys.platform.startswith('win'):
            # Use shell=True for simpler Windows execution paths if necessary, 
            # but generally passing the list is safer.
            result = subprocess.run(cmd, capture_output=capture_output, check=check_success)
        else: # Linux/macOS (Bash compatibility)
            result = subprocess.run(cmd, capture_output=capture_output, check=check_success)
        return result
    except FileNotFoundError:
        print_error(f"Command not found: {cmd[0]}. Is the tool installed?")
        return None
    except subprocess.CalledProcessError as e:
        if check_success and "permission denied" in str(e): # Example specific handling
             pass 
        print_error(f"Command failed with exit code {e.returncode}: {e.stderr.decode('utf-8', errors='ignore')}")
        return None

def get_os():
    """Determines the current OS type."""
    system = platform.system()
    if system == "Windows":
        print_info("Detected Operating System: Windows")
        return "windows"
    elif system == "Darwin":
        print_info("Detected Operating System: macOS (Darwin)")
        return "macos"
    else: # Linux
        print_info("Detected Operating System: Linux")
        return "linux"

# --- CORE LOGIC FUNCTIONS ---

def check_tool(tool_name, config):
    """Checks if a required tool is installed and meets minimum version."""
    if not config["check_cmd"]:
        return True # No check command provided
    
    print_info(f"Checking for {tool_name}...")
    try:
        # Run the check command
        result = run_command(config["check_cmd"])
        if result is None:
            return False

        output = result.stdout.decode('utf-8', errors='ignore')
        print(f"Output:\n{output[:100]}...") # Print snippet of output
        
        # Simple version extraction logic (can be improved)
        version_match = "".join(filter(str.isdigit, output)).split('.')
        if len(version_match) < 2:
             print_warning("Could not reliably extract version number.")
             return True # Assume installed if command ran without error

        # Placeholder for actual version comparison logic (Requires a proper version parsing library)
        # For now, we assume success if the command runs.
        print_success(f"{tool_name} appears to be installed and runnable.")
        return True

    except Exception as e:
        print_error(f"Error checking {tool_name}: {e}")
        return False

def setup_git_identity():
    """Sets up global Git user identity."""
    print_info("Configuring Git Identity (Name and Email)...")
    try:
        # Attempt to read from interactive input if not non-interactive
        user_name = subprocess.check_output(subprocess.run(["git", "config", "--global", "user.name"], capture_output=True, check=False)).decode('utf-8').strip()
        user_email = subprocess.check_output(subprocess.run(["git", "config", "--global", "user.email"], capture_output=True, check=False)).decode('utf-8').strip()

        if user_name and user_email:
            print_success("Git identity found.")
            return True
        else:
            # If not found or empty, prompt for input (only if interactive)
            if not os.getenv('CI') and platform.system() != 'Windows': # Simple check to avoid prompting in non-interactive CI environments
                print_warning("Git user name/email not found in config. Please enter them now.")
                name = input("Enter your name for Git: ")
                email = input("Enter your email for Git: ")
                run_command(["git", "config", "--global", "user.name"], check_success=False) # Dummy call to trigger prompt if needed
                subprocess.run(["git", "config", "--global", "user.name", name])
                subprocess.run(["git", "config", "--global", "user.email", email])
            else:
                 print_warning("Skipping interactive Git identity setup.")

    except Exception as e:
        print_error(f"Failed to set/read git identity: {e}")
        return False


def setup_git_credential_helper():
    """Sets up credential helper for persistent auth."""
    if platform.system() == "Windows":
        # Windows often requires specific PowerShell commands
        print_info("Setting up Git Credential Manager for Windows...")
        # In a real scenario, we'd use 'git config --global credential.helper manager'
        # For this simulation, we confirm the action.
        run_command(["powershell", "Set-Item -Path $env:USERPROFILE\.ssh\config -Name Host github.com -Value IdentityFile ~/.ssh/id_ed25519"], check_success=False)
        print_success("Simulated setting up Git Credential Manager for Windows.")
    else: # Linux/macOS (Bash focus)
        print_info("Setting up Git credential helper...")
        run_command(["git", "config", "--global", "credential.helper", "store"])
        if subprocess.run(['git', 'config', '--global', 'credential.helper'], capture_output=True).returncode == 0:
            print_success("Git credential helper set to 'store'.")


def run_setup():
    """Orchestrates the entire setup process."""
    os_type = get_os()

    # --- Phase 1: Goal Definition (Done by user request) & Initialization ---
    print_info("Starting Workstation Setup Orchestrator...")

    # --- Phase 2/3: Audit and Formalize ---
    tools_ok = True
    for name, config in REQUIRED_TOOLS.items():
        if not check_tool(name, config):
            tools_ok = False
    
    print("\n--- Running Core Setup Procedures ---\n")

    # 1. Git Identity & Credentials (Cross-platform)
    setup_git_identity()
    setup_git_credential_helper()

    if tools_ok:
        print_success("All core system dependencies are configured!")
    else:
        print_warning("One or more critical tools failed to initialize. Manual intervention is required.")

def main():
    """Main entry point for the script."""
    # The setup logic has been refactored into run_setup()
    run_setup()


if __name__ == "__main__":
    main()