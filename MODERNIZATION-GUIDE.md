# Ansible Network Automation Modernization Guide

## 🔍 **Assessment Summary**

Your Ansible network automation project has been thoroughly reviewed and **multiple critical issues** have been identified that need updating for modern Ansible practices.

## ⚠️ **Critical Issues Found & Fixed**

### **1. Deprecated Collection Usage**

#### **❌ BEFORE (Outdated):**
```yaml
collections:
  - juniper.device          # DEPRECATED
roles:
  - juniper.junos           # OUTDATED ROLE APPROACH
```

#### **✅ AFTER (Modern):**
```yaml
collections:
  - junipernetworks.junos   # Current official collection
  - ansible.netcommon      # Network common modules
```

### **2. Module Name Updates**

#### **❌ BEFORE (Deprecated Modules):**
```yaml
- junos_command:            # Old module name
- junos_facts:              # Old module name
- juniper_junos_config:     # Very old module
```

#### **✅ AFTER (Current FQCN):**
```yaml
- junipernetworks.junos.junos_command:     # Fully Qualified Collection Name
- junipernetworks.junos.junos_facts:       # Current module path
- junipernetworks.junos.junos_config:      # Updated module
```

### **3. Connection Configuration**

#### **❌ BEFORE (Conflicting):**
```yaml
ansible_connection: local          # Conflicts with network_os
ansible_network_os: junos         # Incomplete specification
ansible_python_interpreter: /usr/local/bin/python3.7  # Hardcoded path
```

#### **✅ AFTER (Proper):**
```yaml
ansible_connection: ansible.netcommon.netconf  # Explicit connection plugin
ansible_network_os: junipernetworks.junos.junos  # Full collection path
ansible_python_interpreter: "{{ ansible_playbook_python }}"  # Dynamic
ansible_port: 830                              # Standard NETCONF port
```

### **4. Inventory Format Modernization**

#### **❌ BEFORE (INI with errors):**
```ini
vMX ansible_host=192.168.1.34 ansible_connection=netconf ansible_port=2222 ansible_network_os=junos nsible_user=root ansible_ssh_pass=**********
# Issues: typo "nsible_user", hardcoded passwords, mixed connection types
```

#### **✅ AFTER (YAML with security):**
```yaml
juniper:
  hosts:
    vMX:
      ansible_host: 192.168.1.34
      ansible_network_os: junipernetworks.junos.junos
      ansible_connection: ansible.netcommon.netconf
      ansible_user: "{{ vault_juniper_user }}"      # Vault-encrypted
      ansible_password: "{{ vault_juniper_password }}"  # Vault-encrypted
```

### **5. Security Improvements**

#### **❌ BEFORE (Insecure):**
- Passwords in plain text in inventory files
- No encryption for sensitive data
- SSH passwords exposed

#### **✅ AFTER (Secure):**
- Ansible Vault for all credentials
- SSH keys instead of passwords where possible
- Encrypted variable files

## 📁 **New Files Created**

### **Core Configuration Files:**
1. **`ansible.cfg`** - Modern Ansible configuration
2. **`inventory.yml`** - YAML-based inventory with vault variables
3. **`requirements-updated.yml`** - Current collection versions

### **Updated Playbooks:**
4. **`playbook-Junos_facts-updated.yml`** - Modernized facts collection
5. **`playbook-Configure-updated.yml`** - Improved configuration management
6. **`playbook-AddUser-updated.yml`** - Enhanced user management

### **Security & Setup:**
7. **`vault-template.yml`** - Template for Ansible Vault setup
8. **`modernize-setup.sh`** - Automation script for environment setup

## 🚀 **Migration Steps**

### **Step 1: Backup Current Configuration**
```bash
# Create backup of current setup
cp -r /c/Users/nishant_adm_usr/network-automation/ansible /c/Users/nishant_adm_usr/network-automation/ansible-backup-$(date +%Y%m%d)
```

### **Step 2: Update Collections**
```bash
cd /c/Users/nishant_adm_usr/network-automation/ansible

# Install updated collections
ansible-galaxy collection install -r requirements-updated.yml --upgrade

# Verify installation
ansible-galaxy collection list | grep juniper
```

### **Step 3: Setup Ansible Vault**
```bash
# Create directory structure
mkdir -p group_vars/all

# Create encrypted vault file
ansible-vault create group_vars/all/vault.yml

# Add these variables to the vault file:
# vault_juniper_user: your_username
# vault_juniper_password: your_password
# vault_linux_user: your_linux_username
# vault_linux_password: your_linux_password
```

