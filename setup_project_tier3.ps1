<#
.SYNOPSIS
    Tier 3: Full Enterprise Setup with Git Clone Support
.DESCRIPTION
    Creates complete enterprise-grade data analysis project
    - Git clone support or new repository initialization
    - All Tier 2 features
    - GitHub Actions CI/CD
    - Complete VSCode configuration (launch, tasks, extensions)
    - Report templates
    - Advanced utilities
    - Documentation structure
.PARAMETER ProjectName
    Name of the project
.PARAMETER PythonVersion
    Python version (default: 3.12)
.PARAMETER GitRepo
    Optional: Git repository URL to clone
.EXAMPLE
    .\setup_project_tier3.ps1 -ProjectName "enterprise_analysis"
.EXAMPLE
    .\setup_project_tier3.ps1 -ProjectName "enterprise_analysis" -GitRepo "https://github.com/user/repo.git"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [string]$PythonVersion = "3.12",
    
    [string]$GitRepo = ""
)

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "TIER 3: FULL ENTERPRISE SETUP" -ForegroundColor Green
Write-Host "Project: $ProjectName" -ForegroundColor Green
Write-Host "Python Version: $PythonVersion" -ForegroundColor Green
if ($GitRepo -ne "") {
    Write-Host "Git Repository: $GitRepo" -ForegroundColor Green
}
Write-Host "=====================================" -ForegroundColor Cyan

# ============================================
# Handle Git Repository
# ============================================

if ($GitRepo -ne "") {
    Write-Host "`nCloning repository: $GitRepo" -ForegroundColor Yellow
    git clone $GitRepo $ProjectName
    Set-Location $ProjectName
    
    # Check if environment.yml exists
    if (Test-Path "environment.yml") {
        Write-Host "Found existing environment.yml - will create environment next..." -ForegroundColor Green
    } else {
        Write-Host "No environment.yml found, will create full structure..." -ForegroundColor Yellow
    }
} else {
    # Create main directory
    Write-Host "`nCreating project directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $ProjectName -Force | Out-Null
    Set-Location $ProjectName

    # Initialize Git
    Write-Host "Initializing new Git repository..." -ForegroundColor Yellow
    git init
    git branch -M main
}

# ============================================
# Create Complete Folder Structure
# ============================================
Write-Host "Creating complete folder structure..." -ForegroundColor Yellow

$folders = @(
    ".github\workflows",
    ".vscode",
    "alembic\versions",
    "config",
    "data\raw",
    "data\interim",
    "data\processed",
    "data\reference",
    "docs\api",
    "docs\guides",
    "logs",
    "notebooks\exploratory",
    "notebooks\development",
    "notebooks\final",
    "reports\excel",
    "reports\pdf",
    "reports\presentations",
    "scripts",
    "sql\queries",
    "sql\procedures",
    "src\database",
    "src\utils",
    "src\analysis",
    "src\visualization",
    "templates",
    "tests"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
}

# ============================================
# Create .gitkeep Files
# ============================================
$gitkeepDirs = @(
    "data\raw",
    "data\interim",
    "data\processed",
    "data\reference",
    "logs",
    "reports\excel",
    "reports\pdf",
    "reports\presentations"
)

foreach ($dir in $gitkeepDirs) {
    if (-not (Test-Path "$dir\.gitkeep")) {
        New-Item -ItemType File -Path "$dir\.gitkeep" -Force | Out-Null
    }
}

# ============================================
# Create __init__.py Files
# ============================================
Write-Host "Creating Python package files..." -ForegroundColor Yellow

$initDirs = @(
    "src",
    "src\database",
    "src\utils",
    "src\analysis",
    "src\visualization",
    "tests"
)

foreach ($dir in $initDirs) {
    if (-not (Test-Path "$dir\__init__.py")) {
        New-Item -ItemType File -Path "$dir\__init__.py" -Force | Out-Null
    }
}

# ============================================
# Create .gitignore
# ============================================
$gitignoreFile = ".gitignore"
$writeGitignore = $true

