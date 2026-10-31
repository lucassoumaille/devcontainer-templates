## Claude Code login

The `ai-tools` feature mounts the named volume `claude-code-config` and sets `CLAUDE_CONFIG_DIR`. Log in once with `claude`: every container built from these templates reuses the same login and user settings. Do not add another Claude mount or `CLAUDE_CONFIG_DIR` in `devcontainer.json`, it would override the shared one.

## Project tooling

TypeScript, ESLint, Prettier and test runners belong in the project's `package.json` (`npm install -D typescript eslint prettier vitest`), not in the image: each project pins its own versions, and `npx` or `npm run` uses them.

## Hardening

The container runs with `--cap-drop=ALL` and `no-new-privileges`: `sudo`, `apt-get` and `chown` do not work inside it. Add system packages or global CLIs with a Dockerfile or a dev container feature instead.
