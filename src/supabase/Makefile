# Every target wraps a Supabase CLI command so the dev container, the pre-push hook
# and CI run exactly the same thing. Logic that needs more than one line lives in scripts/.

SHELL := /usr/bin/env bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help

SUPABASE ?= supabase
# Containers skipped by `make up`, comma separated (CI skips the ones the database checks do not use).
EXCLUDE ?=
TYPES_TS ?= supabase/functions/_shared/database.types.ts
TYPES_DART ?= lib/supabase/database.types.dart

.PHONY: help up down status reset new diff lint advisors test check migrations-check types types-dart remote-diff remote-push _running

help: ## List the available commands
	@grep -hE '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "} {printf "  make %-14s %s\n", $$1, $$2}'

up: ## Start the local Supabase stack
	$(SUPABASE) start $(if $(EXCLUDE),--exclude $(EXCLUDE))

down: ## Stop the local stack (data is kept)
	$(SUPABASE) stop

status: ## Show local URLs and keys
	$(SUPABASE) status

_running:
	@$(SUPABASE) status > /dev/null 2>&1 || $(MAKE) --no-print-directory up

reset: _running ## Recreate the local database from migrations + seed
	$(SUPABASE) db reset

new: ## Create an empty migration: make new name=add_profiles
	@test -n "$(name)" || { echo "usage: make new name=<snake_case_description>"; exit 2; }
	@# Without a terminal on stdin the CLI waits for SQL to read from it.
	$(SUPABASE) migration new $(name) < /dev/null

diff: _running ## Write the changes made in local Studio to a migration: make diff name=xxx
	@test -n "$(name)" || { echo "usage: make diff name=<snake_case_description>"; exit 2; }
	$(SUPABASE) db diff --local -f $(name)

lint: _running ## plpgsql_check on the local database, fails on warnings
	$(SUPABASE) db lint --local --level warning --fail-on warning

advisors: _running ## Supabase security advisor (missing RLS, exposed auth.users...), fails on warnings
	$(SUPABASE) db advisors --local --type security --level warn --fail-on warn

test: _running ## pgTAP tests in supabase/tests
	$(SUPABASE) test db --local

migrations-check: ## Fail if a migration already on the base branch was edited, deleted or is out of order
	./scripts/check-migrations.sh

check: ## Run before every commit: migrations-check + reset + lint + advisors + test
	$(MAKE) --no-print-directory migrations-check
	$(MAKE) --no-print-directory reset
	$(MAKE) --no-print-directory lint
	$(MAKE) --no-print-directory advisors
	$(MAKE) --no-print-directory test

types: _running ## TypeScript types for Edge Functions ($(TYPES_TS))
	mkdir -p $(dir $(TYPES_TS))
	$(SUPABASE) gen types --lang typescript --local > $(TYPES_TS).tmp || { rm -f $(TYPES_TS).tmp; exit 1; }
	mv $(TYPES_TS).tmp $(TYPES_TS)

types-dart: _running ## Dart types for a Flutter app ($(TYPES_DART), override with TYPES_DART=path)
	@command -v dart > /dev/null || { echo "dart not found: rebuild the container with the installDart option, or run this in the Flutter dev container"; exit 1; }
	mkdir -p $(dir $(TYPES_DART))
	$(SUPABASE) gen types --lang dart --local > $(TYPES_DART).tmp || { rm -f $(TYPES_DART).tmp; exit 1; }
	mv $(TYPES_DART).tmp $(TYPES_DART)

remote-diff: ## Show what `db push` would apply on a remote project, without applying: make remote-diff env=staging
	./scripts/remote.sh diff "$(env)"

remote-push: ## Apply migrations on staging after confirmation (prod only via CI): make remote-push env=staging
	./scripts/remote.sh push "$(env)"
