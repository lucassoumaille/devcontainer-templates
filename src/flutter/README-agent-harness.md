# Flutter Agent Harness

This template provides concise instructions and optional Claude Code rules for Flutter apps targeting Android and iOS.

## Included
- `AGENTS.md`: shared instructions for compatible coding agents.
- `CLAUDE.md`: Claude Code entry point, imports `AGENTS.md`.
- `.claude/rules/dart-flutter.md`: code style, architecture layers, dependencies, UI and accessibility.
- `.claude/rules/android.md`: SDK levels, permissions, device features (network, notifications, camera, biometrics, location, background work, deep links), backup.
- `.claude/rules/ios.md`: `Info.plist` usage descriptions, capabilities, what needs a Mac.
- `.claude/rules/security.md`: HTTPS, secrets in the binary, secure storage, privacy.
- `.claude/rules/testing.md`: unit, widget and integration tests.
- `.claude/rules/release.md`: versioning, signing, obfuscation, store tracks.
- `.claude/rules/payments.md`: store billing vs payment providers, server-side validation.
- `scripts/agent-check.sh`: runs supported checks (dart format, flutter analyze, flutter test, integration tests on `INTEGRATION_DEVICE`, tracked signing keys, Gitleaks).
- `scripts/bootstrap.sh`: generates platform folders on first start.

Language-agnostic configuration (permission deny rules, security instructions, `quick-review` and `security-audit` skills) comes from the `ai-tools` feature, not from this template.

## Starter app
`lib/` contains a Material 3 home screen with placeholder tiles, light/dark themes and build-time configuration (`lib/core/app_config.dart`, `config/*.json`). Replace the tiles with real features; keep the layering described in `.claude/rules/dart-flutter.md`.

## Checks
From a generated project root:

```bash
./scripts/agent-check.sh
```

The script does not install tools or packages.
