# Small Python 3.12 Execution Environment Test

This variant is a smaller test build based on `python:3.12-slim-bookworm`.
It keeps OpenShift/Kubernetes and libvirt/KVM provisioning support, but marks
compiler and development headers as build-only dependencies via the `compile`
bindep profile.

The final image is expected to keep two Python runtimes when `virt-install` is
installed:

- `/usr/local/bin/python3` from the Python 3.12 base image for Ansible and pip
- `/usr/bin/python3` from Debian for distro Python tools such as `virt-install`

Do not replace `/usr/bin/python3` with `/usr/local/bin/python3`; Debian tools
may depend on the distro interpreter and modules.

## Build

```sh
make build
```

This builds:

```text
ee-ocp:py-3.12-small
```

## Smoke Test

```sh
make smoke
```

## Size-Oriented Choices

- `*-dev`, compiler, and build-chain packages are marked `[compile ...]`.
- Runtime libvirt/KVM tools remain in the final image.
- `ansible-lint`, `podman`, `skopeo`, and VMware dependencies are not included.
- External CLIs (`oc`, `kubectl`, `helm`, `tkn`) are still installed via the
  shared `include/sw_dl.sh` helper.
