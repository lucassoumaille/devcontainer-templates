# Claude Code Instructions

Read and follow [`AGENTS.md`](./AGENTS.md) before working.

## Python and API guidance
- Inspect the framework, router registration, schema definitions, dependency manager, and existing tests before making changes.
- Use explicit names and straightforward implementations.
- For API changes, update the implementation, tests, and OpenAPI contract through the project's established generation/export workflow.
- Prefer framework-generated OpenAPI when supported. Do not manually maintain a duplicate contract.
- Keep the root README concise and update it only for meaningful structural, setup, command, architecture, or externally visible changes.

## Completion checklist
- Run the relevant tests and lint checks.
- For API changes, validate that the OpenAPI contract matches the routes and schemas.
- Run `git diff --check` and review the final diff.
- Summarize changes and validation honestly, including checks not run.