if (Test-Path $gitignoreFile) {
    $answer = Read-Host ".gitignore already exists. Replace it? (y/N)"

    if ($answer -notin @("y", "Y", "yes", "YES")) {
        Write-Host "Keeping existing .gitignore and continuing..." -ForegroundColor Cyan
        $writeGitignore = $false
    }
    else {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupFile = ".gitignore.bak.$timestamp"

        Copy-Item $gitignoreFile $backupFile -Force
        Write-Host "Backup created: $backupFile" -ForegroundColor DarkYellow
        Write-Host "Replacing .gitignore..." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Creating .gitignore..." -ForegroundColor Yellow
}

if ($writeGitignore) {
    @'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/

# Jupyter
.ipynb_checkpoints
*.ipynb_checkpoints/

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# Data files
data/raw/*
!data/raw/.gitkeep
data/interim/*
!data/interim/.gitkeep
data/processed/*
!data/processed/.gitkeep

# Reports
reports/excel/*
!reports/excel/.gitkeep
reports/pdf/*
!reports/pdf/.gitkeep
reports/presentations/*
!reports/presentations/.gitkeep

# Logs
logs/*
!logs/.gitkeep
*.log

# Database
*.db
*.sqlite
*.sqlite3

# Environment variables
.env
.env.local

# OS
.DS_Store
Thumbs.db
desktop.ini

# Temporary files
*.tmp
*.bak
~$*.xlsx
~$*.docx
'@ | Out-File -FilePath ".gitignore" -Encoding UTF8
}

# ============================================
# Create .env.example
# ============================================
if (-not (Test-Path ".env.example")) {
    Write-Host "Creating environment files..." -ForegroundColor Yellow

    @'
# ============================================
# Database Configuration
# ============================================
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# ============================================
# Application Settings
# ============================================
APP_ENV=development
DEBUG=True
LOG_LEVEL=INFO

# ============================================
# API Keys
# ============================================
API_KEY=your_api_key_here

# ============================================
# File Paths
# ============================================
DATA_DIR=./data
OUTPUT_DIR=./reports

# ============================================
# Email Configuration
# ============================================
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@example.com
SMTP_PASSWORD=your_email_password
'@ | Out-File -FilePath ".env.example" -Encoding UTF8
}

# ============================================
# Create environment.yml
# ============================================
$envFile = "environment.yml"

$writeFile = $true

if (Test-Path $envFile) {
    $answer = Read-Host "environment.yml already exists. Replace it? (y/N)"

    if ($answer -notin @("y", "Y", "yes", "YES")) {
        Write-Host "Keeping existing environment.yml and continuing..." -ForegroundColor Cyan
        $writeFile = $false
    }
    else {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupFile = "environment.yml.bak.$timestamp"

        Copy-Item $envFile $backupFile -Force
        Write-Host "Backup created: $backupFile" -ForegroundColor DarkYellow
        Write-Host "Replacing environment.yml..." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Creating environment.yml..." -ForegroundColor Yellow
}

if ($writeFile) {
@"
name: $ProjectName
channels:
  - conda-forge
  - defaults

dependencies:
  - python=$PythonVersion
  - pip

  - pandas>=2.1,<3
  - numpy>=1.26,<2
  - openpyxl
  - xlsxwriter

  - sqlalchemy>=2,<3
  - psycopg2>=2.9,<3
  - alembic>=1.13,<2

  - scipy>=1.11,<2
  - scikit-learn>=1.3,<2

  - matplotlib>=3.8,<4
  - seaborn>=0.13,<1
  - plotly>=5.18,<6

  - jupyter
  - ipykernel>=6.25,<7
  - notebook>=7,<8

  - pytest
  - pytest-cov
  - black
  - isort
  - flake8
  - mypy

  - python-dotenv
  - pyyaml
  - click

  - pip:
    - pyyaml
    - types-PyYAML
    - pre-commit==3.6.*
"@ | Out-File -FilePath $envFile -Encoding UTF8
}

# ============================================
# Create pyproject.toml
# ============================================
if (-not (Test-Path "pyproject.toml")) {
    Write-Host "Creating pyproject.toml..."

    @"
[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.build_meta"

[project]
name = "$ProjectName"
version = "0.1.0"
description = "Data analysis tools for mechanical engineering"
requires-python = ">=3.12"
dependencies = [
    "pandas>=2.1.0",
    "numpy>=1.26.0",
    "sqlalchemy>=2.0.0",
    "psycopg2>=2.9.0",
    "python-dotenv>=1.0.0"
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "black>=23.12.0",
    "isort>=5.13.0",
    "flake8>=6.1.0",
    "mypy>=1.7.1",
    "pre-commit>=3.6.0",
    "types-PyYAML"
]

[tool.setuptools.packages.find]
where = ["src"]

[tool.black]
line-length = 88
target-version = ["py312"]

[tool.isort]
profile = "black"
line_length = 88
known_first_party = ["src"]

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "--verbose",
    "--cov=src",
    "--cov-report=html",
    "--cov-report=term-missing"
]

[tool.mypy]
python_version = "3.12"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
ignore_missing_imports = true
"@ | Out-File -FilePath "pyproject.toml" -Encoding utf8NoBOM
}

# ============================================
# Create .pre-commit-config.yaml
# ============================================
if (-not (Test-Path ".pre-commit-config.yaml")) {
    Write-Host "Creating pre-commit config..."

    @'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
        args: ['--maxkb=10000']
      - id: check-json
      - id: check-toml
      - id: check-merge-conflict
      - id: detect-private-key

  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black
        language_version: python3.12

  - repo: https://github.com/PyCQA/isort
    rev: 5.13.2
    hooks:
      - id: isort
        args: ["--profile", "black"]

  - repo: https://github.com/PyCQA/flake8
    rev: 6.1.0
    hooks:
      - id: flake8
        args: ['--max-line-length=88', '--extend-ignore=E203']

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        additional_dependencies:
          - pyyaml
          - types-PyYAML

'@ | Out-File -FilePath ".pre-commit-config.yaml" -Encoding UTF8
}

# ============================================
# Create GitHub Actions CI
# ============================================
if (-not (Test-Path ".github\workflows\ci.yml")) {
    Write-Host "Creating GitHub Actions CI..."

    @'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: "3.12"
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install pytest pytest-cov black isort flake8
    
    - name: Lint with flake8
      run: flake8 src/ tests/ --count --max-line-length=88 --statistics
    
    - name: Check formatting
      run: black --check src/ tests/
    
    - name: Check imports
      run: isort --check-only src/ tests/
    
    - name: Run tests
      run: pytest tests/ --cov=src --cov-report=xml
'@ | Out-File -FilePath ".github\workflows\ci.yml" -Encoding UTF8
}

# ============================================
# Create VSCode Configuration Files
# ============================================
Write-Host "Creating VSCode configuration..."

# settings.json
if (-not (Test-Path ".vscode\settings.json")) {
    @'
{
    "python.defaultInterpreterPath": "${workspaceFolder}/.venv/Scripts/python.exe",
    "python.analysis.extraPaths": ["${workspaceFolder}/src"],
    "python.testing.pytestEnabled": true,
    "python.testing.pytestArgs": ["tests"],
    "python.formatting.provider": "black",
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.linting.mypyEnabled": true,
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    },
    "files.exclude": {
        "**/__pycache__": true,
        "**/*.pyc": true,
        "**/.pytest_cache": true
    },
    "jupyter.notebookFileRoot": "${workspaceFolder}",
    "[python]": {
        "editor.rulers": [88],
        "editor.tabSize": 4
    }
}
'@ | Out-File -FilePath ".vscode\settings.json" -Encoding UTF8
}

