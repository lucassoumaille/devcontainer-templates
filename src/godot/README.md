
# Godot 4 (godot)

Godot 4 (GDScript) with export templates for Windows and Linux, gdtoolkit, editor display through WSLg, Claude Code (shared login) and OpenCode.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| godotVersion | Godot version (must match the editor used on other machines): | string | 4.7.2 |

## Claude Code login

The `ai-tools` feature mounts the named volume `claude-code-config` and sets `CLAUDE_CONFIG_DIR`. Log in once with `claude`: every container built from these templates reuses the same login and user settings. Do not add another Claude mount or `CLAUDE_CONFIG_DIR` in `devcontainer.json`, it would override the shared one.

## Requires Windows + WSL2 (WSLg)

The editor window, GPU and audio go through WSLg: `devcontainer.json` mounts `/tmp/.X11-unix`, `/mnt/wslg`, `/usr/lib/wsl` and passes `/dev/dxg`. The container does not start where these do not exist (macOS, native Linux, CI). On native Linux, replace them with:

```json
"runArgs": ["--cap-drop=ALL", "--security-opt=no-new-privileges", "--device=/dev/dri"],
"mounts": ["source=/tmp/.X11-unix,target=/tmp/.X11-unix,type=bind"],
"containerEnv": { "DISPLAY": "${localEnv:DISPLAY}" }
```

## Editor and renderer

```bash
./scripts/godot-editor.sh
```

Debian ships no Vulkan driver for the WSL GPU (Mesa `dzn` is not packaged), so Vulkan would run on the CPU (lavapipe). The script starts the editor with `--rendering-driver opengl3`, which is hardware accelerated through the Mesa d3d12 driver but uses the **Compatibility** renderer: Forward+ effects (DOF, volumetric fog, SDFGI) are not shown. To preview Forward+ anyway, slowly:

```bash
GODOT_RENDERING_DRIVER=vulkan ./scripts/godot-editor.sh
```

For HD-2D work, check the final look on a Windows export run on the host, or install the same Godot version on Windows and open the project there (only the `.godot/` cache is per machine).

## Exports

Export templates for Windows and Linux (x86_64, arm64) are installed for the selected version. SteamOS / Steam Deck runs the Linux x86_64 export natively.

```bash
mkdir -p build
godot --headless --export-release "Windows Desktop" build/game.exe
godot --headless --export-release "Linux" build/game.x86_64
```

Presets are created once in the editor (**Project > Export**) and saved in `export_presets.cfg`. Android, Web, macOS and iOS templates are not installed.

## Project files

The template adds a `.gitignore` (`.godot/` cache, `build/`) and a `.gitattributes` that stores images, audio, models and fonts in Git LFS. Run `git lfs install` once if you keep the LFS rules, or delete them before the first commit.

## Hardening

The container runs with `--cap-drop=ALL` and `no-new-privileges`: `sudo`, `apt-get` and `chown` do not work inside it. Add system packages in `.devcontainer/Dockerfile` instead.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lucassoumaille/devcontainer-templates/blob/main/src/godot/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
