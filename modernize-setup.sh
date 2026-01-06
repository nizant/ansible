#!/bin/bash

# Modern Ansible Network Automation Setup Script
# This script helps update your environment to modern practices

echo "🚀 Ansible Network Automation Modernization Script"
echo "=================================================="

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command_exists ansible; then
    echo "❌ Ansible not found. Please install Ansible first."
    echo "   pip3 install ansible"
    exit 1
fi

echo "✅ Ansible found: $(ansible --version | head -1)"

# Check Python version
PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "✅ Python version: $PYTHON_VERSION"

# Install/Update required collections
echo ""
echo "📦 Installing/Updating Ansible collections..."

echo "Installing junipernetworks.junos collection..."
ansible-galaxy collection install junipernetworks.junos --upgrade

echo "Installing ansible.netcommon collection..."
ansible-galaxy collection install ansible.netcommon --upgrade

echo "Installing community.general collection..."
ansible-galaxy collection install community.general --upgrade

# Create directory structure
echo ""
echo "📁 Creating modern directory structure..."

mkdir -p group_vars/all
mkdir -p host_vars
mkdir -p roles
mkdir -p playbooks
mkdir -p backups
mkdir -p logs

echo "✅ Directory structure created"

# Create Ansible vault for credentials
echo ""
echo "🔐 Setting up Ansible Vault for security..."

if [ ! -f "group_vars/all/vault.yml" ]; then
    echo "Creating vault file template..."
    echo "Please run: ansible-vault create group_vars/all/vault.yml"
    echo "And add your credentials using the template in vault-template.yml"
else
    echo "✅ Vault file already exists"
fi

# Test connectivity
echo ""
echo "🧪 Testing updated configuration..."

echo "Checking inventory syntax..."
ansible-inventory -i inventory.yml --list >/dev/null 2>&1 && echo "✅ Inventory syntax OK" || echo "❌ Inventory syntax error"

echo "Testing connectivity to devices..."
ansible juniper -i inventory.yml -m junipernetworks.junos.junos_facts -a "gather_subset=default" --ask-vault-pass --check

echo ""
echo "🎉 Modernization complete!"
echo ""
echo "Next steps:"
echo "1. Create your vault file: ansible-vault create group_vars/all/vault.yml"
echo "2. Update your device credentials in the vault"
echo "3. Test with: ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass"
echo "4. Review and migrate your existing playbooks using the updated templates"