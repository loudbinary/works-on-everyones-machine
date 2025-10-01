# Architecture & Design

This document explains the architecture and design decisions behind the workstation setup and compliance automation system.

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Works on Everyone's Machines                  │
│                  Workstation Compliance System                   │
└─────────────────────────────────────────────────────────────────┘
                               │
                ┌──────────────┼──────────────┐
                │              │              │
                ▼              ▼              ▼
        ┌───────────┐  ┌──────────────┐  ┌──────────┐
        │ config.yml│  │  setup.sh    │  │  check-  │
        │           │  │              │  │compliance│
        └───────────┘  └──────────────┘  └──────────┘
                │              │              │
                └──────────────┼──────────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                    ▼                     ▼
            ┌──────────────┐      ┌──────────────┐
            │   Local Dev  │      │    CI/CD     │
            │  Environment │      │   Pipeline   │
            └──────────────┘      └──────────────┘
```

## Components

### 1. Configuration (`config.yml`)

**Purpose**: Defines all requirements and compliance rules in a declarative format.

**Structure**:
```yaml
version: "1.0"
required_tools: {}      # Tool version requirements
system_requirements: {} # System resource requirements
git_config: []         # Git configuration settings
compliance_checks: []  # Custom compliance rules
```

**Design Decisions**:
- YAML format for human readability
- Extensible structure for future requirements
- Separate optional vs required tools
- Custom check commands for flexibility

### 2. Setup Script (`setup.sh`)

**Purpose**: Automates workstation configuration to meet defined requirements.

**Key Features**:
- Interactive and non-interactive modes
- Colored output for clarity
- Idempotent (safe to run multiple times)
- Graceful handling of missing tools

**Flow**:
```
Start
  │
  ├─→ Parse arguments (--non-interactive, --help)
  │
  ├─→ Check required tools
  │   ├─→ Git (required)
  │   ├─→ Docker (optional)
  │   ├─→ Node.js (optional)
  │   └─→ Python (optional)
  │
  ├─→ Configure Git settings
  │   ├─→ user.name
  │   ├─→ user.email
  │   ├─→ core.autocrlf
  │   └─→ pull.rebase
  │
  ├─→ Check/Generate SSH key
  │
  ├─→ Verify system resources
  │   ├─→ Disk space
  │   └─→ RAM (future)
  │
  └─→ Summary and next steps
```

### 3. Compliance Checker (`check-compliance.sh`)

**Purpose**: Validates that the workstation meets all defined requirements.

**Key Features**:
- Non-destructive (read-only)
- Exit codes for CI/CD integration
- Categorized results (Pass/Fail/Warning)
- Detailed reporting

**Flow**:
```
Start
  │
  ├─→ Check each required tool
  │   ├─→ Version comparison
  │   └─→ Configuration validation
  │
  ├─→ Run custom compliance checks
  │
  ├─→ Generate summary
  │   ├─→ Count: Passed
  │   ├─→ Count: Failed
  │   └─→ Count: Warnings
  │
  └─→ Exit with appropriate code
      ├─→ 0: All checks passed
      └─→ 1: Some checks failed
```

### 4. Examples Directory

**Purpose**: Provides ready-to-use configurations for common project types.

**Available Examples**:
- `nodejs-project.yml`: JavaScript/TypeScript projects
- `python-project.yml`: Python applications
- `docker-project.yml`: Containerized projects

## Design Principles

### 1. Minimal Dependencies
- Only requires Bash and basic Unix tools
- No external package installations needed
- Works on Linux, macOS, WSL, Git Bash

### 2. Fail-Safe Operation
- Never destructive
- Prompts before making changes (interactive mode)
- Safe to run multiple times
- Clear error messages

### 3. Flexibility
- YAML configuration for easy customization
- Support for optional tools
- Custom compliance checks
- Extensible architecture

### 4. Developer Experience
- Colored output for readability
- Clear progress indicators
- Helpful error messages
- Comprehensive documentation

### 5. CI/CD Friendly
- Non-interactive mode
- Exit codes for pipeline integration
- Fast execution
- Idempotent operations

## Usage Patterns

### Pattern 1: New Contributor Onboarding
```bash
# Day 1 for new contributor
git clone <repository>
cd <repository>
./setup.sh              # Interactive setup
./check-compliance.sh   # Verify configuration
```

### Pattern 2: CI/CD Pipeline
```yaml
# GitHub Actions example
- name: Setup
  run: ./setup.sh --non-interactive
- name: Verify
  run: ./check-compliance.sh
```

### Pattern 3: Periodic Compliance Audits
```bash
# Run weekly or before major releases
./check-compliance.sh
# Address any warnings or failures
./setup.sh
```

### Pattern 4: Custom Project Setup
```bash
# Copy example configuration
cp examples/nodejs-project.yml config.yml
# Customize for your needs
vim config.yml
# Test
./check-compliance.sh
```

## Extension Points

### Adding New Tools

**Step 1**: Update `config.yml`:
```yaml
required_tools:
  your_tool:
    min_version: "1.0.0"
    check_command: "your_tool --version"
    optional: false
```

**Step 2**: (Optional) Add checks in `setup.sh`:
```bash
print_info "Checking YourTool installation..."
if command_exists your_tool; then
    TOOL_VERSION=$(your_tool --version | grep -oP '\d+\.\d+(\.\d+)?')
    print_success "YourTool $TOOL_VERSION is installed"
else
    print_warning "YourTool is not installed"
fi
```

**Step 3**: (Optional) Add validation in `check-compliance.sh`:
```bash
print_check "YourTool installation"
if command_exists your_tool; then
    TOOL_VERSION=$(your_tool --version | grep -oP '\d+\.\d+(\.\d+)?')
    if version_ge "$TOOL_VERSION" "1.0.0"; then
        print_pass "YourTool $TOOL_VERSION (>= 1.0.0)"
    else
        print_fail "YourTool $TOOL_VERSION (< 1.0.0 required)"
    fi
else
    print_fail "YourTool is not installed"
fi
```

### Adding Custom Checks

Add to `compliance_checks` in `config.yml`:
```yaml
compliance_checks:
  - name: "Environment Variable Set"
    check_command: "test -n \"$MY_VAR\""
    description: "MY_VAR should be set"
    severity: "warning"
```

## Security Considerations

### Input Validation
- All user input is validated
- No `eval` or dynamic code execution
- Safe handling of file paths

### Credentials
- No credentials stored in configuration
- SSH key generation uses secure defaults
- Git credentials handled by Git itself

### Permissions
- Scripts run with user permissions
- No `sudo` required
- No system-wide changes

## Performance

### Execution Time
- Setup: ~5-10 seconds (interactive)
- Setup: ~2-3 seconds (non-interactive)
- Compliance check: ~1-2 seconds

### Resource Usage
- Minimal CPU usage
- No network calls (unless tools make them)
- < 1MB disk space for all scripts

## Future Enhancements

### Planned Features
- [ ] JSON output format for programmatic parsing
- [ ] Web dashboard for compliance reporting
- [ ] Auto-update mechanism
- [ ] Plugin system for custom checks
- [ ] Multi-platform support (Windows native)
- [ ] Team compliance reporting
- [ ] Integration with popular IDEs

### Community Contributions
See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute new features or improvements.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
