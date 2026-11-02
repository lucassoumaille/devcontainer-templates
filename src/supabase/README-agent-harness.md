# Supabase Agent Harness

This template provides concise instructions and optional Claude Code rules for Supabase projects managed through versioned SQL migrations.

## Included
- `AGENTS.md`: shared instructions for compatible coding agents.
- `CLAUDE.md`: Claude Code entry point, imports `AGENTS.md`.
- `.claude/rules/migrations.md`: writing append-only, safe migrations.
- `.claude/rules/rls-security.md`: RLS, grants, security definer functions, storage policies.
- `.claude/rules/testing.md`: pgTAP tests per role.
- `.claude/rules/edge-functions.md`: Deno Edge Functions.
- `Makefile`: one target per Supabase CLI command, shared by the dev container, the git hook and CI.
- `scripts/agent-check.sh`: CLI version vs CI, `make check`, `deno fmt/lint`, Gitleaks.

Language-agnostic configuration (permission deny rules, security instructions, `quick-review` and `security-audit` skills) comes from the `ai-tools` feature, not from this template.

## Why a Makefile
`make <target>` is discoverable (`make help`), available on CI runners without installation, and keeps each command to one line of CLI so local, hook and CI runs are identical. Logic longer than a line (remote deploy confirmation, migration immutability) lives in `scripts/`.

## Checks
From a generated project root:

```bash
./scripts/agent-check.sh
```
