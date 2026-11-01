#!/usr/bin/env bash
set -Eeuo pipefail

# Open the Godot editor for the project in the current directory.
# Debian has no Vulkan driver for the WSL GPU (/dev/dxg): Vulkan would fall back to
# software rendering, so OpenGL (d3d12, hardware) is used there unless overridden.
# Set GODOT_RENDERING_DRIVER=vulkan to preview Forward+ anyway (slow).

driver="${GODOT_RENDERING_DRIVER:-}"
if [[ -z "${driver}" && -e /dev/dxg ]]; then
  driver="opengl3"
fi

args=(--editor --path .)
if [[ -n "${driver}" ]]; then
  args+=(--rendering-driver "${driver}")
fi

exec godot "${args[@]}" "$@"
