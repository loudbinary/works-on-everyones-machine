# Works on Everyone's Machines

> "Works on my machine..." becomes a thing of the past.

A workstation setup and compliance automation system designed to standardize development environments and streamline the contributor onboarding process.

## Overview

This project provides automated tools to:
- 🚀 **Set up development environments** consistently across all machines
- ✅ **Check compliance** with team standards and requirements
- 📋 **Define requirements** through simple YAML configuration
- 🔄 **Automate onboarding** for new contributors
- 🛡️ **Enforce standards** via CI/CD integration

## Quick Start

> 📖 **New here?** See [QUICKSTART.md](QUICKSTART.md) for a condensed guide!

### For Contributors

1. **Clone the repository**
   ```bash
   git clone https://github.com/loudbinary/works-on-everyones-machines.git
   cd works-on-everyones-machines
   ```

2. **Run the setup script**
   ```bash
   ./setup.sh
   ```
   
   Or in non-interactive mode (for CI/CD):
   ```bash
   ./setup.sh --non-interactive
   ```

3. **Verify your environment**
   ```bash
   ./check-compliance.sh
   ```

### For Project Maintainers

1. **Copy this repository structure** to your project
2. **Customize `config.yml`** with your project's requirements
3. **Add the GitHub workflow** to enable CI/CD compliance checks
4. **Update documentation** to reflect your specific tools and versions

## Features

### 🔧 Automated Setup (`setup.sh`)

The setup script handles:
- Checking for required tools (Git, Docker, Node.js, Python, etc.)
- Configuring Git user information
- Generating SSH keys
- Setting recommended Git configurations
- Verifying system requirements

**Usage:**
```bash
# Interactive mode (prompts for user input)
./setup.sh

# Non-interactive mode (skips prompts, useful for CI/CD)
./setup.sh --non-interactive

# Show help
./setup.sh --help
```

### ✅ Compliance Checking (`check-compliance.sh`)

The compliance checker validates:
- Tool versions meet minimum requirements
- Git configuration is properly set
- SSH keys are configured
- System resources meet requirements
- Project-specific compliance rules

**Usage:**
```bash
./check-compliance.sh
```

**Exit codes:**
- `0`: All checks passed
- `1`: Critical checks failed

### ⚙️ Configuration (`config.yml`)

Define your project's requirements in a simple YAML file:

```yaml
required_tools:
  git:
    min_version: "2.30.0"
    check_command: "git --version"
  
  docker:
    min_version: "20.10.0"
    check_command: "docker --version"
    optional: true

system_requirements:
  disk_space_gb: 10
  ram_gb: 4

compliance_checks:
  - name: "Git User Config"
    check_command: "git config --global user.name && git config --global user.email"
    description: "Git user name and email should be configured"
    severity: "error"
```

### 🔄 CI/CD Integration

Include the provided GitHub Actions workflow to automatically check compliance on every PR:

```yaml
# .github/workflows/compliance-check.yml
name: Compliance Check
on: [push, pull_request]
jobs:
  compliance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: ./check-compliance.sh
```

## Configuration Options

### Required Tools

Define tools that must be installed with minimum version requirements:

```yaml
required_tools:
  tool_name:
    min_version: "X.Y.Z"
    check_command: "command --version"
    optional: true/false
```

### System Requirements

Specify minimum system resources:

```yaml
system_requirements:
  disk_space_gb: 10
  ram_gb: 4
```

### Git Configuration

Set recommended Git settings:

```yaml
git_config:
  - key: "core.autocrlf"
    value: "input"
  - key: "pull.rebase"
    value: "false"
```

### Compliance Checks

Add custom compliance checks:

```yaml
compliance_checks:
  - name: "Check Name"
    check_command: "command to run"
    description: "What this check validates"
    severity: "error|warning"
```

## Use Cases

### 1. Open Source Projects
Standardize contributor environments to reduce "works on my machine" issues.

### 2. Enterprise Teams
Enforce security and compliance requirements across all developer workstations.

### 3. Educational Settings
Quickly set up consistent environments for students and instructors.

### 4. CI/CD Pipelines
Validate build environments before running expensive CI jobs.

## Customization

### Adding New Tools

Edit `config.yml` to add new required tools:

```yaml
required_tools:
  your_tool:
    min_version: "1.0.0"
    check_command: "your_tool --version"
    optional: false
```

### Adding Custom Checks

Add custom compliance checks to `config.yml`:

```yaml
compliance_checks:
  - name: "Your Custom Check"
    check_command: "test -f ~/.your-config"
    description: "Verify your custom configuration"
    severity: "warning"
```

### Modifying Scripts

The scripts are designed to be easily customizable:
- **`setup.sh`**: Modify to add interactive setup steps
- **`check-compliance.sh`**: Add custom validation logic

## Examples

### Example 1: Node.js Project

```yaml
required_tools:
  git:
    min_version: "2.30.0"
  node:
    min_version: "18.0.0"
  npm:
    min_version: "8.0.0"
```

### Example 2: Python Project

```yaml
required_tools:
  git:
    min_version: "2.30.0"
  python:
    min_version: "3.10.0"
  pip:
    min_version: "22.0.0"
```

### Example 3: Docker-based Project

```yaml
required_tools:
  git:
    min_version: "2.30.0"
  docker:
    min_version: "20.10.0"
  docker-compose:
    min_version: "2.0.0"
```

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:
- Setting up your development environment
- Running compliance checks
- Submitting pull requests
- Code style guidelines

## Troubleshooting

### Common Issues

**Scripts not executable**
```bash
chmod +x setup.sh check-compliance.sh
```

**Git configuration missing**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**Version check fails**
- Ensure the tool is in your PATH
- Update to the minimum required version
- Check that the tool's version output format is standard

## Requirements

- Bash shell (Linux, macOS, WSL, Git Bash)
- Git 2.30.0 or higher

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Documentation

- 📖 [Quick Start Guide](QUICKSTART.md) - Fast setup reference
- 🏗️ [Architecture](ARCHITECTURE.md) - System design and extension guide
- 🤝 [Contributing](CONTRIBUTING.md) - How to contribute
- 📋 [Examples](examples/) - Ready-to-use configurations

## Support

- 🐛 [Issue Tracker](../../issues)
- 💬 [Discussions](../../discussions)

## Acknowledgments

Built to solve the eternal "works on my machine" problem and make onboarding a breeze for everyone.

---

**Made with ❤️ for developers everywhere**
