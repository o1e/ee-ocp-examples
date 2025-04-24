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
	@echo "Variants: (e.g.  make rocky9)"; for ee in $(EE_SUFFIXES); do echo "  - $$ee"; done
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
	@echo "  make rocky9"
	@echo "  make IMAGE=my-ee rocky9"
	@echo "  make rocky9 BUILDER_OPTS='-v3 --prune-images --pull'"
	@echo "  make IMAGE=my-ee rocky9 BUILDER_OPTS='--pull --no-cache'"j
	@echo "  make rocky9 # basic build"
	@echo "  make rocky9 BUILDER_OPTS='--prune-images --pull'"

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