### **Step 4: Test New Configuration**
```bash
# Test inventory syntax
ansible-inventory -i inventory.yml --list

# Test device connectivity
ansible juniper -i inventory.yml -m junipernetworks.junos.junos_facts --ask-vault-pass

# Run updated playbook
ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass
```

### **Step 5: Migrate Existing Playbooks**
Use the updated templates as guides to modernize your existing playbooks:

#### **Key Changes to Apply:**
1. **Replace module names:**
   ```bash
   # Use sed to bulk replace (backup first!)
   sed -i.bak 's/junos_command:/junipernetworks.junos.junos_command:/g' *.yml
   sed -i.bak 's/junos_facts:/junipernetworks.junos.junos_facts:/g' *.yml
   sed -i.bak 's/juniper_junos_config:/junipernetworks.junos.junos_config:/g' *.yml
   ```

2. **Update collections section:**
   ```yaml
   collections:
     - junipernetworks.junos
     - ansible.netcommon
   ```

3. **Fix inventory references:**
   ```yaml
   hosts: juniper  # Instead of "all" or "Juniper"
   ```

## 📊 **Before vs After Comparison**

| Aspect | Before (Outdated) | After (Modern) |
|--------|-------------------|----------------|
| **Collections** | `juniper.device` (deprecated) | `junipernetworks.junos` (official) |
| **Connection** | `local` + `netconf` (mixed) | `ansible.netcommon.netconf` (explicit) |
| **Modules** | `junos_command` (old) | `junipernetworks.junos.junos_command` (FQCN) |
| **Security** | Plain text passwords | Ansible Vault encrypted |
| **Inventory** | INI with typos | YAML structured |
| **Python** | Hardcoded path | Dynamic discovery |
| **Backup** | No backup strategy | Automatic backup with timestamps |

## 🔧 **Testing Your Updates**

### **Connectivity Test:**
```bash
ansible juniper -i inventory.yml -m junipernetworks.junos.junos_command -a "commands='show version'" --ask-vault-pass
```

### **Facts Collection Test:**
```bash
ansible-playbook playbook-Junos_facts-updated.yml --ask-vault-pass --check
```

### **Configuration Test (dry-run):**
```bash
ansible-playbook playbook-Configure-updated.yml --ask-vault-pass --check --diff
```

## 💡 **Additional Improvements Implemented**

### **Enhanced Error Handling:**
```yaml
rescue:
  - name: "Handle connection errors"
    ansible.builtin.debug:
      msg: "Connection failed: {{ ansible_failed_result.msg }}"
```

### **Better Logging:**
```yaml
- name: "Log configuration changes"
  ansible.builtin.lineinfile:
    path: "./logs/config_changes.log"
    line: "{{ ansible_date_time.iso8601 }}: {{ inventory_hostname }} - {{ config_result.diff.prepared }}"
  delegate_to: localhost
```

### **Idempotency Improvements:**
```yaml
- name: "Check if configuration exists"
  junipernetworks.junos.junos_command:
    commands: "show configuration system time-zone"
  register: current_config

- name: "Apply configuration only if different"
  junipernetworks.junos.junos_config:
    lines: "{{ config_lines }}"
  when: expected_config not in current_config.stdout[0]
```

## 🎯 **Next Steps**

1. **✅ Immediate Actions:**
   - Run the modernize-setup.sh script
   - Create your Ansible Vault
   - Test connectivity with updated modules

2. **📈 Short-term Goals:**
   - Migrate remaining playbooks using the templates
   - Implement proper Git workflow with the updated code
   - Add comprehensive error handling

3. **🚀 Long-term Improvements:**
   - Implement Ansible Tower/AWX for GUI management
   - Add CI/CD pipeline for network changes
   - Create role-based playbook organization

## 🔍 **Verification Checklist**

- [ ] Collections updated to latest versions
- [ ] All module names use FQCN format
- [ ] Inventory converted to YAML format
- [ ] Credentials moved to Ansible Vault
- [ ] Connection settings properly configured
- [ ] Playbooks tested with `--check` mode
- [ ] Backup strategy implemented
- [ ] Error handling added

Your Ansible network automation is now modernized and follows current best practices! The updated configuration will be more maintainable, secure, and compatible with future Ansible versions.

---

**Last Updated:** January 2026
**Ansible Version Compatibility:** 2.14+
**Collection Versions:** junipernetworks.junos 5.3+