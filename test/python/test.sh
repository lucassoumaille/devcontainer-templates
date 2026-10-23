#!/bin/bash
cd "$(dirname "$0")"

source test-utils.sh

check "python" python --version
check "pytest" pytest --version
check "ruff" ruff --version
check "mypy" mypy --version
check "node" node --version
check "claude" claude --version
check "opencode" bash -c "command -v opencode"
check "CLAUDE_CONFIG_DIR is set" test -n "${CLAUDE_CONFIG_DIR}"
check "Claude config dir is writable" bash -c 'touch "${CLAUDE_CONFIG_DIR}/.write-test" && rm "${CLAUDE_CONFIG_DIR}/.write-test"'
check "shared Claude settings installed" test -f /etc/claude-code/managed-settings.d/ai-tools.json
check "agent harness copied" test -f ../AGENTS.md

reportResults
