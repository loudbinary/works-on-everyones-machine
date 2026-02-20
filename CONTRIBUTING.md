# Contributing Guide

Welcome to the project! This guide will help you set up your development environment and ensure compliance with our standards.

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd works-on-everyones-machines
   ```

2. **Run the setup script**
   ```bash
   ./setup.sh
   ```
   This script will:
   - Check if required tools are installed
   - Configure Git settings
   - Set up SSH keys (optional, prompts for confirmation)
   - Apply recommended configurations
   
   For automated/CI environments, use non-interactive mode:
   ```bash
   ./setup.sh --non-interactive
   ```

3. **Verify compliance**
   ```bash
   ./check-compliance.sh
   ```
   This will verify that your workstation meets all requirements.

## Prerequisites

### Required Tools

- **Git** (>= 2.30.0): Version control system
  - Installation: https://git-scm.com/downloads

### Optional Tools

- **Docker** (>= 20.10.0): Container platform
  - Installation: https://docs.docker.com/get-docker/

- **Node.js** (>= 14.0.0): JavaScript runtime
  - Installation: https://nodejs.org/

- **Python** (>= 3.8.0): Programming language
  - Installation: https://www.python.org/downloads/

## Development Workflow

1. **Create a new branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write code following project conventions
   - Add tests for new features
   - Update documentation as needed

3. **Test your changes**
   ```bash
   ./check-compliance.sh
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Go to the repository on GitHub
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template

## Configuration

The `config.yml` file defines the workstation requirements and compliance checks. You can customize it for your project's specific needs.

### Sections

- **required_tools**: Tools that must be installed
- **system_requirements**: Minimum system specs
- **git_config**: Recommended Git settings
- **compliance_checks**: Automated checks to run

## Troubleshooting

### Common Issues

**Git not configured**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**SSH key not found**
```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
```

**Permission denied on scripts**
```bash
chmod +x setup.sh check-compliance.sh
```

## Getting Help

- Check existing [GitHub Issues](../../issues)
- Create a new issue with detailed information
- Reach out to maintainers

## Code of Conduct

Please be respectful and constructive in all interactions. We're all here to build something great together!
