---
description: HTTP API routers, OpenAPI contracts, and API documentation
---

- Before changing an API, inspect how routers are registered, how request/response schemas are defined, and how the framework generates OpenAPI.
- Treat the implemented routes and schemas as the source of truth when the framework can generate OpenAPI.
- When a public API changes, update or regenerate the OpenAPI contract using the existing project workflow and update tests for the changed behavior.
- If the project intentionally stores a versioned OpenAPI document, use `docs/api/openapi.yaml` by default unless the repository already has a convention. Keep it synchronized with routes, parameters, request and response schemas, status codes, error responses, and authentication requirements.
- Do not create or hand-edit a second OpenAPI file if it duplicates a contract already generated from the application.
- Swagger UI is a viewer for OpenAPI, not the contract itself. Prefer the framework's built-in Swagger UI/ReDoc endpoints when available.
- Keep operation summaries and descriptions concise. Document constraints, side effects, security requirements, and non-obvious behavior; avoid verbose descriptions of obvious fields.
- Use stable, explicit operation IDs if the project uses generated clients or relies on operation IDs.
- Add contract validation or drift checks to tests/CI only in a way compatible with the existing framework and tooling.
- Update the root README only when routes, project structure, setup, commands, architecture, or externally visible behavior changes. Keep changes focused.
- Never claim the contract is synchronized unless the project's validation or generation command has been run successfully.
