ARG VARIANT=3.14-trixie
FROM mcr.microsoft.com/devcontainers/python:3-${VARIANT}

USER vscode

RUN pip install --no-cache-dir \
    pytest \
    pytest-cov \
    ruff \
    mypy
