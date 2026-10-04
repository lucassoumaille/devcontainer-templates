FROM mcr.microsoft.com/devcontainers/python:1-3.12-bookworm

USER root

RUN rm -f /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends x11-apps \
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p /home/vscode/.claude && chown -R vscode:vscode /home/vscode/.claude

USER vscode

RUN pip install --no-cache-dir \
    pytest \
    pytest-cov \
    ruff \
    mypy