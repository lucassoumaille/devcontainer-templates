---
description: Rendering guidance for HD-2D (pixel-art sprites in 3D scenes)
paths:
  - "**/*.tscn"
  - "**/*.tres"
  - "**/*.gdshader"
  - "project.godot"
---

- HD-2D uses the Forward+ renderer (Windows, Linux/SteamOS). Do not switch the project to Mobile or Compatibility without approval: DOF, glow, volumetric fog and SDFGI/VoxelGI depend on Forward+.
- Characters and props are `Sprite3D` / `AnimatedSprite3D` with `billboard` (or Y-billboard) in a 3D scene. Keep `pixel_size` consistent across sprites so pixels have the same world size.
- Pixel-art textures: nearest filtering (`texture_filter = nearest` or the project default), no mipmaps, no lossy compression in import settings. Sprites that receive light use `shaded = true`; use `alpha_cut` (discard) to keep shadows and depth sorting stable.
- Post-processing lives in a single `WorldEnvironment` + `CameraAttributes` per level: tilt-shift look via DOF (far/near blur), glow/bloom, tonemapping. Do not stack several `WorldEnvironment` nodes.
- Use a fixed-angle `Camera3D` (often perspective with a low FOV). Snap camera and sprite positions to the pixel grid when shimmering appears.
- The editor in the dev container runs with OpenGL (Compatibility) by default: Forward+ effects are not visible there. Verify visuals on a Windows export or in the editor on the host, and say so in the report.
- Watch the cost of effects on Steam Deck (800p, mid-range GPU): prefer baked lighting (LightmapGI) and limit dynamic shadows and volumetrics.
