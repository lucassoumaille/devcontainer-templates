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

# The CLI version of the container must match the one CI uses.
cli_version_matches_ci() {
  local local_version ci_versions
  local_version="$(supabase --version)"
  ci_versions="$(grep -hoE 'SUPABASE_CLI_VERSION: "?[0-9.]+' .github/workflows/*.yml | grep -oE '[0-9.]+$' | sort -u)"
  echo "container: ${local_version}; CI: ${ci_versions//$'\n'/, }"
  [[ "${ci_versions}" == "${local_version}" ]]
}

if command -v supabase > /dev/null 2>&1 && compgen -G ".github/workflows/*.yml" > /dev/null; then
  run_check "Supabase CLI version matches CI" cli_version_matches_ci
fi

if [[ -f supabase/config.toml ]] && command -v supabase > /dev/null 2>&1; then
  if docker info > /dev/null 2>&1; then
    run_check "make check (migrations, reset, lint, advisors, pgTAP)" make check
  else
    run_check "migrations append-only" make migrations-check
    echo "SKIP: reset, lint, advisors, pgTAP (Docker is not running)"
  fi
else
  echo "SKIP: database checks (no supabase/config.toml or supabase executable)"
fi

if [[ -d supabase/functions ]] && command -v deno > /dev/null 2>&1 \
  && [[ -n "$(find supabase/functions -name '*.ts' -print -quit)" ]]; then
  run_check "deno fmt" deno fmt --check supabase/functions
  run_check "deno lint" deno lint supabase/functions
else
  echo "SKIP: Edge Functions checks (no supabase/functions/*.ts or deno executable)"
fi

if command -v gitleaks > /dev/null 2>&1; then
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
