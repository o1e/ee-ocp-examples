IMAGE ?= ee-ocp
BUILDER ?= ansible-builder
BUILDER_OPTS ?=

EE_FILES := $(sort $(wildcard execution-environment.yml.*))
VARIANTS := $(patsubst execution-environment.yml.%,%,$(EE_FILES))

.PHONY: help all build rebuild debug create clean print-vars $(VARIANTS)

help: ## Show help and debugging examples
	@echo ""
	@echo "Execution Environment build helper (RPM variants)"
	@echo ""
	@echo "Usage:"
	@echo "  make <variant>"
	@echo ""
	@echo "Variants:"
	@for v in $(VARIANTS); do echo "  $$v"; done
	@echo ""
	@echo "Additional targets:"
	@echo "  help        Show this help"
	@echo "  all         Build all variants"
	@echo "  build       Build selected variant via VARIANT=<name>"
	@echo "  rebuild     Build selected variant without cache"
	@echo "  debug       Build selected variant with verbose output (-vvv)"
	@echo "  create      Create build context for selected variant only"
	@echo "  print-vars  Show resolved variables"
	@echo "  clean       Remove local build context"
	@echo ""
	@echo "Variables:"
	@echo "  IMAGE='$(IMAGE)'"
	@echo "  BUILDER='$(BUILDER)'"
	@echo "  BUILDER_OPTS='$(BUILDER_OPTS)'"
	@echo ""
	@echo "Examples:"
	@echo "  make centos"
	@echo "  make ubi9"
	@echo "  make rhel9-min"
	@echo "  make build VARIANT=alma9"
	@echo "  make centos BUILDER_OPTS='-vvv'"
	@echo "  make all BUILDER_OPTS='-vvv'"

build: ## Build selected variant via VARIANT=<name>
	@if [ -z "$(VARIANT)" ]; then \
		echo "Error: no VARIANT specified. Use 'make <variant>' or 'make build VARIANT=<name>'."; \
		exit 1; \
	fi
	@if [ ! -f "execution-environment.yml.$(VARIANT)" ]; then \
		echo "Error: execution-environment.yml.$(VARIANT) not found."; \
		exit 1; \
	fi
	$(BUILDER) build -f execution-environment.yml.$(VARIANT) -t $(IMAGE):$(VARIANT) $(BUILDER_OPTS)

rebuild: ## Build selected variant without cache
	@if [ -z "$(VARIANT)" ]; then \
		echo "Error: no VARIANT specified. Use 'make <variant>' or 'make rebuild VARIANT=<name>'."; \
		exit 1; \
	fi
	$(MAKE) build VARIANT=$(VARIANT) BUILDER_OPTS="$(BUILDER_OPTS) --no-cache"

debug: ## Build selected variant with verbose output (-vvv)
	@if [ -z "$(VARIANT)" ]; then \
		echo "Error: no VARIANT specified. Use 'make <variant>' or 'make debug VARIANT=<name>'."; \
		exit 1; \
	fi
	$(MAKE) build VARIANT=$(VARIANT) BUILDER_OPTS="$(BUILDER_OPTS) -vvv"

create: ## Create build context for selected variant only
	@if [ -z "$(VARIANT)" ]; then \
		echo "Error: no VARIANT specified. Use 'make <variant>' or 'make create VARIANT=<name>'."; \
		exit 1; \
	fi
	@if [ ! -f "execution-environment.yml.$(VARIANT)" ]; then \
		echo "Error: execution-environment.yml.$(VARIANT) not found."; \
		exit 1; \
	fi
	$(BUILDER) create -f execution-environment.yml.$(VARIANT)

clean: ## Remove local build context
	rm -rf context

print-vars: ## Show resolved variables
	@echo "IMAGE=$(IMAGE)"
	@echo "VARIANT=$(VARIANT)"
	@echo "BUILDER=$(BUILDER)"
	@echo "BUILDER_OPTS=$(BUILDER_OPTS)"
	@echo "EE_FILES=$(EE_FILES)"
	@echo "VARIANTS=$(VARIANTS)"

all: ## Build all variants
	@for v in $(VARIANTS); do \
		echo ""; \
		echo "==> Building $$v"; \
		$(MAKE) build VARIANT=$$v BUILDER_OPTS="$(BUILDER_OPTS)" || exit $$?; \
	done

$(VARIANTS):
	$(MAKE) build VARIANT=$@ BUILDER_OPTS="$(BUILDER_OPTS)"