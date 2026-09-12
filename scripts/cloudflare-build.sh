#!/usr/bin/env sh
# Build the static documentation in Cloudflare Workers Builds.
set -eu

export NO_MKDOCS_2_WARNING=true

exec pipx run --spec uv==0.12.10 uvx \
  --from mkdocs==1.6.1 \
  --with mkdocs-material==9.7.7 \
  mkdocs build --strict
