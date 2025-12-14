<#
.SYNOPSIS
    Tier 2: Core Development Setup
.DESCRIPTION
    Creates a solid data analysis project with essential features
    - Core folder structure
    - Python environment with key packages
    - Basic testing setup
    - Simple VSCode configuration
    - Git initialization
    - Basic documentation
.PARAMETER ProjectName
    Name of the project
.PARAMETER PythonVersion
    Python version (default: 3.12)
.EXAMPLE
    .\setup_project_tier2.ps1 -ProjectName "data_analysis"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [string]$PythonVersion = "3.12"
)

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "TIER 2: CORE DEVELOPMENT SETUP" -ForegroundColor Green
Write-Host "Project: $ProjectName" -ForegroundColor Green
Write-Host "Python Version: $PythonVersion" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

# ============================================
# Create Project Directory and Initialize Git
# ============================================
Write-Host "`nCreating project directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $ProjectName -Force | Out-Null
Set-Location $ProjectName

Write-Host "Initializing Git repository..." -ForegroundColor Yellow
git init
git branch -M main

# ============================================
# Create Core Folder Structure
# ============================================
Write-Host "Creating folder structure..." -ForegroundColor Yellow

$folders = @(
    "data\raw",
    "data\processed",
    "notebooks",
    "src\database",
    "src\utils",
    "tests",
    "scripts",
    "reports",
    "config"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

# Create .gitkeep files
$gitkeepDirs = @("data\raw", "data\processed", "reports")
foreach ($dir in $gitkeepDirs) {
    New-Item -ItemType File -Path "$dir\.gitkeep" -Force | Out-Null
}

# ============================================
# Create __init__.py Files
# ============================================
$initDirs = @("src", "src\database", "src\utils", "tests")
foreach ($dir in $initDirs) {
    @"
"""$dir package."""
__version__ = "0.1.0"
"@ | Out-File -FilePath "$dir\__init__.py" -Encoding UTF8
}

# ============================================
# Create .gitignore
# ============================================
Write-Host "Creating .gitignore..." -ForegroundColor Yellow

@'
# Python
__pycache__/
*.py[cod]
*.so
.Python
*.egg-info/
dist/
build/

# Virtual environments
.env
.venv
venv/
ENV/

# Jupyter
.ipynb_checkpoints

# Testing
.pytest_cache/
.coverage
htmlcov/

# IDEs
.vscode/
.idea/

# Data files
data/raw/*
!data/raw/.gitkeep
data/processed/*
!data/processed/.gitkeep

# Reports
reports/*
!reports/.gitkeep

# Database
*.db
*.sqlite

# Environment
.env

# OS
.DS_Store
Thumbs.db

# Temporary
*.tmp
*.log
'@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# ============================================
# Create .env.example
# ============================================
Write-Host "Creating environment template..." -ForegroundColor Yellow

@'
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_database
DB_USER=your_username
DB_PASSWORD=your_password
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Application Settings
DEBUG=True
LOG_LEVEL=INFO

# Paths
DATA_DIR=./data
OUTPUT_DIR=./reports
'@ | Out-File -FilePath ".env.example" -Encoding UTF8

# ============================================
# Create environment.yml
# ============================================
Write-Host "Creating environment.yml..." -ForegroundColor Yellow

@"
name: $ProjectName
channels:
  - conda-forge
  - defaults

dependencies:
  - python=$PythonVersion
  - pip

  # Data processing
  - pandas>=2.1
  - numpy>=1.26
  - openpyxl

  # Database
  - sqlalchemy>=2.0
  - psycopg2>=2.9

  # Visualization
  - matplotlib>=3.8
  - seaborn>=0.13

  # Jupyter
  - jupyter
  - ipykernel

  # Development
  - pytest
  - black
  - flake8

  # Utilities
  - python-dotenv
  - pyyaml

  - pip:
    - types-PyYAML
"@ | Out-File -FilePath "environment.yml" -Encoding UTF8

# ============================================
# Create pyproject.toml
# ============================================
Write-Host "Creating pyproject.toml..." -ForegroundColor Yellow

@"
[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.build_meta"

[project]
name = "$ProjectName"
version = "0.1.0"
description = "Data analysis project"
requires-python = ">=$PythonVersion"
dependencies = [
    "pandas>=2.1.0",
    "numpy>=1.26.0",
    "sqlalchemy>=2.0.0",
    "python-dotenv>=1.0.0"
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "black>=23.12.0",
    "flake8>=6.1.0"
]

[tool.black]
line-length = 88
target-version = ["py312"]

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = ["--verbose"]
"@ | Out-File -FilePath "pyproject.toml" -Encoding utf8NoBOM

# ============================================
# Create Basic VSCode Settings
# ============================================
Write-Host "Creating VSCode configuration..." -ForegroundColor Yellow

New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null

@'
{
    "python.defaultInterpreterPath": "${workspaceFolder}/.venv/Scripts/python.exe",
    "python.testing.pytestEnabled": true,
    "python.formatting.provider": "black",
    "editor.formatOnSave": true,
    "[python]": {
        "editor.rulers": [88],
        "editor.tabSize": 4
    }
}
'@ | Out-File -FilePath ".vscode\settings.json" -Encoding UTF8

# ============================================
# Create Source Code Files
# ============================================
Write-Host "Creating source code templates..." -ForegroundColor Yellow

# src/database/connection.py
@'
"""Database connection utilities."""

import os
from contextlib import contextmanager
from typing import Generator

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

if DATABASE_URL:
    engine = create_engine(DATABASE_URL, echo=False)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
else:
    engine = None
    SessionLocal = None


@contextmanager
def get_db() -> Generator[Session, None, None]:
    """Get database session."""
    if not SessionLocal:
        raise ValueError("DATABASE_URL not configured")
    
    db = SessionLocal()
    try:
        yield db
        db.commit()
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()
'@ | Out-File -FilePath "src\database\connection.py" -Encoding UTF8

# src/utils/helpers.py
@'
"""Utility functions."""

import logging
from pathlib import Path
from typing import Dict, Any

import yaml
from dotenv import load_dotenv

load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)


def load_config(config_path: str = "config/settings.yml") -> Dict[str, Any]:
    """Load YAML configuration."""
    config_file = Path(config_path)
    if not config_file.exists():
        return {}
    
    with open(config_file, "r") as f:
        return yaml.safe_load(f) or {}


def ensure_dir(directory: Path) -> None:
    """Ensure directory exists."""
    Path(directory).mkdir(parents=True, exist_ok=True)
'@ | Out-File -FilePath "src\utils\helpers.py" -Encoding UTF8

# ============================================
# Create Test Files
# ============================================
Write-Host "Creating test templates..." -ForegroundColor Yellow

# tests/test_utils.py
@'
"""Tests for utility functions."""

from src.utils.helpers import ensure_dir
from pathlib import Path


def test_ensure_dir(tmp_path):
    """Test directory creation."""
    test_dir = tmp_path / "test_folder"
    ensure_dir(test_dir)
    assert test_dir.exists()
'@ | Out-File -FilePath "tests\test_utils.py" -Encoding UTF8

# ============================================
# Create Example Script
# ============================================
@'
"""Example data processing script."""

import pandas as pd
from pathlib import Path
from src.utils.helpers import ensure_dir


def main():
    """Main processing function."""
    print("Starting data processing...")
    
    # Example: Load and process data
    # df = pd.read_csv("data/raw/input.csv")
    # processed = df.copy()  # Add processing here
    
    # Save results
    output_dir = Path("data/processed")
    ensure_dir(output_dir)
    # processed.to_csv(output_dir / "output.csv", index=False)
    
    print("Processing complete!")


if __name__ == "__main__":
    main()
'@ | Out-File -FilePath "scripts\process_data.py" -Encoding UTF8

# ============================================
# Create README
# ============================================
Write-Host "Creating README..." -ForegroundColor Yellow

@"
# $ProjectName

## Overview

Data analysis project with core Python stack.

## Setup

### Prerequisites
- Python $PythonVersion
- Miniconda/Anaconda
- Git

### Installation

1. **Create environment:**
\`\`\`bash
conda env create -f environment.yml
conda activate $ProjectName
\`\`\`

2. **Configure environment:**
\`\`\`bash
copy .env.example .env
# Edit .env with your settings
\`\`\`

## Project Structure
\`\`\`
├── data/          # Data files
├── notebooks/     # Jupyter notebooks
├── src/           # Source code
├── tests/         # Tests
├── scripts/       # Processing scripts
└── reports/       # Outputs
\`\`\`

## Usage

### Run Processing
\`\`\`bash
python scripts/process_data.py
\`\`\`

### Run Tests
\`\`\`bash
pytest
\`\`\`

### Format Code
\`\`\`bash
black src/ tests/ scripts/
\`\`\`

## Development

1. Create feature branch
2. Write code and tests
3. Run tests and formatting
4. Commit and push

## License

MIT License
"@ | Out-File -FilePath "README.md" -Encoding UTF8

# ============================================
# Create Conda Environment
# ============================================
Write-Host "`nCreating conda environment..." -ForegroundColor Yellow
conda env create -f environment.yml

# ============================================
# Initial Git Commit
# ============================================
Write-Host "`nCreating initial commit..." -ForegroundColor Yellow

git add .

$commitMessage = @"
Initial project structure - Tier 2 Core Setup

Core data science project structure with:
- Essential folder organization
- Python environment with key packages
- Database connectivity
- Basic testing infrastructure
- VSCode integration
- Example scripts

Project: $ProjectName
Python: $PythonVersion
Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Tier: 2 (Core Development)
"@

git commit -m $commitMessage
git tag -a "v0.1.0" -m "Initial setup"

# ============================================
# Success Message
# ============================================
Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "TIER 2 SETUP COMPLETE!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "`nCreated:" -ForegroundColor Cyan
Write-Host "  ✓ Core folder structure" -ForegroundColor White
Write-Host "  ✓ Python environment" -ForegroundColor White
Write-Host "  ✓ Database module" -ForegroundColor White
Write-Host "  ✓ Testing setup" -ForegroundColor White
Write-Host "  ✓ VSCode config" -ForegroundColor White
Write-Host "  ✓ Example scripts" -ForegroundColor White
Write-Host "  ✓ Documentation" -ForegroundColor White

Write-Host "`nNext Steps:" -ForegroundColor Cyan
Write-Host "  1. conda activate $ProjectName" -ForegroundColor White
Write-Host "  2. copy .env.example .env" -ForegroundColor White
Write-Host "  3. jupyter notebook" -ForegroundColor White

Write-Host "`n"
