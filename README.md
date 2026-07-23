# DevOps Environment Bootstrap

Automated bootstrap script for creating a DevOps engineering environment on **Windows using WSL2 with Ubuntu 24.04**.

This project provides a simple and repeatable way to prepare a Cloud/DevOps workstation by installing and validating commonly used tools for Infrastructure as Code, Cloud management, Kubernetes, containers, and security.

---

## Overview

The bootstrap script installs and configures:

- Git
- AWS CLI
- Terraform
- Docker CLI validation
- kubectl
- Helm
- jq
- Trivy

The script also:

- Checks if tools are already installed
- Avoids reinstalling existing tools
- Validates Docker Desktop WSL2 integration
- Creates a structured DevOps workspace
- Performs installation verification

---

## Environment Requirements

This project is designed for:

- Windows 10/11
- WSL2
- Ubuntu 24.04 running inside WSL2
- Docker Desktop with WSL2 integration enabled

---

## Prerequisites

Before running the script, make sure you have:

### Windows

- Windows 10/11 installed
- WSL2 enabled
- Ubuntu 24.04 installed from Microsoft Store

### Ubuntu WSL2

- User with sudo privileges
- Internet connection

### Docker

Docker Desktop must be installed on Windows.

Enable Ubuntu integration:


Docker Desktop
→ Settings
→ Resources
→ WSL Integration
→ Enable Ubuntu


---

## Installation

Clone the repository:

```bash
git clone https://github.com/yuvalozeri1/devops-env-bootstrap.git

Enter the project directory:

cd devops-env-bootstrap

Give execution permission to the script:

chmod +x setup-devops-env.sh

Run the bootstrap script:

./setup-devops-env.sh

The script will automatically:

Update Ubuntu packages
Install required DevOps tools
Skip tools that already exist
Validate Docker Desktop connectivity
Create the DevOps workspace structure
Verify Installation

After the installation completes, verify the tools:

Git
git --version
Terraform
terraform -version
AWS CLI
aws --version
Docker
docker --version
docker run hello-world
Kubernetes CLI
kubectl version --client
Helm
helm version
Trivy
trivy --version
Docker Setup

Docker commands executed inside Ubuntu WSL2 are connected to Docker Desktop running on Windows.

Validate Docker connectivity:

docker info

or:

docker run hello-world

If Docker is unavailable:

Open Docker Desktop
Navigate to:
Settings
→ Resources
→ WSL Integration
Enable Ubuntu integration.
AWS Configuration

After installing AWS CLI, configure your AWS account:

aws configure

You will be asked for:

AWS Access Key ID
AWS Secret Access Key
Default region
Output format

AWS credentials are stored locally:

~/.aws/

Never commit AWS credentials to GitHub.

Workspace Structure

The script creates the following workspace:

~/dev
│
├── terraform
├── aws
├── kubernetes
├── docker
├── security
└── scripts

Folder purpose:

Folder	Purpose
terraform	Infrastructure as Code projects
aws	AWS CLI scripts and cloud labs
kubernetes	Kubernetes manifests and Helm charts
docker	Dockerfiles and container projects
security	Security tools and scanning projects
scripts	Automation scripts
Security

This repository includes a .gitignore file to prevent committing sensitive information.

The following files should never be uploaded to GitHub:

.aws/
*.tfstate
.env
*.pem

Protected content includes:

AWS credentials
Terraform state files
Environment variables
Private keys
Secrets

Always verify files before pushing changes to GitHub.

Project Structure
devops-env-bootstrap
│
├── setup-devops-env.sh
├── README.md
├── .gitignore
└── LICENSE
Future Improvements

Planned improvements:

Add ShellCheck validation
Add GitHub Actions CI pipeline
Add Ansible automation version
Add additional cloud provider support
Add automated security scanning
License

This project is licensed under the MIT License.

Author

Yuval Ozeri
