# Quick Start Guide

This is a quick reference for getting started with the workstation setup and compliance automation system.

## Installation

### Step 1: Clone Repository
```bash
git clone https://github.com/loudbinary/works-on-everyones-machines.git
cd works-on-everyones-machines
```

### Step 2: Run Setup
```bash
./setup.sh
```

### Step 3: Verify Compliance
```bash
./check-compliance.sh
```

## Common Commands

### Check Compliance
```bash
./check-compliance.sh
```
Exit codes:
- `0`: All checks passed ✓
- `1`: Some checks failed ✗

### Interactive Setup
```bash
./setup.sh
```
Prompts for user input when configuration is needed.

### Non-Interactive Setup
```bash
./setup.sh --non-interactive
```
Skips prompts, useful for CI/CD pipelines.

### Get Help
```bash
./setup.sh --help
```

## Prerequisites

### Required
- **Git** >= 2.30.0
- **Bash** shell

### Optional (project-dependent)
- **Docker** >= 20.10.0
- **Node.js** >= 14.0.0
- **Python** >= 3.8.0

## Configuration

Edit `config.yml` to customize requirements for your project:

```yaml
required_tools:
  git:
    min_version: "2.30.0"
    check_command: "git --version"
```

## Using in Your Project

### Option 1: Copy Files
1. Copy setup and compliance scripts to your repo
2. Customize `config.yml`
3. Update documentation

### Option 2: Submodule
```bash
git submodule add https://github.com/loudbinary/works-on-everyones-machines.git
```

### Option 3: Template
Use this repository as a GitHub template:
1. Click "Use this template" on GitHub
2. Customize for your needs

## Examples

### Node.js Project
```bash
cp examples/nodejs-project.yml config.yml
```

### Python Project
```bash
cp examples/python-project.yml config.yml
```

### Docker Project
```bash
cp examples/docker-project.yml config.yml
```

## Troubleshooting

### Scripts Not Executable
```bash
chmod +x setup.sh check-compliance.sh
```

### Git Not Configured
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Tool Not Found
Ensure the tool is:
1. Installed
2. In your PATH
3. Meeting minimum version requirements

## CI/CD Integration

### GitHub Actions
```yaml
- name: Setup environment
  run: ./setup.sh --non-interactive
  
- name: Check compliance
  run: ./check-compliance.sh
```

### GitLab CI
```yaml
before_script:
  - ./setup.sh --non-interactive
  - ./check-compliance.sh
```

## Next Steps

- Read full [README.md](README.md)
- Review [CONTRIBUTING.md](CONTRIBUTING.md)
- Customize [config.yml](config.yml)
- Check [examples/](examples/)

## Support

- [Issues](https://github.com/loudbinary/works-on-everyones-machines/issues)
- [Discussions](https://github.com/loudbinary/works-on-everyones-machines/discussions)
