---
name: security-audit
description: Perform a scoped security review of the current project and its changes.
---

# Security Audit

1. Define the scope and inspect relevant source, dependency manifests, and configuration.
2. Search for accidental secrets and risky patterns without printing secret values.
3. Check input validation, subprocess use, file access, authentication, authorization, and dependency risks where relevant.
4. Prefer read-only checks. Ask before installing tools, changing files, accessing unrelated host paths, or making network calls.
5. Report findings with severity, evidence, impact, and a practical remediation.
6. State limitations; do not claim a comprehensive audit from a quick scan.
