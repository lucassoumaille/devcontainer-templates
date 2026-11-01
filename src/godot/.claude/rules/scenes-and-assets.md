---
description: Project layout, scenes, resources and assets
paths:
  - "**/*.tscn"
  - "**/*.tres"
  - "project.godot"
  - "export_presets.cfg"
---

- Default layout, unless the project already uses another one: group by feature, a scene next to its script (`scenes/player/player.tscn` + `player.gd`); shared assets in `assets/{sprites,tilesets,models,audio,fonts,shaders}/`; UI in `ui/`; global services in `autoload/`; tests in `tests/`; third-party plugins in `addons/`.
- `.godot/` is a cache: never edit or commit it. `*.import` files are generated but committed; `*.uid` files (Godot 4.4+) are committed and must move with their script or resource.
- When editing `.tscn`/`.tres` by hand: keep `load_steps`, `[ext_resource]` ids and `[sub_resource]` ids consistent, do not invent `uid://` values, and run `godot --headless --import --quit` afterwards to check the file still loads.
- Prefer instancing scenes over duplicating node trees. Keep one responsibility per scene.
- Do not change `project.godot` settings (renderer, physics ticks, window size, input map) without approval; describe the setting and its value when you do.
- Binary assets go through Git LFS when the project has a `.gitattributes` for them; do not commit large binaries outside LFS.
