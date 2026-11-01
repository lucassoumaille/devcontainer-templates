FROM mcr.microsoft.com/devcontainers/base:trixie

ARG GODOT_VERSION=4.7.2

# Runtime libraries for the Godot editor window (X11/Wayland, OpenGL through the
# WSLg d3d12 Mesa driver, software Vulkan fallback) and audio through PulseAudio.
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        unzip \
        pipx \
        fontconfig \
        libgl1 \
        libegl1 \
        libgl1-mesa-dri \
        libvulkan1 \
        mesa-vulkan-drivers \
        vulkan-tools \
        mesa-utils \
        libx11-6 \
        libxcursor1 \
        libxinerama1 \
        libxrandr2 \
        libxi6 \
        libxext6 \
        libxkbcommon0 \
        libxkbcommon-x11-0 \
        libwayland-client0 \
        libwayland-cursor0 \
        libwayland-egl1 \
        libdecor-0-0 \
        libpulse0 \
        libasound2t64 \
        libdbus-1-3 \
    && rm -rf /var/lib/apt/lists/*

# Godot editor binary and export templates, verified against the release SHA512-SUMS.txt.
# Only the Windows and Linux templates are kept (the full archive is about 1.3 GB).
RUN set -eux; \
    release="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable"; \
    editor="Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip"; \
    templates="Godot_v${GODOT_VERSION}-stable_export_templates.tpz"; \
    tmp="$(mktemp -d)"; \
    cd "${tmp}"; \
    curl -fsSLO "${release}/SHA512-SUMS.txt"; \
    curl -fsSLO "${release}/${editor}"; \
    curl -fsSLO "${release}/${templates}"; \
    grep -E "  (${editor}|${templates})\$" SHA512-SUMS.txt | sha512sum -c -; \
    unzip -q "${editor}"; \
    install -m 0755 "Godot_v${GODOT_VERSION}-stable_linux.x86_64" /usr/local/bin/godot; \
    dest="/home/vscode/.local/share/godot/export_templates/${GODOT_VERSION}.stable"; \
    mkdir -p "${dest}"; \
    unzip -q -j "${templates}" 'templates/version.txt' 'templates/linux_*' 'templates/windows_*' -d "${dest}"; \
    chown -R vscode:vscode /home/vscode/.local; \
    cd /; \
    rm -rf "${tmp}"

USER vscode

RUN pipx install "gdtoolkit==4.*"

ENV PATH="/home/vscode/.local/bin:${PATH}"
