#!/bin/bash

set -euo pipefail

#############################################
# DevOps Workstation Bootstrap Script
#
# Target:
# - Ubuntu 22.04 / 24.04
# - WSL2 Environment
#
# Installs:
# - Git
# - AWS CLI
# - Terraform
# - kubectl
# - Helm
# - jq
# - Trivy
#
# Creates:
# - ~/dev workspace
#
# Author: Yuval
#############################################

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"


log() {
    echo -e "${GREEN}[+]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}


command_exists() {
    command -v "$1" >/dev/null 2>&1
}


#############################################
# OS Validation
#############################################

if ! command_exists apt; then
    error "This script supports Debian/Ubuntu only."
    exit 1
fi


log "Updating Ubuntu packages..."

sudo apt update
sudo apt upgrade -y


#############################################
# Base Packages
#############################################

log "Installing base packages..."

sudo apt install -y \
    git \
    curl \
    wget \
    unzip \
    jq \
    tree \
    ca-certificates \
    gnupg \
    lsb-release


#############################################
# Git
#############################################

if command_exists git; then
    log "Git already installed ✓"
else
    sudo apt install git -y
fi


#############################################
# Terraform
#############################################

if command_exists terraform; then

    log "Terraform already installed ✓"

else

    log "Installing Terraform..."

    wget -O- https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor \
    -o /usr/share/keyrings/hashicorp-archive-keyring.gpg


    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list


    sudo apt update
    sudo apt install terraform -y

fi


#############################################
# AWS CLI
#############################################

if command_exists aws; then

    log "AWS CLI already installed ✓"

else

    log "Installing AWS CLI..."

    curl \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o awscliv2.zip


    unzip awscliv2.zip

    sudo ./aws/install

    rm -rf aws awscliv2.zip

fi


#############################################
# kubectl
#############################################

if command_exists kubectl; then

    log "kubectl already installed ✓"

else

    log "Installing kubectl..."

    curl -LO \
    "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"


    chmod +x kubectl

    sudo mv kubectl /usr/local/bin/

fi


#############################################
# Helm
#############################################

if command_exists helm; then

    log "Helm already installed ✓"

else

    log "Installing Helm..."

    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

fi


#############################################
# Trivy
#############################################

if command_exists trivy; then

    log "Trivy already installed ✓"

else

    log "Installing Trivy..."

    sudo apt install -y apt-transport-https


    wget -qO - \
    https://aquasecurity.github.io/trivy-repo/deb/public.key | \
    sudo gpg --dearmor \
    -o /usr/share/keyrings/trivy.gpg


    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb \
$(lsb_release -sc) main" | \
sudo tee /etc/apt/sources.list.d/trivy.list


    sudo apt update

    sudo apt install trivy -y

fi


#############################################
# Docker Validation
#############################################

if command_exists docker; then

    log "Docker CLI detected ✓"


    if docker info >/dev/null 2>&1; then

        log "Docker Desktop connection OK ✓"

    else

        warn "Docker CLI exists but Docker Engine is unavailable."
        warn "Check Docker Desktop WSL Integration."

    fi

else

    warn "Docker CLI not found."

fi


#############################################
# Workspace
#############################################

log "Creating DevOps workspace..."

mkdir -p ~/dev/{terraform,aws,kubernetes,docker,security,scripts}


cat <<EOF > ~/dev/README.md

# DevOps Workspace

Created by bootstrap script.

## Structure

terraform/
aws/
kubernetes/
docker/
security/
scripts/

EOF


#############################################
# Verification
#############################################

echo ""
log "Installation summary:"
echo ""

echo "Git:"
git --version

echo ""

echo "Terraform:"
terraform -version | head -1

echo ""

echo "AWS CLI:"
aws --version

echo ""

echo "kubectl:"
kubectl version --client --short 2>/dev/null || true

echo ""

echo "Helm:"
helm version --short

echo ""

echo "jq:"
jq --version

echo ""

echo "Trivy:"
trivy --version


echo ""
log "DevOps environment setup completed successfully 🚀"