# launch.json
if (-not (Test-Path ".vscode\launch.json")) {
    @'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "envFile": "${workspaceFolder}/.env"
        },
        {
            "name": "Python: Pytest",
            "type": "python",
            "request": "launch",
            "module": "pytest",
            "args": ["-v", "tests/"],
            "console": "integratedTerminal",
            "envFile": "${workspaceFolder}/.env"
        }
    ]
}
'@ | Out-File -FilePath ".vscode\launch.json" -Encoding UTF8
}

# tasks.json
if (-not (Test-Path ".vscode\tasks.json")) {
    @'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Run Tests",
            "type": "shell",
            "command": "pytest",
            "args": ["-v"],
            "group": {"kind": "test", "isDefault": true}
        },
        {
            "label": "Format Code",
            "type": "shell",
            "command": "black",
            "args": ["src/", "tests/", "scripts/"]
        },
        {
            "label": "Lint",
            "type": "shell",
            "command": "flake8",
            "args": ["src/", "tests/", "scripts/"]
        }
    ]
}
'@ | Out-File -FilePath ".vscode\tasks.json" -Encoding UTF8
}

# extensions.json
if (-not (Test-Path ".vscode\extensions.json")) {
    @'
{
    "recommendations": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-toolsai.jupyter",
        "ms-python.black-formatter",
        "ms-python.isort",
        "ms-python.flake8",
        "ckolkman.vscode-postgres",
        "yzhang.markdown-all-in-one",
        "eamodio.gitlens"
    ]
}
'@ | Out-File -FilePath ".vscode\extensions.json" -Encoding UTF8
}

