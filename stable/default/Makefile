IMAGE ?= ee-ocp
TAG ?= latest
EE_FILE ?= execution-environment.yml
BUILDER ?= ansible-builder
BUILDER_OPTS ?=

FULL_IMAGE := $(IMAGE):$(TAG)

.PHONY: help build rebuild create clean print-vars

help:
	@echo "Execution Environment build helper"
	@echo ""
	@echo "Default:"
	@echo "  IMAGE='$(IMAGE)'"
	@echo "  TAG='$(TAG)'"
	@echo "  FULL_IMAGE='$(FULL_IMAGE)'"
	@echo "  EE_FILE='$(EE_FILE)'"
	@echo ""
	@echo "Targets:"
	@echo "  make help           Show this help"
	@echo "  make build          Build $(FULL_IMAGE)"
	@echo "  make rebuild        Build without cache"
	@echo "  make debug          Build with verbose output (-vvv)"
	@echo "  make create         Create build context only"
	@echo "  make clean          Remove local build context"
	@echo "  make print-vars     Show resolved variables"
	@echo ""
	@echo "Variables:"
	@echo "  IMAGE='$(IMAGE)'"
	@echo "  TAG='$(TAG)'"
	@echo "  EE_FILE='$(EE_FILE)'"
	@echo "  BUILDER='$(BUILDER)'"
	@echo "  BUILDER_OPTS='$(BUILDER_OPTS)'"
	@echo ""
	@echo "Examples:"
	@echo "  make build"
	@echo "  make build IMAGE=ee-ocp TAG=dev"
	@echo "  make rebuild BUILDER_OPTS='-v'"
	@echo "  make debug"
	@echo "  make build BUILDER_OPTS='-vvv'"

build:
	$(BUILDER) build -f $(EE_FILE) -t $(FULL_IMAGE) $(BUILDER_OPTS)

debug:
	$(MAKE) build BUILDER_OPTS="$(BUILDER_OPTS) -vvv"

rebuild:
	$(MAKE) build BUILDER_OPTS="$(BUILDER_OPTS) --no-cache"

create:
	$(BUILDER) create -f $(EE_FILE)

clean:
	rm -rf context

print-vars:
	@echo "IMAGE=$(IMAGE)"
	@echo "TAG=$(TAG)"
	@echo "FULL_IMAGE=$(FULL_IMAGE)"
	@echo "EE_FILE=$(EE_FILE)"
	@echo "BUILDER=$(BUILDER)"
	@echo "BUILDER_OPTS=$(BUILDER_OPTS)"
