---
description: Test and validation expectations
---

- Inspect existing tests and their helpers before writing new ones.
- Unit tests for view models, repositories and parsing (`test/`), with fake services instead of real HTTP or plugins. Inject dependencies through constructors so they can be replaced.
- Widget tests for screens and interactions (`testWidgets`, `pumpAndSettle`, `find.*`). Find widgets by text, semantics label or `Key`, not by widget tree position.
- Platform plugins do not run in `flutter test`: hide them behind an interface, or use the plugin's official test/mock support.
- Integration tests (`integration_test/`) run on a device: `flutter test integration_test -d <device-id>` (emulator or phone; `linux` for logic that does not need Android plugins). Native permission dialogs need `patrol`; ask before adding it.
- Golden tests only if the project already uses them; regenerate with `--update-goldens` only for intended visual changes and say so.
- Prefer focused runs during iteration (`flutter test test/path_test.dart`, `--plain-name`) and the full suite before completion.
- Camera, biometrics, notifications, background behavior and real network conditions cannot be verified by unit tests: report them as not verified and say what to check on a device.
- Never delete or weaken a test merely because it fails. Report failures and environmental blockers without claiming success.
