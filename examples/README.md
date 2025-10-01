# Configuration Examples

This directory contains example configuration files for different types of projects. Copy the appropriate example to your project as `config.yml` and customize it for your needs.

## Available Examples

### Node.js Project (`nodejs-project.yml`)
Configuration for JavaScript/TypeScript projects using Node.js and npm.

**Requires:**
- Git >= 2.30.0
- Node.js >= 18.0.0
- npm >= 9.0.0

**Use for:**
- Express.js applications
- React/Vue/Angular projects
- Node.js microservices
- CLI tools built with Node.js

### Python Project (`python-project.yml`)
Configuration for Python applications.

**Requires:**
- Git >= 2.30.0
- Python >= 3.10.0
- pip >= 22.0.0

**Use for:**
- Django/Flask applications
- Data science projects
- Python CLI tools
- Machine learning projects

### Docker Project (`docker-project.yml`)
Configuration for containerized applications.

**Requires:**
- Git >= 2.30.0
- Docker >= 20.10.0
- Docker Compose >= 2.0.0 (optional)

**Use for:**
- Microservices architectures
- Multi-container applications
- Projects with complex dependencies
- Cross-platform development

## Using an Example

1. **Copy the example to your project**
   ```bash
   cp examples/nodejs-project.yml config.yml
   ```

2. **Customize for your project**
   Edit `config.yml` to match your specific requirements:
   - Adjust minimum versions
   - Add or remove tools
   - Modify compliance checks
   - Set environment variables

3. **Test the configuration**
   ```bash
   ./check-compliance.sh
   ```

## Creating Custom Configurations

You can mix and match requirements from different examples or create entirely custom configurations. See the main [README.md](../README.md) for full configuration options.

### Common Customizations

**Adding a new tool:**
```yaml
required_tools:
  your_tool:
    min_version: "1.0.0"
    check_command: "your_tool --version"
    optional: false
```

**Adding a custom check:**
```yaml
compliance_checks:
  - name: "Custom Check"
    check_command: "test -f .env"
    description: "Environment file should exist"
    severity: "warning"
```

**Increasing resource requirements:**
```yaml
system_requirements:
  disk_space_gb: 50
  ram_gb: 16
```
