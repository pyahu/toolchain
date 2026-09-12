#!/usr/bin/env sh
# Run the Astro Starlight documentation site with pinned dependencies.
set -eu

cd "$(dirname "$0")/../website"

if [ ! -d node_modules ]; then
  npm ci
fi

command_name="${1:-dev}"
if [ "$#" -gt 0 ]; then
  shift
fi

if [ "$command_name" = build ]; then
  if [ "${1:-}" = --strict ]; then
    shift
  fi
  npm run check
fi

exec npm run "$command_name" -- "$@"
