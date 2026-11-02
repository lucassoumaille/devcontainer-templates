FROM mcr.microsoft.com/devcontainers/base:trixie

ARG FLUTTER_VERSION=3.47.9
ARG ANDROID_PLATFORM=36
ARG ANDROID_BUILD_TOOLS=36.0.0
ARG ANDROID_NDK=28.2.13676358
# From https://dl.google.com/android/repository/repository2-3.xml (Google only publishes SHA-1).
ARG CMDLINE_TOOLS_BUILD=16111833
ARG CMDLINE_TOOLS_SHA1=e025545c62a8e64c7559119566a569fb1dec5f60

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 \
    ANDROID_HOME=/opt/android-sdk \
    FLUTTER_ROOT=/opt/flutter
ENV PATH="${FLUTTER_ROOT}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

# JDK for Gradle, toolchain for the Linux desktop target, and the GL libraries
# its window needs under WSLg.
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        openjdk-21-jdk-headless \
        jq \
        unzip \
        xz-utils \
        zip \
        clang \
        cmake \
        ninja-build \
        pkg-config \
        libgtk-3-dev \
        liblzma-dev \
        libstdc++-14-dev \
        libgl1 \
        libegl1 \
        libgl1-mesa-dri \
    && rm -rf /var/lib/apt/lists/*

# Flutter SDK, verified against the SHA-256 published in the release manifest.
RUN set -eux; \
    base="https://storage.googleapis.com/flutter_infra_release/releases"; \
    release="$(curl -fsSL "${base}/releases_linux.json" \
        | jq -er --arg v "${FLUTTER_VERSION}" '[.releases[] | select(.version == $v and .channel == "stable")][0] | "\(.archive) \(.sha256)"')"; \
    archive="${release% *}"; \
    sha256="${release#* }"; \
    curl -fsSL -o /tmp/flutter.tar.xz "${base}/${archive}"; \
    echo "${sha256}  /tmp/flutter.tar.xz" | sha256sum -c -; \
    tar -xJf /tmp/flutter.tar.xz -C /opt; \
    rm /tmp/flutter.tar.xz; \
    mkdir -p "${ANDROID_HOME}"; \
    chown -R vscode:vscode "${FLUTTER_ROOT}" "${ANDROID_HOME}"

USER vscode

# Directories backed by shared named volumes (see devcontainer.json). Creating them
# here lets Docker initialise the volumes with vscode ownership.
RUN mkdir -p /home/vscode/.gradle /home/vscode/.pub-cache /home/vscode/.android

# Android SDK. The SDK stays writable so Gradle can add the NDK/CMake versions a plugin asks for.
RUN set -eux; \
    zip="commandlinetools-linux-${CMDLINE_TOOLS_BUILD}_latest.zip"; \
    curl -fsSL -o "/tmp/${zip}" "https://dl.google.com/android/repository/${zip}"; \
    echo "${CMDLINE_TOOLS_SHA1}  /tmp/${zip}" | sha1sum -c -; \
    unzip -q "/tmp/${zip}" -d /tmp/cmdline-tools; \
    mkdir -p "${ANDROID_HOME}/cmdline-tools"; \
    mv /tmp/cmdline-tools/cmdline-tools "${ANDROID_HOME}/cmdline-tools/latest"; \
    rm -rf "/tmp/${zip}" /tmp/cmdline-tools; \
    yes | sdkmanager --licenses > /dev/null; \
    sdkmanager --install \
        "platform-tools" \
        "platforms;android-${ANDROID_PLATFORM}" \
        "build-tools;${ANDROID_BUILD_TOOLS}" \
        "ndk;${ANDROID_NDK}" > /dev/null

RUN set -eux; \
    flutter config --no-analytics --no-cli-animations --android-sdk "${ANDROID_HOME}"; \
    dart --disable-analytics; \
    flutter precache --android --linux --web; \
    flutter --version
