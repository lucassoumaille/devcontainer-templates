#!/usr/bin/env bash
set -Eeuo pipefail

# Migrations are append-only: a migration that exists on the base branch has already been
# (or will be) applied to staging and prod, so editing it changes nothing remotely and makes
# local and remote schemas drift. New migrations must also sort after every base migration,
# otherwise `supabase db push` refuses them.
#
# Base branch: $MIGRATIONS_BASE_REF or origin/main. Compares the working tree, so uncommitted
# edits are caught too.

cd "$(dirname "$0")/.."

base_ref="${MIGRATIONS_BASE_REF:-origin/main}"
dir="supabase/migrations"

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "SKIP: migrations check (not a git repository)"
  exit 0
fi
if ! git rev-parse --verify --quiet "${base_ref}^{commit}" > /dev/null; then
  echo "SKIP: migrations check (${base_ref} not found; run git fetch)"
  exit 0
fi

merge_base="$(git merge-base "${base_ref}" HEAD)"
failed=0

changed="$(git diff --name-status --no-renames --diff-filter=DMT "${merge_base}" -- "${dir}")"
if [[ -n "${changed}" ]]; then
  echo "FAIL: migrations already on ${base_ref} were modified or deleted:"
  echo "${changed}" | sed 's/^/  /'
  echo "  Restore them (git checkout ${base_ref} -- <file>) and add a new migration instead: make new name=..."
  failed=1
fi

latest_base="$(git ls-tree --name-only "${base_ref}" "${dir}/" | sed 's#.*/##' | grep -oE '^[0-9]+' | sort | tail -n 1 || true)"
if [[ -n "${latest_base}" ]]; then
  while IFS= read -r file; do
    [[ -n "${file}" ]] || continue
    version="$(basename "${file}" | grep -oE '^[0-9]+' || true)"
    if [[ -z "${version}" ]]; then
      echo "FAIL: ${file} has no timestamp prefix"
      failed=1
    elif [[ "${version}" < "${latest_base}" || "${version}" == "${latest_base}" ]]; then
      echo "FAIL: ${file} is older than the latest migration on ${base_ref} (${latest_base})."
      echo "  Recreate it with a new timestamp: make new name=..."
      failed=1
    fi
  done < <(
    git diff --name-only --diff-filter=A "${merge_base}" -- "${dir}/*.sql"
    git ls-files --others --exclude-standard -- "${dir}/*.sql"
  )
fi

if (( failed )); then
  exit 1
fi
echo "OK: migrations are append-only relative to ${base_ref}"
