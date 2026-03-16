# RPM-based Execution Environment Variants

This directory contains RPM-based Ansible Execution Environment (EE) variants built with ansible-builder.

Supported distribution families include:

- RHEL  
- AlmaLinux  
- Rocky Linux  
- UBI  
- Fedora  

Each variant is defined via:

execution-environment.yml.<variant>

The Makefile automatically detects available variants from these filenames.

---

## Available Variants

Run:

make help

to list all currently available variants.

Examples:

execution-environment.yml.alma9  
execution-environment.yml.rocky9  
execution-environment.yml.ubi9  
execution-environment.yml.rhel9-min  
execution-environment.yml.rhel9-sup  
execution-environment.yml.fedora  

Adding a new file automatically creates a new build target.

---

## Usage

Build a specific variant:

make alma9  
make rocky9  
make ubi9  
make rhel9-min  

This builds:

ee-ocp:<variant>

Example:

make alma9

---

## Build All Variants

make all

Typical use cases:

- CI builds  
- smoke testing  
- platform comparison  

---

## Debugging

Verbose build:

make alma9 BUILDER_OPTS="-vvv"

No-cache rebuild:

make alma9 BUILD_CLI_OPTS="--extra-build-cli-args='--no-cache'"

---

## Make Targets Overview

<variant>   Build selected EE variant  
all         Build all variants  
build       Build via VARIANT=<name>  
rebuild     Build without cache  
debug       Build with -vvv  
create      Create build context only  
clean       Remove local build context  
print-vars  Show resolved variables  

---

## Notes

There is intentionally no default variant.

Always build explicitly via:

make <variant>

Not all variants provide identical tooling.
Full libvirt/snobox workflows are typically supported on AlmaLinux or Rocky Linux builds, but not on minimal UBI variants.

---

## System Dependencies

Some variants include Python packages with native extensions (for example libvirt-python).  
These require system build dependencies during the EE build.

Typical RPM-based requirements include:

gcc  
python3-devel  
libvirt-devel  
pkgconf-pkg-config  

Additional runtime tools such as virsh or virt-install are included only in variants where needed.

These dependencies are managed via bindep.txt.

---

## Requirements

ansible-builder >= 3  
podman (recommended) or docker  
make
