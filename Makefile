PRE_COMMIT_TERRAFORM_VERSION=latest
MODULES := $(shell find . -type f -name "*.hcl" -exec dirname {} \; | sed 's/^\.\///' | sort)
OSNAME := $(shell uname -s)

all: lint

lint:
	@docker run -v ${PWD}:/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:${PRE_COMMIT_TERRAFORM_VERSION} run -a

install: install_precommit

install_precommit:
	@echo "[install_precommit]: Installing pre-commit-terraform..."
	@pip install pre-commit
	@docker pull ghcr.io/antonbabenko/pre-commit-terraform:${PRE_COMMIT_TERRAFORM_VERSION}

.PHONY: update-readme
update-readme:
    @echo "Updating README.md..."
    @if [ "$(OSNAME)" = "Darwin" ] || [ "$(OSNAME)" = "darwin" ]; then \
        sed -i '' '/^## Modules Catalog$$/,$$d' README.md; \
    else \
        sed -i '/^## Modules Catalog$$/,$$d' README.md; \
    fi
    @echo "## Modules Catalog" >> README.md
    @echo "| Module Name | Module URL | Inputs | Locals | AWS Provider | Remote State | Terraform Source | Include | Dependency |" >> README.md
    @echo "| ----------- | ---------- | ------ | ------ | ------------ | ------------ | ---------------- | ------- | ---------- |" >> README.md
    @for module in $(MODULES); do \
        module_name=$$(echo $$module | tr / -); \
        module_url=$$(echo "https://github.com/kwatatshey/labs-terraform/tree/main/$$module"); \
        inputs=$$(grep -E 'input' $$module/*.hcl | wc -l); \
        locals=$$(grep -E 'locals' $$module/*.hcl | wc -l); \
        aws_provider=$$(grep -E 'aws_provider' $$module/*.hcl | wc -l); \
        remote_state=$$(grep -E 'remote_state' $$module/*.hcl | wc -l); \
        terraform_source=$$(grep -E 'source' $$module/*.hcl | wc -l); \
        include=$$(grep -E 'include' $$module/*.hcl | wc -l); \
        dependency=$$(grep -E 'dependency' $$module/*.hcl | wc -l); \
        echo "| $$module_name | $$module_url | $$inputs | $$locals | $$aws_provider | $$remote_state | $$terraform_source | $$include | $$dependency |" >> README.md; \
    done
    @echo "README.md updated with module list."
