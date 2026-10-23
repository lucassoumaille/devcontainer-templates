# Dev Container Templates

[Dev Container Templates](https://containers.dev/implementors/templates/) for language-specific development environments, sharing the same AI tooling and the same Claude Code login.

## Available Templates

| Template | Description |
|---|---|
| [`python`](src/python) | Python 3 with Ruff, pytest, mypy, Claude Code and OpenCode |

Planned: Node.js, Go, Rust.

## Architecture

```text
devcontainer-features            shared, language-agnostic
└── src/ai-tools/
    ├── Claude Code + VS Code extension
    ├── OpenCode (optional)
    ├── shared login       -> volume `claude-code-config`, CLAUDE_CONFIG_DIR=/mnt/claude-config
    └── shared config      -> /etc/claude-code (deny rules, CLAUDE.md), skills

devcontainer-templates           this repository, one folder per language
└── src/<language>/
    ├── .devcontainer/     image, language features, VS Code extensions
    ├── AGENTS.md, CLAUDE.md, .claude/rules/
    └── scripts/agent-check.sh
```

- **Feature `ai-tools`**: everything that is the same whatever the language, including the Claude Code login and your personal AI configuration.
- **Templates**: the language runtime, its tooling, and language-specific agent instructions.
- **Projects**: application code, dependencies, and project-specific instructions.

### One Claude login for every container

The `ai-tools` feature mounts the named Docker volume `claude-code-config` at `/mnt/claude-config` and sets `CLAUDE_CONFIG_DIR` to it. Every container built from these templates shares that volume, so you log in once.

Rules for new templates:

- Include `ghcr.io/lucassoumaille/devcontainer-features/ai-tools:1`.
- Do not declare a Claude mount or `CLAUDE_CONFIG_DIR` in the template.
- Run as a UID 1000 user (`vscode`, `node` in the Microsoft images) so the volume stays writable.

`docker volume rm claude-code-config` logs you out of every container.

## Using a Template

```bash
mkdir my-python-project && cd my-python-project
devcontainer templates apply \
  --template-id ghcr.io/lucassoumaille/devcontainer-templates/python:latest \
  --workspace-folder .
code .
```

Then run **Dev Containers: Reopen in Container**.

## Adding a Template

1. Create `src/<language>/` with `devcontainer-template.json`, `.devcontainer/` and the agent harness files.
2. Add `test/<language>/test.sh` (see [test/python/test.sh](test/python/test.sh)).
3. Add the template to the `paths-filter` in [.github/workflows/test-pr.yaml](.github/workflows/test-pr.yaml).

## Testing

Pull requests run a smoke test per changed template: the container is built with each option's default value, then `test/<template>/test.sh` runs inside it.

To run it locally (Docker required):

```bash
.github/actions/smoke-test/build.sh python
.github/actions/smoke-test/test.sh python
```

## Publishing

Run the **Release** workflow on `main`. Templates are published to `ghcr.io/lucassoumaille/devcontainer-templates/<template>` and each template's `README.md` is regenerated (add notes in `NOTES.md`). Bump `version` in `src/<template>/devcontainer-template.json` for every release.

## Security

- Never commit secrets, and never bake credentials into images.
- Every container that uses `ai-tools` can read your Claude credentials: do not use these templates to open untrusted code.
- Templates run with `--cap-drop=ALL` and `no-new-privileges`. Install system packages in the Dockerfile, not at runtime.

## License

See [LICENSE](LICENSE).
