# --------------------------------------------------------------------
IMAGE ?= ee-ocp4
TAG_LATEST := $(IMAGE):latest

EE_BASE      := execution-environment.yml
EE_FILES     := $(wildcard execution-environment.yml.*)
EE_SUFFIXES  := $(patsubst execution-environment.yml.%,%,$(EE_FILES))

# any other flags you want to hand to ansible-builder
BUILDER_OPTS ?=

# --------------------------------------------------------------------
.PHONY: help default list clean mrproper $(EE_SUFFIXES)
# --------------------------------------------------------------------
help: ## show all targets and usage examples
	@echo "Usage: make <target> [BUILDER_OPTS='…']"
	@echo
	@echo "Variants: (e.g.  make py-3.12)"; for ee in $(EE_SUFFIXES); do echo "  - $$ee"; done
	@echo
	@echo "Targets:"
	@echo "  default     :build EE from execution-environment.yml"
	@echo "  help        :show all targets and usage examples"
	@echo "  list        :list available variants"
	@echo "  clean       :remove ansible-builder context directory"
	@echo "  mrproper    :clean + remove local images for this project"
	@echo "  " 
	@echo "Examples:"
	@echo "  make list"
	@echo "  make py-3.12"
	@echo "  make IMAGE=my-ee py-3.12"
	@echo "  make py-3.12 BUILDER_OPTS='-v3 --prune-images --pull'"
	@echo "  make IMAGE=my-ee py-3.12 BUILDER_OPTS='--pull --no-cache'"j
	@echo "  make py-3.12 # basic build"
	@echo "  make py-3.12 BUILDER_OPTS='--prune-images --pull'"

# --------------------------------------------------------------------
default: ## build EE from execution-environment.yml
	ansible-builder build --tag $(TAG_LATEST) -f $(EE_BASE) $(BUILDER_OPTS)

$(EE_SUFFIXES): ## build EE variant <suffix>
	ansible-builder build --tag $(IMAGE):$@ -f execution-environment.yml.$@ $(BUILDER_OPTS)

list: ## list available variants
	@echo "Variants:"; for ee in $(EE_SUFFIXES); do echo "  - $$ee"; done

clean: ## remove ansible-builder context directory
	rm -rf context/

mrproper: clean ## clean + remove local images for this project
	-@podman images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | \
	  awk '/^localhost\/?$(IMAGE):/ {print $$2}' | \
	  xargs -r podman rmi -f
