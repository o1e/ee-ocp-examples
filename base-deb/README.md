# Ansible Execution Environments examples (base-deb)

Lean Ansible Execution Environments (EE) for a typical
OpenShift / Kubernetes + KVM / libvirt automation environment

This repository provides a Debian-based EE build setup that bundles
everything commonly required for:

- OpenShift / Kubernetes automation
- KVM / libvirt based VM provisioning
- crypto, SSH, LDAP, Kerberos backed environments
- running Ansible via ansible-navigator (local or CI)

The focus is a single, reproducible base EE, not multiple variants.

---

## What this EE is for

This Execution Environment is intended to be used as a general-purpose
automation EE that covers:

- OpenShift / Kubernetes (oc, kubectl, helm, APIs)
- KVM / libvirt (community.libvirt, virsh, qemu+ssh)
- Enterprise auth environments (Kerberos / LDAP)
- Common automation tooling (rsync, git, jq, sshpass, etc.)

It is not limited to libvirt – libvirt is just one part of the toolchain.

---

## Repository layout

.
├── Makefile
│   └── build / test / run helpers
├── execution-environment.yml
│   └── ansible-builder definition
├── requirements.yml
│   └── Ansible Galaxy collections
├── requirements.txt
│   └── Python (pip) dependencies
├── bindep.txt
│   └── System packages (dpkg / rpm)
├── include/
│   └── sw_dl.sh
│       └── optional: oc / kubectl / helm download helper
└── README.md

---

## Dependency model

All dependencies are declared explicitly and split by layer:

1. Ansible collections  → requirements.yml
2. Python packages      → requirements.txt
3. System packages      → bindep.txt
4. External binaries    → include/sw_dl.sh

This keeps the EE predictable, reproducible and debuggable.

---

## Ansible Galaxy collections (requirements.yml)

This EE is built to support automation around:

- OpenShift / Kubernetes
  - kubernetes.core
  - community.okd
- Linux / networking helpers
  - ansible.posix
  - ansible.utils
  - ansible.netcommon
- General purpose modules
  - community.general
- Crypto / PKI
  - community.crypto
- KVM / libvirt
  - community.libvirt

Optional collections (Vault, VMware, Podman, OCI, etc.) can be enabled
by uncommenting them in requirements.yml.

---

## Python dependencies (requirements.txt)

Python libraries required by Ansible modules and collections, e.g.:

- lxml
- libvirt-python
- crypto / API helpers as required by the project

If Ansible fails with:
"The <module> module is not importable"

add the module here and rebuild the EE.

---

## System dependencies (bindep.txt)

System packages for both dpkg and rpm platforms, including:

- SSH tooling (openssh-client, sshpass)
- Build toolchain and Python headers
- Kerberos libraries and tools
- LDAP development headers
- Common utilities (rsync, git, jq, tar, file, which, dnsutils, etc.)
- KVM / libvirt client and development libraries

This enables:
- building Python extensions during image build
- non-interactive libvirt and SSH usage
- compatibility with enterprise environments

---

## Workstation requirements (all distributions)

Only Podman is required from the operating system.
All other tooling is installed via pip.

### Install Podman

Debian / Ubuntu:
sudo apt-get update
sudo apt-get install -y podman python3 python3-venv

RHEL / Fedora:
sudo dnf install -y podman python3 python3-venv

---

## Python environment (recommended)

Create and activate a virtual environment:

python3 -m venv .venv
source .venv/bin/activate

Install build tooling:

pip install --upgrade pip
pip install ansible-builder ansible-navigator

---

## Building the Execution Environment

Build the default image (ee-ocp4:latest):

make

Rebuild without cache:

make rebuild

Open a shell inside the EE (debugging):

make run

Run basic sanity checks inside the EE:

make test

Change image name:

make IMAGE=ee-ocp4 build

---

## Using the EE with ansible-navigator

Example:

ansible-navigator run site.yml \
  --execution-environment-image ee-ocp4:latest \
  --mode stdout

Important note about delegate_to: localhost

When running inside an EE, delegate_to: localhost means:
- localhost inside the container
- not the workstation

Anything relying on:
- ~/.ssh
- SSH agent
- kubeconfig
- known_hosts

must be made available to the EE (mounts or agent forwarding).

---

## Troubleshooting

Missing Python module:
- add to requirements.txt
- rebuild the EE

Missing system library:
- add to bindep.txt
- rebuild the EE

KVM / libvirt via qemu+ssh:
- the EE acts as the libvirt client
- verify non-interactive access first:

virsh -c qemu+ssh://USER@HOST/system list --all

---

## Scope

This EE is intentionally pragmatic:

- one base image
- explicit dependencies
- reproducible builds
- suitable for workstation and CI usage
