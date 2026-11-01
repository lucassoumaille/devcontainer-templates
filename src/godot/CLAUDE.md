@AGENTS.md

## Claude Code
- GDScript, scene/asset, testing, and HD-2D rendering rules are in `.claude/rules/`.
- Shared security and approval rules come from the `ai-tools` feature (`/etc/claude-code/CLAUDE.md`).
- Run `./scripts/agent-check.sh` before declaring work complete.
- Do not launch the editor (`scripts/godot-editor.sh`) yourself; use `godot --headless` for imports, tests, and exports.
