# Python Agent Harness

This template provides concise instructions and optional Claude Code rules for Python projects, including HTTP APIs.

## Included
- `AGENTS.md`: shared instructions for compatible coding agents.
- `CLAUDE.md`: Claude Code entry point.
- `.claude/rules/python.md`: Python conventions.
- `.claude/rules/api-contracts.md`: router, OpenAPI, and API documentation guidance.
- `.claude/rules/testing.md` and `security.md`: testing and security expectations.
- `.claude/skills/`: opt-in code review and security audit workflows.
- `scripts/agent-check.sh`: runs supported checks already available in the project.

## OpenAPI conventions
Prefer the framework's generated OpenAPI document when available. Swagger UI displays that contract; it is not a separate source of truth.

If a repository explicitly versions a static contract, use `docs/api/openapi.yaml` by default and update it alongside public API changes. Do not add a static file merely for the sake of having one if the framework already generates the contract and the project does not need a checked-in snapshot.

## Documentation style
Use clear function and schema names. Keep comments and docstrings for non-obvious intent or constraints. Update the root README for meaningful structural, setup, command, architecture, or externally visible changes—not every internal refactor.

## Checks
From a generated project root:

```bash
./scripts/agent-check.sh
```

The script does not install tools. Run framework-specific OpenAPI validation using the command established by the actual project; this template does not assume a particular web framework.
