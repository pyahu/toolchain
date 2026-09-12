#!/usr/bin/env sh
# Build the static documentation in Cloudflare Workers Builds.
set -eu

cd "$(dirname "$0")/../website"
npm ci
npm run check
npm run build
exec ../scripts/site-check.py
