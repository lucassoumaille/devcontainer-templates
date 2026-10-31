---
description: Node.js and TypeScript implementation and API conventions
---

- Follow the repository's established framework, package manager (npm, pnpm, yarn), module system, architecture, and naming conventions.
- Use explicit, intention-revealing names for functions, types, variables, routes, and request/response schemas.
- Prefer simple code over unnecessary abstractions.
- Add or update tests for behavior changes and bug fixes.
- Keep TypeScript strict where the project enables it. Do not introduce `any`, non-null assertions, or `@ts-ignore` to silence errors; fix the types or use `unknown` and narrow.
- Validate external input (HTTP bodies, environment variables, third-party responses) at the boundary instead of trusting static types.
- Do not add dependencies without justification. Use the project's lock file; do not switch package managers.
- Keep comments and JSDoc short; explain non-obvious intent or constraints, not what the code already says.
