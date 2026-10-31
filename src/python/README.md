
# Python 3 (python)

Python 3 with Ruff, pytest, mypy, Claude Code (shared login) and OpenCode.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | Python version and Debian release: | string | 3.14-trixie |

## Claude Code login

The `ai-tools` feature mounts the named volume `claude-code-config` and sets `CLAUDE_CONFIG_DIR`. Log in once with `claude`: every container built from these templates reuses the same login and user settings. Do not add another Claude mount or `CLAUDE_CONFIG_DIR` in `devcontainer.json`, it would override the shared one.

## WSLg (optional, Windows + WSL2 only)

To run Linux GUI apps, add this to `.devcontainer/devcontainer.json`. Do not commit it to projects used on macOS, native Linux or CI: the bind mounts fail when `/mnt/wslg` does not exist.

```json
"mounts": [
    "source=/tmp/.X11-unix,target=/tmp/.X11-unix,type=bind",
    "source=/mnt/wslg,target=/mnt/wslg,type=bind"
],
"containerEnv": {
    "DISPLAY": ":0",
    "WAYLAND_DISPLAY": "wayland-0",
    "XDG_RUNTIME_DIR": "/mnt/wslg/runtime-dir",
    "PULSE_SERVER": "/mnt/wslg/PulseServer"
}
```

## Hardening

The container runs with `--cap-drop=ALL` and `no-new-privileges`: `sudo`, `apt-get` and `chown` do not work inside it. Add system packages in `.devcontainer/Dockerfile` instead.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lucassoumaille/devcontainer-templates/blob/main/src/python/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
