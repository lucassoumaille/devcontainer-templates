---
description: Test and validation expectations
---

- Inspect which test framework the project uses (`addons/gut/` or `addons/gdUnit4/`) before writing tests; do not add one without approval.
- Test gameplay logic that does not need rendering: damage, inventory, state machines, save/load, pathfinding rules. Keep that logic in plain scripts or resources so it is testable headless.
- Run tests headless: `godot --headless -s addons/gut/gut_cmdln.gd -gexit` (GUT) or `addons/gdUnit4/runtest.sh --headless -a res://tests` (gdUnit4).
- Prefer focused tests during iteration (`-gtest=res://tests/test_x.gd` for GUT) and the full suite before completion.
- Rendering, animation feel, camera and input cannot be verified headless: report them as not verified and say what to check in the editor.
- Never delete or weaken a test merely because it fails.
- Report test failures and environmental blockers without claiming success.
