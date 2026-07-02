IMAGE ?= ee-ocp
BUILDER ?= ansible-builder
BUILDER_OPTS ?=
VARIANT ?= py-3.12-small
EE_FILE ?= execution-environment.yml

.PHONY: help build rebuild debug create smoke clean print-vars

help:
	@echo ""
	@echo "Small Python 3.12 EE build helper"
	@echo ""
	@echo "Usage:"
	@echo "  make build"
	@echo "  make rebuild"
	@echo "  make smoke"
	@echo ""
	@echo "Variables:"
	@echo "  IMAGE='$(IMAGE)'"
	@echo "  VARIANT='$(VARIANT)'"
	@echo "  BUILDER='$(BUILDER)'"
	@echo "  BUILDER_OPTS='$(BUILDER_OPTS)'"

build:
	$(BUILDER) build -f $(EE_FILE) -t $(IMAGE):$(VARIANT) $(BUILDER_OPTS)

rebuild:
	$(MAKE) build BUILDER_OPTS="$(BUILDER_OPTS) --no-cache"

debug:
	$(MAKE) build BUILDER_OPTS="$(BUILDER_OPTS) -vvv"

create:
	$(BUILDER) create -f $(EE_FILE)

smoke:
	podman run --rm $(IMAGE):$(VARIANT) python3 -c 'import sys; assert sys.executable == "/usr/local/bin/python3", sys.executable'
	podman run --rm $(IMAGE):$(VARIANT) python3 -c 'import libvirt, kubernetes, openshift'
	podman run --rm $(IMAGE):$(VARIANT) ansible --version
	podman run --rm $(IMAGE):$(VARIANT) virsh --version
	podman run --rm $(IMAGE):$(VARIANT) virt-install --version
	podman run --rm $(IMAGE):$(VARIANT) qemu-img --version

clean:
	rm -rf context

print-vars:
	@echo "IMAGE=$(IMAGE)"
	@echo "VARIANT=$(VARIANT)"
	@echo "BUILDER=$(BUILDER)"
	@echo "BUILDER_OPTS=$(BUILDER_OPTS)"
	@echo "EE_FILE=$(EE_FILE)"
