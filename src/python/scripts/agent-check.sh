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

if [[ -f pyproject.toml ]] && command -v pytest >/dev/null 2>&1; then
  run_check "pytest" pytest
else
  echo "SKIP: pytest (no pyproject.toml or pytest executable)"
fi

if command -v ruff >/dev/null 2>&1; then
  run_check "Ruff lint" ruff check .
else
  echo "SKIP: Ruff (not installed)"
fi

if command -v mypy >/dev/null 2>&1 && { [[ -f mypy.ini ]] || grep -qs '^\[tool\.mypy\]' pyproject.toml; }; then
  run_check "mypy" mypy .
else
  echo "SKIP: mypy (not installed or not configured)"
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
