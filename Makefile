PRE_COMMIT_TERRAFORM_VERSION=latest
MODULES := $(shell find . -type f -name "*.hcl" -exec dirname {} \; | sed 's/^\.\///' | sort)
OSNAME := $(shell uname -s)

all: lint

lint:
    @docker run -v ${PWD}:/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:${PRE_COMMIT_TERRAFORM_VERSION} run -a || (git add . && git commit -m "Apply pre-commit hook changes" && false)

install: install_precommit

install_precommit:
	@echo "[install_precommit]: Installing pre-commit-terraform..."
	@pip install pre-commit
	@docker pull ghcr.io/antonbabenko/pre-commit-terraform:${PRE_COMMIT_TERRAFORM_VERSION}


# .PHONY: update-readme
# update-readme:
# 	@echo "Updating README.md..."
# 	@if [ "$(OSNAME)" = "Darwin" ] || [ "$(OSNAME)" = "darwin" ]; then \
# 		sed -i '' '/^## Modules Catalog$$/,$$d' README.md; \
# 	else \
# 		sed -i '/^## Modules Catalog$$/,$$d' README.md; \
# 	fi
# 	@echo "## Modules Catalog" >> README.md
# 	@echo "| Module Name | Module URL |" >> README.md
# 	@echo "| ----------- | ---------- |" >> README.md
# 	@for module in $(MODULES); do \
# 		module_name=$$(echo $$module | tr / -); \
# 		module_url=$$(echo "https://github.com/kwatatshey/labs-terraform-modules/tree/main/$$module"); \
# 		echo "| $$module_name | $$module_url |" >> README.md; \
# 	done
# 	@echo "README.md updated with module list."
