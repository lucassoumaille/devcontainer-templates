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

has_npm_script() {
  [[ -f package.json ]] && node -e 'process.exit(require("./package.json").scripts?.[process.argv[1]] ? 0 : 1)' "$1"
}

if has_npm_script test; then
  run_check "npm test" npm test
else
  echo "SKIP: npm test (no \"test\" script in package.json)"
fi

if has_npm_script lint; then
  run_check "npm run lint" npm run lint
else
  echo "SKIP: lint (no \"lint\" script in package.json)"
fi

if [[ -f tsconfig.json ]] && [[ -x node_modules/.bin/tsc ]]; then
  run_check "TypeScript type check" node_modules/.bin/tsc --noEmit
else
  echo "SKIP: TypeScript (no tsconfig.json or local typescript dependency)"
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
