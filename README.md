# ee-ocp-examples

Opinionated Ansible Execution Environment (EE) examples for OpenShift, Kubernetes and libvirt-heavy automation workflows.

This repository contains several ready-to-build EE definitions based on `ansible-builder`.  
The primary and most actively maintained variant is **`stable/default`**.

---

## Overview

These Execution Environments are designed for real-world automation use cases, especially:

- OpenShift lifecycle automation (install/configure/integrate)
- Kubernetes administration workflows
- libvirt/KVM automation
- enterprise environments (Kerberos, LDAP, etc.)
- workstation + CI usage with Podman/ansible-navigator

They intentionally include commonly used CLI tooling (`oc`, `kubectl`, `helm`, etc.) to reduce friction in daily workflows.

---

## Repository Structure

| Path            | Description |
|----------------|-------------|
| stable/default | Main EE (Debian-based), recommended for daily use |
| variants/rpm   | RPM-based distributions (RHEL, AlmaLinux, Rocky Linux, UBI, Fedora) |
| variants/python| Python-version-focused variants |

If unsure, start with **stable/default**.

---

## Requirements

- podman (recommended) or docker  
- ansible-builder (>= 3.x)  
- make  

---

## Installing ansible-builder

Required for building Execution Environments locally.

If not already installed, install `ansible-builder` using pip:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install ansible-builder
```

Alternatively (system-wide):

```bash
pip install --user ansible-builder
```

---

## Quick Start (Recommended: stable-default)

### Build

```bash
cd stable/default
make build
```

---

## Design Philosophy

These EEs are intentionally opinionated:

- include common tooling used in OpenShift/Kubernetes automation  
- optimized for real workflows rather than minimal image size  
- designed for workstation and CI usage  
- built to work well with `ansible-navigator`

---

## Building Other Variants

Each directory contains its own Makefile:

```bash
cd variants/rpm
make help
```

Refer to the variant-specific README files for details.

---

## Known Limitations

- primarily tested on Debian-based workstations using Podman  
- variants/python is the most actively maintained variant  
- RHEL/CentOS variants may require repo adjustments depending on environment  
- containerized automation may require SSH/kubeconfig mounting depending on workflow  

---

## Contributing

Contributions are welcome. Please open an issue or PR if you want to:

- improve image structure  
- update tooling versions  
- add additional variants  
- improve documentation  

---

## License

MIT License
