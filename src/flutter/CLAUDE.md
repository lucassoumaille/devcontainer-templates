@AGENTS.md

## Claude Code
- Dart/Flutter, Android, iOS, security, testing, release, and payment rules are in `.claude/rules/`.
- Shared security and approval rules come from the `ai-tools` feature (`/etc/claude-code/CLAUDE.md`).
- Run `./scripts/agent-check.sh` before declaring work complete.
- Do not start the emulator or connect devices yourself. If a device is already listed by `flutter devices`, you may run integration tests on it with `INTEGRATION_DEVICE=<id> ./scripts/agent-check.sh`.
