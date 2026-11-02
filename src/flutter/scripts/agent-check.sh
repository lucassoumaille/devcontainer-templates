#!/usr/bin/env bash
set -Eeuo pipefail

# Run checks that are available/configured in this project.
# This script intentionally does not install tools or modify dependencies.
# Set INTEGRATION_DEVICE (e.g. linux, or an id from `flutter devices`) to also run integration tests.

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

no_tracked_signing_keys() {
  local tracked
  tracked="$(git ls-files 'android/key.properties' '*.jks' '*.keystore')"
  [[ -z "${tracked}" ]] || { echo "${tracked}"; return 1; }
}

if [[ -f pubspec.yaml ]] && command -v flutter >/dev/null 2>&1; then
  dart_dirs=()
  for dir in lib test integration_test; do
    [[ -d "${dir}" ]] && dart_dirs+=("${dir}")
  done
  run_check "dart format" dart format --output=none --set-exit-if-changed "${dart_dirs[@]}"
  run_check "flutter analyze" flutter analyze
  if [[ -d test ]]; then
    run_check "flutter test" flutter test
  else
    echo "SKIP: flutter test (no test/ directory)"
  fi
  if [[ -n "${INTEGRATION_DEVICE:-}" && -d integration_test ]]; then
    run_check "integration tests on ${INTEGRATION_DEVICE}" flutter test integration_test -d "${INTEGRATION_DEVICE}"
  else
    echo "SKIP: integration tests (set INTEGRATION_DEVICE to run them on a device)"
  fi
else
  echo "SKIP: Flutter checks (no pubspec.yaml or flutter executable)"
fi

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  run_check "No signing keys tracked by git" no_tracked_signing_keys
else
  echo "SKIP: tracked signing keys (not a git repository)"
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