# ============================================
# Create Source Code Files
# ============================================
Write-Host "Creating source code templates..." -ForegroundColor Yellow

# src/__init__.py
if ($null -eq (Get-Content "src\__init__.py" -ErrorAction SilentlyContinue) -or (Get-Content "src\__init__.py").Length -eq 0) {
    @'
"""$ProjectName - Main package."""

__version__ = "0.1.0"
'@ | Out-File -FilePath "src\__init__.py" -Encoding UTF8
}

# src/database/connection.py
if (-not (Test-Path "src\database\connection.py")) {
    @'
"""Database connection utilities."""

import os
from contextlib import contextmanager
from typing import Generator

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import Session, sessionmaker

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

if DATABASE_URL:
    engine = create_engine(
        DATABASE_URL,
        echo=False,
        pool_pre_ping=True,
        pool_size=5,
        max_overflow=10,
    )
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    Base = declarative_base()
else:
    engine = None
    SessionLocal = None
    Base = declarative_base()


@contextmanager
def get_db() -> Generator[Session, None, None]:
    """Context manager for database sessions."""
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


def init_db() -> None:
    """Initialize database tables."""
    if engine:
        Base.metadata.create_all(bind=engine)
'@ | Out-File -FilePath "src\database\connection.py" -Encoding UTF8
}

# src/database/models.py
if (-not (Test-Path "src\database\models.py")) {

@'
"""Database models."""

from datetime import datetime
from sqlalchemy import Column, DateTime, Float, Integer, String, Text

from src.database.connection import Base


class AnalysisResult(Base):
    """Model for storing analysis results."""

    __tablename__ = "analysis_results"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    description = Column(Text)
    value = Column(Float, nullable=False)
    unit = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self) -> str:
        return "<AnalysisResult(id={}, name={})>".format(self.id, self.name)
'@| Out-File -FilePath "src\database\models.py" -Encoding UTF8

}

# src/utils/helpers.py
if (-not (Test-Path "src\utils\helpers.py")) {
    @'
"""Common utility functions."""

import logging
import os
from pathlib import Path
from typing import Any, Dict

import yaml
from dotenv import load_dotenv

load_dotenv()

logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)

logger = logging.getLogger(__name__)


def load_config(config_path: str = "config/settings.yml") -> Dict[str, Any]:
    """Load configuration from YAML file."""
    config_file = Path(config_path)
    if not config_file.exists():
        logger.warning(f"Config file {config_path} not found")
        return {}
    with open(config_file, "r") as f:
        config = yaml.safe_load(f)
    return config or {}


def ensure_dir(directory: Path) -> None:
    """Ensure directory exists."""
    Path(directory).mkdir(parents=True, exist_ok=True)


def get_project_root() -> Path:
    """Get the project root directory."""
    return Path(__file__).parent.parent.parent
'@ | Out-File -FilePath "src\utils\helpers.py" -Encoding UTF8
}

# ============================================
# Create Test Files
# ============================================
Write-Host "Creating test templates..." -ForegroundColor Yellow

