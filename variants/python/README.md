# Python-based Execution Environment Variants

This directory contains Python-based Ansible Execution Environment (EE) variants built with ansible-builder.

Each variant is defined via:

execution-environment.yml.<variant>

The Makefile automatically detects available variants from these filenames.

---

## Available Variants

Run:

make help

to list all currently available variants.

Examples:

execution-environment.yml.py-3.9  
execution-environment.yml.py-3.10  
execution-environment.yml.py-3.12  

Adding a new file automatically creates a new build target.

---

## Usage

Build a specific variant:

make py-3.12  
make py-3.10  
make py-3.9  

This builds:

ee-ocp:<variant>

Example:

make py-3.12

---

## Build All Variants

make all

Typical use cases:

- CI builds  
- smoke testing  
- compatibility checks across Python versions  

---

## Debugging

Verbose build:

make py-3.12 BUILDER_OPTS="-vvv"

No-cache rebuild:

make py-3.12 BUILD_CLI_OPTS="--extra-build-cli-args='--no-cache'"

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

This keeps builds predictable and avoids accidental mismatches.

---

## System Dependencies

Some variants include Python packages with native extensions (for example libvirt-python).  
These require system build dependencies during the EE build.

For Debian-based images this typically includes:

gcc  
libvirt-dev  
pkg-config  
make  

These are managed via bindep.txt.

These variants intentionally use upstream `python:*` images and
`/usr/local/bin/python3`. They are useful for checking Ansible and collection
behavior against specific Python runtimes.

They are not the recommended images for workflows that execute Python-based
tools installed from the operating-system package manager, such as Debian's
`virt-install`. Those tools often use `#!/usr/bin/env python3`; in a `python:*`
image that resolves to `/usr/local/bin/python3`, while OS Python modules are
installed for `/usr/bin/python3`. Use `stable/default` for libvirt-heavy
automation that needs packaged CLI tools.

---

## Requirements

ansible-builder >= 3  
podman (recommended) or docker  
make
