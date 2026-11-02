@AGENTS.md

## Claude Code
- Migration, RLS, testing and Edge Function rules are in `.claude/rules/`.
- Shared security and approval rules come from the `ai-tools` feature (`/etc/claude-code/CLAUDE.md`).
- Run `./scripts/agent-check.sh` before declaring work complete.
- You may start and stop the local stack (`make up`, `make down`) and reset the local database; never use `supabase stop --no-backup` without asking (it deletes local data).