# tests/conftest.py
if (-not (Test-Path "tests\conftest.py")) {
    @'
"""Pytest configuration and fixtures."""

import os
from typing import Generator

import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from src.database.connection import Base

TEST_DATABASE_URL = os.getenv(
    "TEST_DATABASE_URL",
    "postgresql://testuser:testpass@localhost:5432/testdb"
)


@pytest.fixture(scope="session")
def engine():
    """Create test database engine."""
    engine = create_engine(TEST_DATABASE_URL)
    Base.metadata.create_all(bind=engine)
    yield engine
    Base.metadata.drop_all(bind=engine)


@pytest.fixture(scope="function")
def db_session(engine) -> Generator[Session, None, None]:
    """Create a test database session."""
    TestSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    session = TestSessionLocal()
    try:
        yield session
    finally:
        session.rollback()
        session.close()


@pytest.fixture
def sample_data():
    """Provide sample data for tests."""
    return {
        "name": "Test Analysis",
        "value": 42.5,
        "unit": "kN"
    }
'@ | Out-File -FilePath "tests\conftest.py" -Encoding UTF8
}

# tests/test_database.py
if (-not (Test-Path "tests\test_database.py")) {
    @'
"""Tests for database operations."""

from sqlalchemy.orm import Session

from src.database.models import AnalysisResult


def test_create_analysis_result(db_session: Session, sample_data):
    """Test creating an analysis result."""
    result = AnalysisResult(**sample_data)
    db_session.add(result)
    db_session.commit()
    
    assert result.id is not None
    assert result.name == sample_data["name"]
'@ | Out-File -FilePath "tests\test_database.py" -Encoding UTF8
}

# ============================================
# Create Example Script
# ============================================
if (-not (Test-Path "scripts\data_processing.py")) {
    @'
"""Example data processing script."""

from src.utils.helpers import ensure_dir, get_project_root


def process_data():
    """Process data example."""
    root = get_project_root()
    
    # Example: Load data
    # data_path = root / "data" / "raw" / "input.csv"
    # df = pd.read_csv(data_path)
    
    # Process data
    # ...
    
    # Save results
    output_dir = root / "data" / "processed"
    ensure_dir(output_dir)
    # df.to_csv(output_dir / "output.csv", index=False)
    
    print("Data processing complete!")


if __name__ == "__main__":
    process_data()
'@ | Out-File -FilePath "scripts\data_processing.py" -Encoding UTF8
}

# ============================================
# Create HTML Template
# ============================================
if (-not (Test-Path "templates\report_template.html")) {
    @'
<!DOCTYPE html>
<html>
<head>
    <title>Analysis Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4472C4; color: white; }
    </style>
</head>
<body>
    <h1>Analysis Report</h1>
    <p>Generated: {{ date }}</p>
    <table>
        <tr>
            <th>Name</th>
            <th>Value</th>
            <th>Unit</th>
        </tr>
        {% for result in results %}
        <tr>
            <td>{{ result.name }}</td>
            <td>{{ result.value }}</td>
            <td>{{ result.unit }}</td>
        </tr>
        {% endfor %}
    </table>
</body>
</html>
'@ | Out-File -FilePath "templates\report_template.html" -Encoding UTF8
}

# ============================================
# Create README
# ============================================
$readmeFile = "README.md"
$writeReadme = $true

