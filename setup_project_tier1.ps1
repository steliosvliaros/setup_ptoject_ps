<#
.SYNOPSIS
    Tier 1: Minimal Quick Start
.DESCRIPTION
    Creates a basic data analysis project structure
    - Essential folders only
    - Minimal Python environment
    - Basic Git setup
.PARAMETER ProjectName
    Name of the project
.PARAMETER PythonVersion
    Python version (default: 3.12)
.EXAMPLE
    .\setup_project_tier1.ps1 -ProjectName "quick_analysis"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [string]$PythonVersion = "3.12"
)

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "TIER 1: MINIMAL QUICK START" -ForegroundColor Green
Write-Host "Project: $ProjectName" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

# ============================================
# Create Project and Initialize Git
# ============================================
Write-Host "`nCreating project..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $ProjectName -Force | Out-Null
Set-Location $ProjectName

git init
git branch -M main

# ============================================
# Create Minimal Folder Structure
# ============================================
$folders = @(
    "data",
    "notebooks",
    "src",
    "scripts"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

New-Item -ItemType File -Path "src\__init__.py" -Force | Out-Null

# ============================================
# Create .gitignore
# ============================================
@'
__pycache__/
*.pyc
.env
.venv
venv/
.ipynb_checkpoints
*.log
data/*
!data/.gitkeep
.DS_Store
'@ | Out-File -FilePath ".gitignore" -Encoding UTF8

New-Item -ItemType File -Path "data\.gitkeep" -Force | Out-Null

# ============================================
# Create environment.yml
# ============================================
@"
name: $ProjectName
channels:
  - conda-forge
  - defaults

dependencies:
  - python=$PythonVersion
  - pandas
  - numpy
  - matplotlib
  - jupyter
  - openpyxl
"@ | Out-File -FilePath "environment.yml" -Encoding UTF8

# ============================================
# Create Basic README
# ============================================
@"
# $ProjectName

Quick start data analysis project.

## Setup

\`\`\`bash
conda env create -f environment.yml
conda activate $ProjectName
\`\`\`

## Structure

- \`data/\` - Your data files
- \`notebooks/\` - Jupyter notebooks
- \`src/\` - Python modules
- \`scripts/\` - Scripts

## Usage

\`\`\`bash
jupyter notebook
\`\`\`
"@ | Out-File -FilePath "README.md" -Encoding UTF8

# ============================================
# Create Example Notebook Starter
# ============================================
@'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": ["# Analysis Notebook\n\n"]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "source": [
    "import pandas as pd\n",
    "import numpy as np\n",
    "import matplotlib.pyplot as plt\n\n",
    "# Load data\n",
    "# df = pd.read_csv('data/file.csv')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "source": ["# Analysis code here"]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
'@ | Out-File -FilePath "notebooks\analysis.ipynb" -Encoding UTF8

# ============================================
# Create Conda Environment
# ============================================
Write-Host "`nCreating conda environment..." -ForegroundColor Yellow
conda env create -f environment.yml

# ============================================
# Git Commit
# ============================================
git add .
git commit -m "Initial setup - Tier 1 Minimal`n`nProject: $ProjectName`nPython: $PythonVersion"
git tag -a "v0.1.0" -m "Initial setup"

# ============================================
# Success
# ============================================
Write-Host "`n=====================================" -ForegroundColor Green
Write-Host "SETUP COMPLETE!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

Write-Host "`nCreated:" -ForegroundColor Cyan
Write-Host "  ✓ Folder structure" -ForegroundColor White
Write-Host "  ✓ Python environment" -ForegroundColor White
Write-Host "  ✓ Git repository" -ForegroundColor White
Write-Host "  ✓ Example notebook" -ForegroundColor White

Write-Host "`nGet Started:" -ForegroundColor Cyan
Write-Host "  conda activate $ProjectName" -ForegroundColor Yellow
Write-Host "  jupyter notebook" -ForegroundColor Yellow

Write-Host "`n"
