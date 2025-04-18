
Example repo for lean **Ansible Execution Environments**  
(based on either Red Hat UBI/RHEL or the official Python image).

## Initial setup

### Debian / Ubuntu
#### create a virtual environment
 ```bash
python3 -m venv .venv
source .venv/bin/activate
```
#### install podman & ansible-builder
```bash
sudo apt-get install -y podman
pip install --upgrade pip
pip install ansible-builder
#pip install ansible-navigator
```

### RHEL / Fedora
#### install podman & ansible-builder
```bash
sudo dnf install -y podman ansible-builder
```

## Quick start

 ```bash
Usage  : make <target>

Targets:
  help         show all targets and usage examples
  default      build EE from execution-environment.yml
  list         list available variants
  clean        remove ansible-builder context directory
  mrproper     clean + remove local images for this project

Build   : make <variant>          (e.g.  make py-3.12)
Set image: make IMAGE=my-ee <var>  (e.g.  make IMAGE=test py-3.12)
```

## Layout
```
.
├── Makefile                     – build targets
├── execution-environment.yml.*  – EE variants (py‑39, py3.12, rh‑…)
├── requirements.{yml,txt}       – Galaxy & pip dependencies
├── bindep.txt                   – system packages (dpkg / rpm)
└── include/sw-dl.sh             – oc, kubectl, helm …
```

## Custom dependencies
1) Python packages   →  requirements.txt  
2) Ansible collections →  requirements.yml  
3) System packages   →  bindep.txt (dpkg / rpm)  
4) Extra binaries    →  include/sw-dl.sh  

Then run `make <variant>` again.

