#!/usr/bin/env bash
set -Eeuo pipefail

# Run checks that are available/configured in this project.
# This script intentionally does not install tools or modify dependencies.

failures=0
ran=0

run_check() {
  local label="$1"
  shift
  echo
  echo "==> ${label}"
  ran=$((ran + 1))
  if "$@"; then
    echo "PASS: ${label}"
  else
    echo "FAIL: ${label}"
    failures=$((failures + 1))
  fi
}

# Third-party addons are not linted or formatted.
gd_files() {
  find . -name '*.gd' -not -path './addons/*' -not -path './.godot/*' "$@"
}

gdformat_check() { gd_files -print0 | xargs -0 gdformat --check; }
gdlint_check() { gd_files -print0 | xargs -0 gdlint; }

# Godot exits 0 on script parse errors, so the import output is scanned instead.
godot_import() {
  local log
  log="$(godot --headless --import --quit 2>&1)" || { echo "${log}"; return 1; }
  echo "${log}"
  ! grep -qE '^(SCRIPT )?ERROR:' <<<"${log}"
}

if [[ -f project.godot ]] && command -v godot >/dev/null 2>&1; then
  run_check "Godot import (scripts and resources load)" godot_import
else
  echo "SKIP: Godot import (no project.godot or godot executable)"
fi

if command -v gdformat >/dev/null 2>&1 && [[ -n "$(gd_files -print -quit)" ]]; then
  run_check "gdformat" gdformat_check
  run_check "gdlint" gdlint_check
else
  echo "SKIP: gdformat/gdlint (not installed or no GDScript files)"
fi

if [[ -f addons/gut/gut_cmdln.gd ]]; then
  run_check "GUT tests" godot --headless -s addons/gut/gut_cmdln.gd -gexit
elif [[ -f addons/gdUnit4/runtest.sh ]]; then
  run_check "gdUnit4 tests" env GODOT_BIN="$(command -v godot)" bash addons/gdUnit4/runtest.sh --headless -a res://tests
else
  echo "SKIP: tests (no GUT or gdUnit4 addon)"
fi

if command -v gitleaks >/dev/null 2>&1; then
  run_check "Gitleaks working-tree scan" gitleaks detect --no-git --source .
else
  echo "SKIP: Gitleaks (not installed)"
fi

echo
echo "Checks executed: ${ran}; failures: ${failures}"
if (( failures > 0 )); then
  exit 1
fi
if (( ran == 0 )); then
  echo "No checks ran. Install/configure the relevant tools and retry."
  exit 2
fi
