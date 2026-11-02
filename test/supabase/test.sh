#!/bin/bash
cd "$(dirname "$0")"

source test-utils.sh

check "supabase" supabase --version
check "psql 17" bash -c 'psql --version | grep -q " 17\."'
check "deno" deno --version
check "make" make --version
check "node" node --version
check "docker daemon (docker-in-docker)" docker info
check "supabase init ran" test -f ../supabase/config.toml
check "make help" make -C .. help
check "make check (start, reset, lint, advisors, pgTAP)" make -C .. check
check "make types" bash -c 'make -C .. types && test -s ../supabase/functions/_shared/database.types.ts'
check "remote-push refuses prod" bash -c '! make -C .. remote-push env=prod'
check "supabase stop" bash -c 'cd .. && supabase stop --no-backup'
check "claude" claude --version
check "opencode" bash -c "command -v opencode"
check "CLAUDE_CONFIG_DIR is set" test -n "${CLAUDE_CONFIG_DIR}"
check "Claude config dir is writable" bash -c 'touch "${CLAUDE_CONFIG_DIR}/.write-test" && rm "${CLAUDE_CONFIG_DIR}/.write-test"'
check "shared Claude settings installed" test -f /etc/claude-code/managed-settings.d/ai-tools.json
check "agent harness copied" test -f ../AGENTS.md

reportResults
