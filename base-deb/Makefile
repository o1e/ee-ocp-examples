# --------------------------------------------------------------------
# Execution Environment build helper
#
# Layout expected:
#   ./execution-environment.yml
#   ./requirements.yml
#   ./requirements.txt
#   ./bindep.txt
#   ./include/
#
# Usage:
#   make                # build IMAGE:latest
#   make build          # same as default
#   make rebuild        # build no-cache
#   make test           # quick sanity check inside container
#   make run            # shell inside container
#   make clean          # remove ansible-builder context
#   make mrproper       # remove images built for IMAGE
# --------------------------------------------------------------------

IMAGE  ?= ee-ocp4
TAG    ?= deb1
EE_DEF ?= execution-environment.yml

ENGINE ?= podman
BUILDER_OPTS ?=
RUN_OPTS ?= --rm -it

TAG_FULL := $(IMAGE):$(TAG)

# ansible-builder writes to ./context by default
CONTEXT_DIR := context

.PHONY: help default build rebuild test run shell clean mrproper show

# --------------------------------------------------------------------
help: ## show all targets
	@awk 'BEGIN{FS=":.*## "; \
	            print "\nUsage  : make <target>\n"; \
	            print "Targets:"} \
	     /^[a-zA-Z0-9_-]+:.*## /{printf "  %-12s %s\n", $$1, $$2}' \
	     $(MAKEFILE_LIST); \
	echo ""; \
	echo "Examples:"; \
	echo "  make IMAGE=ee-ocp-libvirt build"; \
	echo "  make ENGINE=docker rebuild"; \
	echo "  make test"; \
	echo "  make run"

default: build ## build EE (default)

show: ## show resolved settings
	@echo "IMAGE      = $(IMAGE)"
	@echo "TAG        = $(TAG)"
	@echo "TAG_FULL   = $(TAG_FULL)"
	@echo "ENGINE     = $(ENGINE)"
	@echo "EE_DEF     = $(EE_DEF)"
	@echo "BUILDER_OPTS = $(BUILDER_OPTS)"

# --------------------------------------------------------------------
build: ## build EE image (IMAGE:TAG)
	ansible-builder build --tag $(TAG_FULL) -f $(EE_DEF) $(BUILDER_OPTS)

rebuild: ## build EE image without cache
	ansible-builder build --tag $(TAG_FULL) -f $(EE_DEF) --no-cache $(BUILDER_OPTS)

# --------------------------------------------------------------------
run: ## start interactive shell in EE container
	$(ENGINE) run $(RUN_OPTS) $(TAG_FULL) /bin/bash

shell: run ## alias for run

test: ## run basic checks inside EE (python imports + virsh version)
	$(ENGINE) run --rm $(TAG_FULL) /bin/bash -lc '\
	  python3 -c "import lxml, libvirt; print(\"OK: lxml+libvirt import\")" && \
	  (command -v virsh >/dev/null 2>&1 && virsh --version || echo "NOTE: virsh not installed") \
	'

# --------------------------------------------------------------------
clean: ## remove ansible-builder context directory
	rm -rf $(CONTEXT_DIR)/

mrproper: clean ## remove local images for this IMAGE (all tags)
	-@$(ENGINE) images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | \
	  awk '$$1 ~ /^$(IMAGE):/ {print $$2}' | \
	  xargs -r $(ENGINE) rmi -f
