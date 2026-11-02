FROM mcr.microsoft.com/devcontainers/base:3.0.12-ubuntu24.04

# Change SUPABASE_CLI_VERSION in devcontainer.json and SUPABASE_CLI_VERSION in .github/workflows/db-*.yml together.
ARG SUPABASE_CLI_VERSION=2.122.0
ARG DENO_VERSION=2.9.8
ARG POSTGRES_CLIENT_MAJOR=17

# make: runs the Makefile commands. postgresql-client from the PostgreSQL apt repository:
# Ubuntu 24.04 ships psql 16, the local Supabase database is Postgres 17.
RUN set -eux; \
    apt-get update; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y --no-install-recommends make unzip; \
    install -d /usr/share/postgresql-common/pgdg; \
    curl -fsSL -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc; \
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt noble-pgdg main" \
        > /etc/apt/sources.list.d/pgdg.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends "postgresql-client-${POSTGRES_CLIENT_MAJOR}"; \
    rm -rf /var/lib/apt/lists/*

# Supabase CLI .deb, verified against the release checksums.txt.
RUN set -eux; \
    release="https://github.com/supabase/cli/releases/download/v${SUPABASE_CLI_VERSION}"; \
    deb="supabase_${SUPABASE_CLI_VERSION}_linux_amd64.deb"; \
    cd /tmp; \
    curl -fsSLO "${release}/${deb}"; \
    curl -fsSL "${release}/checksums.txt" | grep "  ${deb}\$" | sha256sum -c -; \
    dpkg -i "${deb}"; \
    rm "${deb}"; \
    supabase --version

# Deno: needed by the VS Code Deno extension and for `deno check/lint/fmt` on Edge Functions
# (the Supabase edge runtime itself runs in a container started by `supabase start`).
RUN set -eux; \
    release="https://github.com/denoland/deno/releases/download/v${DENO_VERSION}"; \
    zip="deno-x86_64-unknown-linux-gnu.zip"; \
    cd /tmp; \
    curl -fsSLO "${release}/${zip}"; \
    curl -fsSL "${release}/${zip}.sha256sum" | sha256sum -c -; \
    unzip -q "${zip}" -d /usr/local/bin; \
    rm "${zip}"; \
    deno --version

# Optional Dart SDK: `supabase gen types --lang dart` (make types-dart) shells out to `dart`.
ARG INSTALL_DART=false
ARG DART_VERSION=3.13.7
ENV PATH="/usr/lib/dart-sdk/bin:${PATH}"
RUN set -eux; \
    if [ "${INSTALL_DART}" = "true" ]; then \
        release="https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk"; \
        zip="dartsdk-linux-x64-release.zip"; \
        cd /tmp; \
        curl -fsSLO "${release}/${zip}"; \
        curl -fsSL "${release}/${zip}.sha256sum" | sed 's/ \*/  /' | sha256sum -c -; \
        unzip -q "${zip}" -d /usr/lib; \
        rm "${zip}"; \
        /usr/lib/dart-sdk/bin/dart --disable-analytics; \
        /usr/lib/dart-sdk/bin/dart --version; \
    fi
