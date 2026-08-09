SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help check check-user check-root deploy deploy-user deploy-root deploy-dry-run snapshot

help:
	@printf '%s\n' \
	  'make check           Validate the complete deployment flow without writing files.' \
	  'make deploy          Deploy non-root helpers and launcher files.' \
	  'sudo make deploy-root Deploy root-owned SDDM files.' \
	  'make deploy-dry-run  Show non-root deployment changes without writing files.' \
	  'make snapshot        Create Btrfs safety snapshots (interactive sudo prompts expected).'

check: check-user check-root

check-user:
	./helpers/deploy.sh --check
	./omadora-launcher/deploy.sh --check

check-root:
	./scripts/deploy-root.sh --check

deploy: deploy-user
	@printf '%s\n' 'Non-root deployment complete. Run "sudo make deploy-root" for root-owned SDDM files.'

deploy-user:
	./helpers/deploy.sh
	./omadora-launcher/deploy.sh

deploy-root:
	@if [[ $$(id -u) -ne 0 ]]; then echo 'Run this target as: sudo make deploy-root' >&2; exit 1; fi
	./scripts/deploy-root.sh

deploy-dry-run:
	./helpers/deploy.sh --dry-run
	./omadora-launcher/deploy.sh --dry-run

snapshot:
	./scripts/create-btrfs-snapshot.sh
