# Makefile for dnsmgr - Lightweight Domain Manager
# -----------------------------------------------------------------------------

# Color definitions
BOLD := \033[1m
RESET := \033[0m
GREEN := \033[0;32m
YELLOW := \033[1;33m
CYAN := \033[0;36m
MAGENTA := \033[0;35m
BLUE := \033[0;34m
DIM := \033[2m

# Configuration
BINARY_NAME := dnsmgr
INSTALL_PATH := /usr/local/bin
SOURCE := dnsmgr

# Default target
.DEFAULT_GOAL := help

.PHONY: help
help: ## Display this help message
	@echo ""
	@echo "$(BOLD)$(CYAN)dnsmgr - Lightweight Domain Manager$(RESET)"
	@echo "$(DIM)────────────────────────────────────────────────────────────────$(RESET)"
	@echo ""
	@echo "$(BOLD)Usage:$(RESET)"
	@echo "  make $(YELLOW)<target>$(RESET)"
	@echo ""
	@echo "$(BOLD)Available targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(DIM)────────────────────────────────────────────────────────────────$(RESET)"
	@echo ""

.PHONY: install
install: ## Install dnsmgr to /usr/local/bin (requires sudo)
	@echo "$(YELLOW)Installing $(BINARY_NAME) to $(INSTALL_PATH)...$(RESET)"
	@if [ ! -f "$(SOURCE)" ]; then \
		echo "$(BOLD)Error:$(RESET) $(SOURCE) not found!"; \
		exit 1; \
	fi
	@sudo cp $(SOURCE) $(INSTALL_PATH)/$(BINARY_NAME)
	@sudo chmod +x $(INSTALL_PATH)/$(BINARY_NAME)
	@echo "$(GREEN)✓ Successfully installed $(BINARY_NAME) to $(INSTALL_PATH)/$(BINARY_NAME)$(RESET)"
	@echo "$(DIM)  Run '$(BINARY_NAME) --help' to get started$(RESET)"

.PHONY: uninstall
uninstall: ## Uninstall dnsmgr from /usr/local/bin (requires sudo)
	@echo "$(YELLOW)Uninstalling $(BINARY_NAME) from $(INSTALL_PATH)...$(RESET)"
	@if [ -f "$(INSTALL_PATH)/$(BINARY_NAME)" ]; then \
		sudo rm -f $(INSTALL_PATH)/$(BINARY_NAME); \
		echo "$(GREEN)✓ Successfully uninstalled $(BINARY_NAME)$(RESET)"; \
	else \
		echo "$(DIM)  $(BINARY_NAME) is not installed$(RESET)"; \
	fi

.PHONY: check
check: ## Check if dnsmgr is installed and display version info
	@if [ -f "$(INSTALL_PATH)/$(BINARY_NAME)" ]; then \
		echo "$(GREEN)✓ $(BINARY_NAME) is installed at $(INSTALL_PATH)/$(BINARY_NAME)$(RESET)"; \
		ls -lh $(INSTALL_PATH)/$(BINARY_NAME) | awk '{printf "$(DIM)  Size: %s, Modified: %s %s %s$(RESET)\n", $$5, $$6, $$7, $$8}'; \
	else \
		echo "$(YELLOW)✗ $(BINARY_NAME) is not installed$(RESET)"; \
		echo "$(DIM)  Run 'make install' to install it$(RESET)"; \
		exit 1; \
	fi

.PHONY: clean
clean: ## Clean up backup and temporary files
	@echo "$(YELLOW)Cleaning up temporary files...$(RESET)"
	@rm -f ~/.dnsmgr_coredns_backup.yaml
	@rm -f /tmp/dnsmgr_check
	@echo "$(GREEN)✓ Cleanup complete$(RESET)"

.PHONY: clean-all
clean-all: clean ## Clean up all dnsmgr files including state (WARNING: removes all managed domains!)
	@echo "$(YELLOW)WARNING: This will remove all managed domains!$(RESET)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -f ~/.dnsmgr_state; \
		echo "$(GREEN)✓ State file removed$(RESET)"; \
	else \
		echo "$(DIM)  Cancelled$(RESET)"; \
	fi

.PHONY: test-install
test-install: ## Test the installation by running dnsmgr --help
	@echo "$(YELLOW)Testing installation...$(RESET)"
	@if command -v $(BINARY_NAME) >/dev/null 2>&1; then \
		echo "$(GREEN)✓ $(BINARY_NAME) is in PATH$(RESET)"; \
		echo ""; \
		$(BINARY_NAME) --help; \
	else \
		echo "$(YELLOW)✗ $(BINARY_NAME) not found in PATH$(RESET)"; \
		echo "$(DIM)  Try running 'make install' first$(RESET)"; \
		exit 1; \
	fi

.PHONY: validate
validate: ## Validate the dnsmgr script syntax
	@echo "$(YELLOW)Validating script syntax...$(RESET)"
	@if bash -n $(SOURCE) 2>/dev/null; then \
		echo "$(GREEN)✓ Script syntax is valid$(RESET)"; \
	else \
		echo "$(BOLD)✗ Script syntax errors detected$(RESET)"; \
		exit 1; \
	fi

.PHONY: info
info: ## Display information about the project
	@echo ""
	@echo "$(BOLD)$(MAGENTA)dnsmgr - Project Information$(RESET)"
	@echo "$(DIM)────────────────────────────────────────────────────────────────$(RESET)"
	@echo "$(BOLD)Binary Name:$(RESET)     $(BINARY_NAME)"
	@echo "$(BOLD)Install Path:$(RESET)    $(INSTALL_PATH)"
	@echo "$(BOLD)Source File:$(RESET)     $(SOURCE)"
	@echo "$(BOLD)State File:$(RESET)      ~/.dnsmgr_state"
	@echo "$(BOLD)Backup File:$(RESET)     ~/.dnsmgr_coredns_backup.yaml"
	@echo "$(DIM)────────────────────────────────────────────────────────────────$(RESET)"
	@if [ -f "$(SOURCE)" ]; then \
		echo "$(BOLD)Script Size:$(RESET)     $$(du -h $(SOURCE) | cut -f1)"; \
		echo "$(BOLD)Script Lines:$(RESET)    $$(wc -l < $(SOURCE)) lines"; \
	fi
	@if [ -f "~/.dnsmgr_state" ]; then \
		echo "$(BOLD)Managed Domains:$(RESET) $$(wc -l < ~/.dnsmgr_state 2>/dev/null || echo 0)"; \
	fi
	@echo ""
