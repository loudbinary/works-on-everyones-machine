---
name: works-on-everyones-machine
description: Automated workstation setup and compliance automation system. (Updated)
version: 1.2.0 # Bumped version to reflect major feature additions
author: Loudbinary / Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [GitHub, Authentication, Git, gh-cli, SSH, Setup, DevOps, Automation]
    related_skills: [github-pr-workflow, github-code-review, knowledgebase-monitor-daemon]
---

# 🚀 Works on Everyone's Machines (WOEM) v1.2.0

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/loudbinary/works-on-everyones-machines/graphs/commit-activity)

> "Works on my machine..." is a problem that no amount of local setup can truly solve. This repository provides an automated, compliance-driven solution to standardize development environments and streamline the contributor onboarding process across heterogeneous systems (Windows, macOS, Linux).

## 🌟 Key Features & Enhancements
This version introduces advanced automation capabilities:

*   **Continuous Knowledge Ingestion:** Implements the `knowledgebase-monitor-daemon` job. The system now automatically monitors `loudbinary/knowledgebase/data/team_inbox`, quarantines new articles, simulates research, and drafts a pull request for manual review.
*   **Enhanced Compliance Checks:** Expanded configuration options (`config.yml`) to manage tooling dependencies, system resource requirements, and custom checks.
*   **Automation Workflow:** The entire setup is now orchestrated by the `scripts/run_setup.py` master script, making onboarding faster and more reliable.

## 🗺️ Quick Start Guide (Updated)
> **New here?** See [QUICKSTART.md](QUICKSTART.md) for a condensed guide!

### For Contributors (The Standard Workflow)
1.  **Clone & Setup:** Clone the repository and run `./setup.sh` to establish a compliant local environment.
2.  **Review:** Use `./check-compliance.sh` to verify your system against the defined standards in `config.yml`.
3.  **Contribute:** Submit new work (e.g., articles) *only* to the dedicated **[Knowledge Base Inbox]** folder: `data/team_inbox/`. Our automated cron job will handle the rest!

### For Project Maintainers (System Administration)
1.  **Update Playbook:** Update `config.yml` and associated scripts (`setup.sh`, etc.) to match new project requirements or tools.
2.  **Monitor:** Verify that the **Knowledge Base Monitor Daemon** job is active in your CI/CD pipeline, ensuring incoming work is handled automatically.

---

## ⚙️ Detailed Workflow Components

### 1. Cross-Platform Setup & Orchestration (`scripts/run_setup.py`)
This master script runs setup and compliance checks across different OSes (Windows/Linux/Mac) by abstracting platform differences. It manages tool installations, configures Git credentials, and verifies system readiness against `config.yml`.

### 2. Compliance Checking (`check-compliance.sh`)
Validates the development environment by checking:
*   Tool versions (Python, Docker, Node).
*   Git/SSH configurations.
*   System resources (RAM, Disk Space).

### 3. Knowledge Base Monitor Daemon (KBMD)
This is our continuous integration point for new knowledge:
*   **Input:** New files dropped into `data/team_inbox/`.
*   **Process:** The background cron job automatically moves the file to `data/waiting-approval/`, performs simulated research, and generates a PR draft.
*   **Output:** A Draft Pull Request assigned to `loudbinary` in the knowledgebase repository, requiring manual review for merge.

---
**(Remaining sections like Configuration Options, Use Cases, etc., are preserved from the old documentation but should be reviewed against v1.2.0 features.)**