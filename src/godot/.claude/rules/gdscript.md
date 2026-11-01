---
description: GDScript conventions
paths:
  - "**/*.gd"
---

- Follow the official GDScript style guide: `snake_case` files, functions and variables; `PascalCase` for `class_name`, nodes and enums; `CONSTANT_CASE` for constants; signals in past tense (`health_changed`, `died`).
- Use static typing everywhere: typed variables, parameters and return types (`-> void`), typed arrays and dictionaries (`Array[Enemy]`). Prefer `:=` only when the type is obvious from the right-hand side.
- Keep scripts in their usual member order: `class_name`, `extends`, signals, enums, constants, `@export`, public vars, private vars (`_name`), `@onready`, built-in callbacks (`_ready`, `_process`…), public methods, private methods.
- Communicate "call down, signal up": a node calls methods on its children and emits signals to its parent. Avoid `get_parent()` chains and absolute node paths; use `@export` node references or `%UniqueName`.
- Keep autoloads for truly global services (save, audio, scene transitions). Do not put gameplay state in autoloads by default.
- Put frame-rate-independent movement in `_physics_process` with `delta`. Do not do heavy work in `_process`.
- Use `Resource` subclasses for data (stats, items, dialogue) instead of dictionaries with string keys.
- Free nodes with `queue_free()`, not `free()`. Check `is_instance_valid()` before using a node that can be freed.
- Do not silence warnings with `@warning_ignore` unless the reason is stated in a comment.
