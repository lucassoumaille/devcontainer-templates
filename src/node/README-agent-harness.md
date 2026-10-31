# Node.js Agent Harness

This template provides concise instructions and optional Claude Code rules for Node.js and TypeScript projects, including HTTP APIs.

## Included
- `AGENTS.md`: shared instructions for compatible coding agents.
- `CLAUDE.md`: Claude Code entry point, imports `AGENTS.md`.
- `.claude/rules/typescript.md`: Node.js and TypeScript conventions.
- `.claude/rules/api-contracts.md`: router, OpenAPI, and API documentation guidance.
- `.claude/rules/testing.md`: testing expectations.
- `scripts/agent-check.sh`: runs supported checks already available in the project (`npm test`, `npm run lint`, `tsc --noEmit`, Gitleaks).

Language-agnostic configuration (permission deny rules, security instructions, `quick-review` and `security-audit` skills) comes from the `ai-tools` feature, not from this template.

## Checks
From a generated project root:

```bash
./scripts/agent-check.sh
```

The script does not install tools. It uses the project's own `test` and `lint` scripts and the project's local `typescript` dependency, so it never assumes a particular test runner or linter.
