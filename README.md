# 🌐 Ansible Network Automation

A comprehensive Ansible-based network automation toolkit for managing Juniper devices and network infrastructure.

[![Ansible](https://img.shields.io/badge/Ansible-2.14%2B-red.svg)](https://www.ansible.com/)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue.svg)](https://www.python.org/)
[![Juniper](https://img.shields.io/badge/Juniper-JUNOS-green.svg)](https://www.juniper.net/)

## 🎯 Overview

This project provides automated network management capabilities for Juniper devices using modern Ansible practices. It includes playbooks for device configuration, user management, facts collection, and network monitoring.

### ✨ Key Features

- 🔧 **Device Configuration Management** - Automated configuration deployment and rollback
- 👥 **User Account Management** - Automated user creation and permission management
- 📊 **Network Facts Collection** - Comprehensive device information gathering
- 🔐 **Security-First Approach** - Ansible Vault integration for credential management
- 📱 **Modern Ansible Practices** - Updated to latest collection standards
- 🔄 **Configuration Backup** - Automatic backup before changes
- 📈 **Idempotent Operations** - Safe to run multiple times

## 🏗️ Architecture

```
Network Automation Framework
├── Ansible Control Node
│   ├── Playbooks (Configuration Management)
│   ├── Inventory (Device Registry)
│   └── Vault (Secure Credentials)
└── Target Devices
    ├── Juniper vMX/vQFX
    ├── Physical Juniper Switches
    └── Linux Management Servers
```

## 📋 Prerequisites

### Required Software
- **Ansible 2.14+** - Automation platform
- **Python 3.8+** - Runtime environment
- **Git** - Version control
- **SSH Client** - Device connectivity

### Network Requirements
- **NETCONF access** to Juniper devices (port 830)
- **SSH access** to Linux servers (port 22)
- **Network connectivity** between Ansible control node and target devices

### Device Requirements
- **Juniper devices**: JUNOS 15.1+ with NETCONF enabled
- **Linux servers**: SSH daemon running, Python installed

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone <repository-url>
cd network-automation/ansible
```

### 2. Install Dependencies
```bash
# Install Ansible collections
ansible-galaxy collection install -r requirements-updated.yml

# Or run the modernization script
chmod +x modernize-setup.sh
./modernize-setup.sh
```

### 3. Configure Credentials
```bash
# Create vault file for secure credential storage
mkdir -p group_vars/all
ansible-vault create group_vars/all/vault.yml

# Add your credentials (use vault-template.yml as reference)
```

### 4. Update Inventory
```bash
# Edit inventory.yml with your device details
vim inventory.yml

# Test connectivity
ansible juniper -i inventory.yml -m ping --ask-vault-pass
```

### 5. Run Your First Playbook
```bash
# Collect device facts
ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass

# Check device configuration
ansible-playbook playbook-Configure-updated.yml --ask-vault-pass --check
```

## 📁 Project Structure

```
ansible/
├── 📄 Configuration Files
│   ├── ansible.cfg                    # Ansible configuration
│   ├── inventory.yml                  # Device inventory (YAML format)
│   └── requirements-updated.yml       # Collection requirements
│
├── 🔐 Security
│   ├── group_vars/all/vault.yml      # Encrypted credentials (create this)
│   └── vault-template.yml            # Template for vault setup
│
├── 📚 Playbooks (Updated/Modern)
│   ├── playbook-Junos_facts-updated.yml     # Device facts collection
│   ├── playbook-Configure-updated.yml       # Configuration management
│   └── playbook-AddUser-updated.yml         # User management
│
├── 📚 Playbooks (Legacy)
│   ├── Junos_facts.yml              # Original facts playbook
│   ├── playbook-Add_Username.yml    # Original user management
│   └── [other legacy playbooks]     # Various legacy automation scripts
│
├── 📂 Support Files
│   ├── backups/                     # Configuration backups
│   ├── logs/                        # Execution logs
│   └── facts_*.json                # Collected device facts
│
└── 📋 Documentation
    ├── README.md                    # This file
    ├── MODERNIZATION-GUIDE.md      # Migration documentation
    └── modernize-setup.sh          # Setup automation script
```

## 🔧 Usage Examples

### Device Facts Collection
```bash
# Collect comprehensive device information
ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass

# Collect specific facts only
ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass --tags "hardware"
```

### Configuration Management
```bash
# Preview configuration changes (dry-run)
ansible-playbook playbook-Configure-updated.yml --ask-vault-pass --check --diff

# Apply configuration changes
ansible-playbook playbook-Configure-updated.yml --ask-vault-pass

# Apply to specific device only
ansible-playbook playbook-Configure-updated.yml --ask-vault-pass --limit vMX
```

### User Management
```bash
# Add users to devices
ansible-playbook playbook-AddUser-updated.yml --ask-vault-pass

# Remove users (modify playbook state: absent)
ansible-playbook playbook-AddUser-updated.yml --ask-vault-pass --extra-vars "user_state=absent"
```

### Ad-hoc Commands
```bash
# Check device uptime
ansible juniper -i inventory.yml -m junipernetworks.junos.junos_command -a "commands='show system uptime'" --ask-vault-pass

# Collect interface status
ansible juniper -i inventory.yml -m junipernetworks.junos.junos_command -a "commands='show interfaces terse'" --ask-vault-pass

# Check system alarms
ansible juniper -i inventory.yml -m junipernetworks.junos.junos_command -a "commands='show system alarms'" --ask-vault-pass
```

## ⚙️ Configuration

### Ansible Vault Setup
```bash
# Create encrypted credential file
ansible-vault create group_vars/all/vault.yml

# Add these variables:
vault_juniper_user: your_username
vault_juniper_password: your_password
vault_ansible_user_ssh_key: "ssh-rsa AAAAB3NzaC1yc2E..."

# Edit existing vault
ansible-vault edit group_vars/all/vault.yml

# View vault contents
ansible-vault view group_vars/all/vault.yml
```

### Device Inventory Configuration
```yaml
# inventory.yml
juniper:
  hosts:
    vMX:
      ansible_host: 192.168.1.34
      ansible_network_os: junipernetworks.junos.junos
      ansible_connection: ansible.netcommon.netconf
      ansible_port: 830
      ansible_user: "{{ vault_juniper_user }}"
      ansible_password: "{{ vault_juniper_password }}"
```

## 🔄 Migration from Legacy Setup

If you have an existing Ansible network automation setup, follow these steps:

### 1. **Backup Current Setup**
```bash
cp -r ansible/ ansible-backup-$(date +%Y%m%d)
```

### 2. **Run Modernization Script**
```bash
chmod +x modernize-setup.sh
./modernize-setup.sh
```

### 3. **Update Collections**
```bash
ansible-galaxy collection install -r requirements-updated.yml --upgrade
```

### 4. **Migrate Playbooks**
- Use updated playbooks as templates
- Replace deprecated module names
- Update collection references
- See `MODERNIZATION-GUIDE.md` for detailed migration steps

## 🧪 Testing

### Connectivity Tests
```bash
# Test inventory syntax
ansible-inventory -i inventory.yml --list

# Test device connectivity
ansible juniper -i inventory.yml -m junipernetworks.junos.junos_facts --ask-vault-pass

# Test specific device
ansible vMX -i inventory.yml -m ping --ask-vault-pass
```

### Dry-run Tests
```bash
# Test configuration changes without applying
ansible-playbook playbook-Configure-updated.yml --ask-vault-pass --check --diff

# Test user creation without applying
ansible-playbook playbook-AddUser-updated.yml --ask-vault-pass --check
```

## 🐛 Troubleshooting

### Common Issues and Solutions

#### **Connection Errors**
```bash
# Issue: NETCONF connection failed
# Solution: Verify NETCONF is enabled on device
ansible juniper -m junipernetworks.junos.junos_command -a "commands='show system services'" --ask-vault-pass

# Issue: SSH timeout
# Solution: Check network connectivity and SSH service
ping <device_ip>
telnet <device_ip> 22
```

#### **Authentication Errors**
```bash
# Issue: Authentication failed
# Solution: Verify vault credentials
ansible-vault view group_vars/all/vault.yml

# Issue: Permission denied
# Solution: Check user permissions on device
ansible juniper -m junipernetworks.junos.junos_command -a "commands='show system users'" --ask-vault-pass
```

#### **Module Errors**
```bash
# Issue: Module not found
# Solution: Update collections
ansible-galaxy collection list | grep juniper
ansible-galaxy collection install junipernetworks.junos --upgrade

# Issue: Deprecated module warnings
# Solution: Use updated playbooks with FQCN module names
```

### Debug Mode
```bash
# Enable verbose output
ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass -v

# Enable debug output
ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass -vvv

# Enable connection debugging
ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass -vvvv
```

## 📊 Monitoring and Logging

### Log Files
- **Ansible logs**: Check `ansible.log` (if configured)
- **Configuration backups**: Stored in `backups/` directory
- **Facts output**: Saved as `facts_<hostname>.json`

### Monitoring Commands
```bash
# Check last execution results
ansible juniper -m setup --ask-vault-pass

# Monitor configuration drift
ansible-playbook playbook-Configure-updated.yml --ask-vault-pass --check --diff

# Generate inventory report
ansible-inventory --list --yaml > inventory-report.yml
```

## 🔒 Security Best Practices

1. **✅ Use Ansible Vault** for all credentials
2. **✅ Enable SSH key authentication** instead of passwords
3. **✅ Limit user permissions** to required access only
4. **✅ Regular credential rotation**
5. **✅ Network segmentation** for management traffic
6. **✅ Configuration backups** before changes
7. **✅ Change logging** and audit trails

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Coding Standards
- Follow Ansible best practices
- Use FQCN for all modules
- Include error handling
- Document all variables
- Test with `--check` mode

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

### Documentation
- [Ansible Documentation](https://docs.ansible.com/)
- [Juniper Ansible Collection](https://galaxy.ansible.com/junipernetworks/junos)
- [Network Automation Guide](https://docs.ansible.com/ansible/latest/network/)

### Community
- [Ansible Network Community](https://github.com/ansible-collections/community.network)
- [Juniper Automation Forums](https://forums.juniper.net/)

---

## 📈 Roadmap

- [ ] **Multi-vendor support** (Cisco, Arista)
- [ ] **CI/CD pipeline integration**
- [ ] **Ansible Tower/AWX templates**
- [ ] **Network testing automation**
- [ ] **Compliance checking**
- [ ] **Performance monitoring integration**

---

**Last Updated**: January 2026
**Version**: 2.0 (Modernized)
**Maintainer**: Network Automation Team

> 🚀 **Ready to automate your network?** Start with the Quick Start guide above!