#!/usr/bin/env bash
set -Eeuo pipefail

# Printed on every container start. Supabase is not started automatically (about a minute).

cd "$(dirname "$0")/.."

cat <<'EOF'

Supabase dev container. Start the local stack with: make up

EOF
make --no-print-directory help
cat <<'EOF'

Local URLs once started: API http://localhost:54321 · Studio http://localhost:54323
Mailpit (auth e-mails) http://localhost:54324 · Postgres postgresql://postgres:postgres@localhost:54322/postgres

EOF
