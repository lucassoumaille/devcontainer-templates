#!/usr/bin/env bash
set -Eeuo pipefail

# Usage: remote.sh diff|push <env>
# Reads SUPABASE_ACCESS_TOKEN, SUPABASE_PROJECT_ID_<ENV> and SUPABASE_DB_PASSWORD_<ENV> from the
# environment (Codespaces secrets, CI) or from .env. Variables already set are not overridden.
# Production is deployed only by the db-deploy workflow, never from a workstation.

cd "$(dirname "$0")/.."

action="${1:-}"
env_name="${2:-}"

usage() {
  echo "usage: make remote-diff env=staging | make remote-push env=staging" >&2
  exit 2
}

[[ "${action}" == "diff" || "${action}" == "push" ]] || usage
[[ "${env_name}" =~ ^[a-z][a-z0-9_]*$ ]] || usage

case "${env_name}" in
  prod | production)
    echo "Refused: production is deployed only through the db-deploy workflow (manual run with approval)." >&2
    exit 1
    ;;
esac

if [[ -f .env ]]; then
  while IFS='=' read -r key value; do
    [[ "${key}" =~ ^[A-Z_][A-Z0-9_]*$ ]] || continue
    value="${value%\"}"
    value="${value#\"}"
    [[ -n "${!key:-}" ]] || export "${key}=${value}"
  done < .env
fi

suffix="${env_name^^}"
project_var="SUPABASE_PROJECT_ID_${suffix}"
password_var="SUPABASE_DB_PASSWORD_${suffix}"
missing=()
for var in SUPABASE_ACCESS_TOKEN "${project_var}" "${password_var}"; do
  [[ -n "${!var:-}" ]] || missing+=("${var}")
done
if (( ${#missing[@]} > 0 )); then
  echo "Missing: ${missing[*]} (set them in .env or as Codespaces secrets, see .env.example)" >&2
  exit 1
fi

export SUPABASE_ACCESS_TOKEN
# The CLI reads the database password from this variable, which keeps it out of the process list.
export SUPABASE_DB_PASSWORD="${!password_var}"
project_ref="${!project_var}"

echo "==> Linking ${env_name} (${project_ref})"
supabase link --project-ref "${project_ref}"

echo "==> Migrations that would be applied on ${env_name}"
supabase db push --linked --dry-run

if [[ "${action}" == "diff" ]]; then
  exit 0
fi

if [[ ! -t 0 ]]; then
  echo "Refused: remote-push needs an interactive terminal to confirm." >&2
  exit 1
fi
read -r -p "Type '${env_name}' to apply these migrations on ${env_name}: " answer
if [[ "${answer}" != "${env_name}" ]]; then
  echo "Aborted."
  exit 1
fi

supabase db push --linked
