#!/bin/bash
cd "$(dirname "$0")"

source test-utils.sh

TEMPLATES_DIR="${HOME}/.local/share/godot/export_templates"

check "godot" godot --version
check "godot headless" godot --headless --quit
check "gdformat" gdformat --version
check "gdlint" gdlint --version
check "Linux export template" bash -c "ls ${TEMPLATES_DIR}/*.stable/linux_release.x86_64"
check "Windows export template" bash -c "ls ${TEMPLATES_DIR}/*.stable/windows_release_x86_64.exe"
check "node" node --version
check "claude" claude --version
check "opencode" bash -c "command -v opencode"
check "CLAUDE_CONFIG_DIR is set" test -n "${CLAUDE_CONFIG_DIR}"
check "Claude config dir is writable" bash -c 'touch "${CLAUDE_CONFIG_DIR}/.write-test" && rm "${CLAUDE_CONFIG_DIR}/.write-test"'
check "shared Claude settings installed" test -f /etc/claude-code/managed-settings.d/ai-tools.json
check "agent harness copied" test -f ../AGENTS.md

reportResults
