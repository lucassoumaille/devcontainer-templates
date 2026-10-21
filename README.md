# Dev Container Templates

Reusable development environments for consistent, AI-assisted software development.

This repository provides standardized [Dev Container Templates](https://containers.dev/implementors/templates/) for language-specific development environments.

The goal is to maintain one reliable development setup per language while sharing common tools, AI coding assistants, and configuration across projects.

## Available Templates

| Template | Description | Status |
|---|---|---|
| `python` | Python development with Claude Code, Node.js, and OpenCode | Initial template |

Additional language templates, such as Node.js, Go, and Rust, can be added under `src/`.

## Architecture

This repository contains development environment templates, not production application images.

Shared tools are maintained separately in the `devcontainer-features` repository.

```text
GitHub
├── devcontainer-templates
│   └── src/
│       ├── python/
│       ├── node/       # Planned
│       ├── go/         # Planned
│       └── rust/       # Planned
│
└── devcontainer-features
    └── src/
        └── ai-tools/
            ├── Claude Code
            └── VS Code extension
```

### Responsibilities

- **Templates:** language runtimes, VS Code extensions, project-specific settings, mounts, and environment variables.
- **Features:** reusable tools installed inside development containers.
- **Project repositories:** application code, dependencies, tests, and project-specific agent instructions.
- **Production images:** built and published separately for deployment.

## Python Standard Template

The Python template currently provides:

- Python development using the repository's Dockerfile.
- Node.js 22 for JavaScript-based development tools.
- Claude Code through the shared `ai-tools` Feature.
- The Claude Code VS Code extension.
- Python and Ruff VS Code extensions.
- OpenCode CLI installed through npm.
- A persistent Docker volume for Claude configuration.
- Optional WSLg integration for Linux graphical applications.

### Shared AI tools

The template uses the published Feature:

```json
{
  "ghcr.io/TON_USER/devcontainer-features/ai-tools:1": {}
}
```

The Feature is responsible for installing Claude Code and providing its VS Code extension.

Node.js remains a separate Feature in the Python template because OpenCode is installed using npm.

### Claude configuration persistence

The template configures a named Docker volume:

```json
{
  "mounts": [
    "source=claude-code-config-${devcontainerId},target=/home/vscode/.claude,type=volume"
  ],
  "containerEnv": {
    "CLAUDE_CONFIG_DIR": "/home/vscode/.claude"
  }
}
```

This keeps Claude configuration outside the container's writable filesystem.

- Rebuilding the same Dev Container can reuse its volume.
- Different projects normally use separate volumes.
- Removing the volume deletes the persisted configuration.
- Authentication may need to be renewed if a session expires.

Never commit credentials, API keys, or authentication tokens to this repository.

### WSLg support

The Python template may include WSLg mounts and environment variables for graphical Linux applications.

These settings are specific to WSL2 and should not automatically be copied into templates intended for macOS, native Linux, or cloud environments.

## Using a Template

Requirements:

- Docker or another supported Dev Container runtime.
- Visual Studio Code.
- The Dev Containers extension.
- The Dev Container CLI.

Create a project directory:

```bash
mkdir my-python-project
cd my-python-project
```

Apply the published Python template:

```bash
devcontainer templates apply \
  --template-id ghcr.io/TON_USER/devcontainer-templates/python:latest \
  --workspace-folder .
```

Replace `TON_USER` with the publishing GitHub account or organization.

Open the project in VS Code:

```bash
code .
```

Then run **Dev Containers: Rebuild and Reopen in Container**.

The resulting environment should install the template's configured Features and VS Code extensions.

## Project Dependencies

The template may configure project-specific commands, such as:

```bash
pip install -e '.[dev]'
```

This command assumes the project provides a suitable Python package configuration.

Project dependency installation should remain separate from shared Features so that generic tooling does not depend on a particular application's structure.

## Testing

Run the repository's automated template tests using the Dev Container CLI and the workflows provided by the starter.

Before publishing changes, verify:

- Template metadata is valid.
- The Dev Container configuration is valid JSON.
- All referenced Features are accessible.
- The container builds successfully.
- Claude Code is available inside the container.
- The Claude configuration directory is writable.
- Configuration persists after rebuilding the same container.

## Publishing

Templates are published as OCI artifacts through GitHub Container Registry (GHCR).

The expected reference format is:

```text
ghcr.io/TON_USER/devcontainer-templates/python:VERSION
```

For example:

```text
ghcr.io/TON_USER/devcontainer-templates/python:latest
```

Use the repository's GitHub Actions release workflow to publish templates and generate documentation.

Keep each template's version in `src/<template>/devcontainer-template.json` up to date when releasing changes.

## Security Principles

- Never commit secrets or personal credentials.
- Avoid embedding credentials in Docker images.
- Persist only the configuration required by each tool.
- Review host mounts before exposing host resources to containers.
- Keep Docker daemon access and sensitive host credentials protected.
- Test container hardening settings against the required development tools.

## Roadmap

- [x] Establish the Python template.
- [x] Create a shared AI tools Feature.
- [ ] Validate Claude configuration persistence.
- [ ] Add a Node.js template.
- [ ] Add Go and Rust templates.
- [ ] Expand shared security and developer tooling.
- [ ] Standardize agent instructions and project templates.

## License

See [LICENSE](LICENSE).
