#!/usr/bin/env sh
# Run the documentation site with pinned tools and no global Python setup.
set -eu

# The site is pinned to MkDocs 1.x, so the upstream MkDocs 2 migration warning is not actionable.
export NO_MKDOCS_2_WARNING=true

exec mise x uv@0.12.10 -- \
  uvx --from mkdocs==1.6.1 --with mkdocs-material==9.7.7 mkdocs "$@"
