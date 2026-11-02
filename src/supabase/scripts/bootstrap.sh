#!/usr/bin/env bash
set -Eeuo pipefail

# Runs on container creation: creates supabase/config.toml the first time and enables the
# repository git hooks. Does not start Supabase (slow, see `make up`).

cd "$(dirname "$0")/.."

if [[ ! -f supabase/config.toml ]]; then
  echo "==> supabase init"
  supabase init
fi

if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  git config core.hooksPath .githooks
  echo "==> git hooks enabled (.githooks/pre-push)"
else
  echo "Not a git repository yet: after git init, run: git config core.hooksPath .githooks"
fi
