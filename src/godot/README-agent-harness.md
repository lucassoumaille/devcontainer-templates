# Godot Agent Harness

This template provides concise instructions and optional Claude Code rules for Godot 4 projects written in GDScript, with HD-2D rendering guidance.

## Included
- `AGENTS.md`: shared instructions for compatible coding agents.
- `CLAUDE.md`: Claude Code entry point, imports `AGENTS.md`.
- `.claude/rules/gdscript.md`: GDScript style, typing, and scene communication.
- `.claude/rules/scenes-and-assets.md`: project layout, editing `.tscn`/`.tres`, generated files, LFS.
- `.claude/rules/testing.md`: headless tests with GUT or gdUnit4.
- `.claude/rules/rendering-hd2d.md`: Forward+, pixel-art sprites in 3D, post-processing. Delete it for other kinds of games.
- `scripts/agent-check.sh`: runs supported checks already available in the project (Godot import, gdformat, gdlint, GUT/gdUnit4, Gitleaks).
- `scripts/godot-editor.sh`: opens the editor with a renderer that works in the container.

Language-agnostic configuration (permission deny rules, security instructions, `quick-review` and `security-audit` skills) comes from the `ai-tools` feature, not from this template.

## Checks
From a generated project root:

```bash
./scripts/agent-check.sh
```

The script does not install tools or addons. Add GUT or gdUnit4 to `addons/` to enable tests.
