# --------------------------------------------------------------------
IMAGE ?= ee-ocp4
TAG_LATEST := $(IMAGE):latest

EE_BASE      := execution-environment.yml
EE_FILES     := $(wildcard execution-environment.yml.*)
EE_SUFFIXES  := $(patsubst execution-environment.yml.%,%,$(EE_FILES))

.PHONY: help default list clean mrproper $(EE_SUFFIXES)

# --------------------------------------------------------------------
help: ## show all targets and usage examples
	@awk 'BEGIN{FS=":.*## "; \
	            print "\nUsage  : make <target>\n"; \
	            print "Targets:"} \
	     /^[a-zA-Z0-9_-]+:.*## /{printf "  %-12s %s\n", $$1, $$2}' \
	     $(MAKEFILE_LIST); \
	echo ""; \
	echo "Build   : make <variant>          (e.g.  make py-3.12)"; \
	echo "Set image: make IMAGE=my-ee <var>  (e.g.  make IMAGE=test py-3.12)"

# --------------------------------------------------------------------
default: ## build EE from execution-environment.yml
	ansible-builder build --tag $(TAG_LATEST) -f $(EE_BASE)

$(EE_SUFFIXES): ## build EE variant <suffix>
	ansible-builder build --tag $(IMAGE):$@ -f execution-environment.yml.$@

list: ## list available variants
	@echo "Variants:"; for ee in $(EE_SUFFIXES); do echo "  - $$ee"; done

clean: ## remove ansible-builder context directory
	rm -rf context/

mrproper: clean ## clean + remove local images for this project
	-@podman images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | \
	  awk '/^localhost\/?$(IMAGE):/ {print $$2}' | \
	  xargs -r podman rmi -f
