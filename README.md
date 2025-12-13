# PowerShell Project Templates

## Overview

This repository provides a structured collection of **PowerShell scripts for generating standardized project templates**.

Each script automates the creation of a complete project scaffold, including directory layout, configuration files, development tooling, and quality controls. The goal is to eliminate repetitive setup work while enforcing consistent, professional standards across projects.

The repository is designed for engineers, developers, and technical teams who want reproducible, maintainable project foundations with minimal manual effort.

---

## Template Tiers

Project templates are organized by **tier**, where each tier represents an increasing level of tooling and rigor.

### Tier Concept

* **Tier 1** – Minimal project structure and core files
* **Tier 2** – Development tooling and basic automation
* **Tier 3** – Full professional setup with CI, linting, formatting, and testing

Each tier is implemented as a standalone PowerShell script:

* `setup_project_tier1.ps1`
* `setup_project_tier2.ps1`
* `setup_project_tier3.ps1`

Scripts are **idempotent**: existing files are not overwritten unless explicitly designed to be.

---

## What the Scripts Generate

Depending on the tier, the scripts may generate:

* Standardized directory structure (`src/`, `tests/`, `scripts/`, etc.)
* Configuration files (`pyproject.toml`, `.gitignore`, `.env.example`)
* Editor configuration (`.vscode/`)
* Pre-commit hooks and quality checks
* GitHub Actions CI workflows
* README and LICENSE boilerplate
* Logging, data, and reporting directories

All generated files follow best-practice defaults and are intended to be reviewed and customized as needed.

---

## Usage

### Prerequisites

* Windows PowerShell 7+ (recommended)
* Git
* Execution policy allowing local scripts
  (e.g. `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`)

---

### Basic Usage

Run the desired setup script from the repository root.

#### Example: Tier 3 Project Setup

```powershell
.\setup_project_tier3.ps1 -ProjectName enterprise_analysis
```

This will:

* Create a fully structured project directory
* Generate configuration and tooling files
* Set up linting, formatting, typing, and CI defaults
* Prepare the repository for immediate development

---

### Parameters

Common parameters across tier scripts:

* `-ProjectName`
  Name of the project to be created or initialized

Additional parameters may be introduced per tier as the templates evolve.

---

## Recommended Workflow

1. Clone this repository
2. Choose the appropriate tier
3. Run the corresponding `setup_project_tierX.ps1` script
4. Review generated files
5. Initialize Git and commit the baseline
6. Start development

---

## Design Principles

* Explicit over implicit
* Reproducible setups
* Minimal magic
* Safe defaults
* Professional tooling alignment

The scripts prioritize clarity and maintainability over convenience shortcuts.

---

## License

This repository is licensed under the **MIT License**, allowing unrestricted reuse, modification, and redistribution of the scripts and generated templates.

See the `LICENSE` file for full details.

---

## Disclaimer

The generated templates and configuration files are provided as a starting point. Users are responsible for reviewing and adapting them to their specific technical, organizational, and legal requirements.

---