if (Test-Path $readmeFile) {
    $answer = Read-Host "README.md already exists. Replace it? (y/N)"

    if ($answer -notin @("y", "Y", "yes", "YES")) {
        Write-Host "Keeping existing README.md and continuing..." -ForegroundColor Cyan
        $writeReadme = $false
    }
    else {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupFile = "README.md.bak.$timestamp"

        Copy-Item $readmeFile $backupFile -Force
        Write-Host "Backup created: $backupFile" -ForegroundColor DarkYellow
        Write-Host "Replacing README.md..." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Creating README.md..." -ForegroundColor Yellow
}

if ($writeReadme) {
    @'
# $ProjectName

## Project Overview

Data analysis project for mechanical engineering applications.

## Setup Instructions

### Prerequisites

- Python 3.12
- Miniconda or Anaconda
- PostgreSQL 14+
- Git

### Installation

1. **Clone and navigate:**
```bash
git clone <repository-url>
cd $ProjectName
```

2. **Create environment:**
```bash
conda env create -f environment.yml
conda activate $ProjectName
```

3. **Configure environment variables:**
```bash
copy .env.example .env
# Edit .env with your credentials
```

4. **Initialize database:**
```bash
alembic init alembic
# Configure alembic.ini and alembic/env.py
alembic revision --autogenerate -m "Initial tables"
alembic upgrade head
```

5. **Install pre-commit hooks:**
```bash
pre-commit install
```

## Project Structure
```
├── data/              # Data storage
├── notebooks/         # Jupyter notebooks
├── src/               # Source code
├── tests/             # Test suite
├── scripts/           # Automation scripts
└── reports/           # Generated outputs
```

## Usage

### Running Analysis
```bash
python scripts/data_processing.py
```

### Running Notebooks
```bash
jupyter notebook
```

### Running Tests
```bash
pytest
```

### Code Quality
```bash
black src/ tests/ scripts/
isort src/ tests/ scripts/
flake8 src/ tests/ scripts/
mypy src/
```

## Database Migrations
```bash
# Create migration
alembic revision --autogenerate -m "Description"

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```

## Development Workflow

Create feature branch
Write code and tests
Run quality checks
Commit (pre-commit hooks run automatically)
Push and create pull request

## License

This project is licensed under the MIT License.

## Contact

Your Name - your.email@example.com
'@ | Out-File -FilePath "README.md" -Encoding UTF8
}

# ============================================
# Create LICENSE
# ============================================
$licenseFile = "LICENSE"
$writeLicense = $true

if (Test-Path $licenseFile) {
    $answer = Read-Host "LICENSE already exists. Replace it? (y/N)"

    if ($answer -notin @("y", "Y", "yes", "YES")) {
        Write-Host "Keeping existing LICENSE and continuing..." -ForegroundColor Cyan
        $writeLicense = $false
    }
    else {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupFile = "LICENSE.bak.$timestamp"

        Copy-Item $licenseFile $backupFile -Force
        Write-Host "Backup created: $backupFile" -ForegroundColor DarkYellow
        Write-Host "Replacing LICENSE..." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Creating LICENSE..." -ForegroundColor Yellow
}

if ($writeLicense) {
    @'
MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

'@ | Out-File -FilePath "LICENSE" -Encoding UTF8
}

# ============================================
# Create Conda Environment
# ============================================
Write-Host "`nUpdating conda..." -ForegroundColor Cyan
conda update -n base -c defaults conda -y

Write-Host "`nCreating conda environment..." -ForegroundColor Yellow
conda env create -f environment.yml

# ============================================
# Activate Environment & Install Pre-commit
# ============================================
Write-Host "`nSetting up pre-commit hooks..." -ForegroundColor Yellow

# Install pre-commit using conda run (works without activating)
Write-Host "  Installing pre-commit in environment..." -ForegroundColor DarkGray
conda run -n $ProjectName pip install pre-commit

Write-Host "  Initializing pre-commit hooks..." -ForegroundColor DarkGray
conda run -n $ProjectName pre-commit install

Write-Host "[OK] Pre-commit hooks installed!" -ForegroundColor Green

# ============================================
# Initial Git Commit
# ============================================
Write-Host "`nCreating initial git commit..." -ForegroundColor Yellow

# Show what will be committed
Write-Host "`nFiles to be committed:" -ForegroundColor Cyan
git status --short

# Add all files
git add .

# Create comprehensive commit message
$commitMessage = @"
Initial project structure - Tier 3 Full Setup

PROJECT STRUCTURE
- Complete data pipeline folders (raw/interim/processed/reference)
- Organized notebooks (exploratory/development/final)
- Modular source code (database/utils/analysis/visualization)
- Test suite with pytest configuration
- CI/CD with GitHub Actions

CONFIGURATION
- environment.yml: Complete data science stack
- pyproject.toml: Modern Python configuration
- Pre-commit hooks: Code quality automation
- VSCode: Full IDE integration

DATABASE & TOOLS
- SQLAlchemy + Alembic for migrations
- PostgreSQL configuration
- Code quality: Black, isort, flake8, mypy
- Testing: pytest with coverage

DOCUMENTATION & TEMPLATES
- Comprehensive README
- HTML report templates
- Example processing scripts

---
Project: $ProjectName
Python: $PythonVersion
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Tier: 3 (Full Enterprise Configuration)
"@

git commit -m $commitMessage

Write-Host "`n[OK] Initial commit created!" -ForegroundColor Green

# Create version tag
git tag -a "v0.1.0" -m "Initial project setup"
Write-Host "[OK] Tagged as v0.1.0" -ForegroundColor Green

# ============================================
# Handle GitHub Repository Setup
# ============================================
Write-Host "`nRepository Setup..." -ForegroundColor Yellow

if ($GitRepo -ne "") {
    # Repository was cloned, origin already exists
    Write-Host "  Repository origin already set to: $GitRepo" -ForegroundColor Green
    
    Write-Host "`nReady to push to origin!" -ForegroundColor Cyan
    Write-Host "  Run these commands to push:" -ForegroundColor White
    Write-Host "  cd $ProjectName" -ForegroundColor DarkGray
    Write-Host "  git push -u origin main" -ForegroundColor DarkGray
    Write-Host "  git push --tags" -ForegroundColor DarkGray
    
} else {
    # New project - need to set up remote
    Write-Host "  No remote repository configured yet." -ForegroundColor Yellow
    
    # Check if GitHub CLI is available
    $ghCliAvailable = Get-Command gh -ErrorAction SilentlyContinue
    
    if ($ghCliAvailable) {
        Write-Host "`nGitHub CLI detected!" -ForegroundColor Cyan
        Write-Host "  You can create a GitHub repository with:" -ForegroundColor White
        Write-Host "  gh repo create $ProjectName --private --source=. --remote=origin" -ForegroundColor DarkGray
        Write-Host "  git push -u origin main" -ForegroundColor DarkGray
        Write-Host "  git push --tags" -ForegroundColor DarkGray
        
        Write-Host "`n  Or create it manually at: https://github.com/new" -ForegroundColor DarkGray
    } else {
        Write-Host "`nTo push to GitHub:" -ForegroundColor Cyan
        Write-Host "  1. Create repository at: https://github.com/new" -ForegroundColor White
        Write-Host "  2. Then run:" -ForegroundColor White
        Write-Host "     git remote add origin https://github.com/yourusername/$ProjectName.git" -ForegroundColor DarkGray
        Write-Host "     git push -u origin main" -ForegroundColor DarkGray
        Write-Host "     git push --tags" -ForegroundColor DarkGray
        
        Write-Host "`n  TIP: Install GitHub CLI for easier repo creation:" -ForegroundColor Cyan
        Write-Host "     winget install GitHub.cli" -ForegroundColor DarkGray
    }
}

# ============================================
# Success Message
# ============================================
Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "TIER 3 SETUP COMPLETE!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "`nWhat was created:" -ForegroundColor Cyan
Write-Host "  [OK] - Complete enterprise folder structure" -ForegroundColor White
Write-Host "  [OK] - Database module with Alembic support" -ForegroundColor White
Write-Host "  [OK] - Complete code quality tools" -ForegroundColor White
Write-Host "  [OK] - Pre-commit hooks installed" -ForegroundColor Green
Write-Host "  [OK] - Full VSCode configuration" -ForegroundColor White
Write-Host "  [OK] - GitHub Actions CI/CD" -ForegroundColor White
Write-Host "  [OK] - Testing infrastructure" -ForegroundColor White
Write-Host "  [OK] - Report templates" -ForegroundColor White
Write-Host "  [OK] - Example scripts" -ForegroundColor White
Write-Host "  [OK] - Complete documentation" -ForegroundColor White
Write-Host "  [OK] - Conda environment created" -ForegroundColor White
Write-Host "  [OK] - Initial commit created" -ForegroundColor Green
Write-Host "  [OK] - Version tagged (v0.1.0)" -ForegroundColor Green

Write-Host "`nNext Steps:" -ForegroundColor Cyan
Write-Host "  1. conda activate $ProjectName" -ForegroundColor White
Write-Host "  2. copy .env.example .env (and configure)" -ForegroundColor White
Write-Host "  3. Review the initial commit: git show" -ForegroundColor White
Write-Host "  4. Push to GitHub (see instructions above)" -ForegroundColor White
Write-Host "  5. alembic init alembic (if using database)" -ForegroundColor White
Write-Host "  6. jupyter notebook (to start developing)" -ForegroundColor White

Write-Host "`nPro Tips:" -ForegroundColor Cyan
Write-Host "  - Review files before pushing: git status" -ForegroundColor DarkGray
Write-Host "  - View commit details: git show --stat" -ForegroundColor DarkGray
Write-Host "  - List all tags: git tag -l" -ForegroundColor DarkGray

Write-Host "`n"
