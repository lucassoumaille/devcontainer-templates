---
description: Test and validation expectations
---

- Inspect the project's configured test commands before running checks.
- Prefer focused tests during iteration and the relevant full test suite before completion.
- For API changes, test changed routes, schemas, status codes, and error behavior.
- Validate or regenerate OpenAPI using the project's established workflow when the public contract changes.
- Never delete or weaken a test merely because it fails.
- Report test failures and environmental blockers without claiming success.
