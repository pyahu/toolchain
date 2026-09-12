#!/usr/bin/env sh
# Refresh every stable profile lock for the supported release platforms.
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOCK_CONFIG_DIR="$(mktemp -d)"
LOCK_PLATFORMS="${MISE_LOCK_PLATFORMS:-linux-x64,macos-arm64}"
trap 'rm -rf "$LOCK_CONFIG_DIR"' EXIT HUP INT TERM

if ! command -v mise >/dev/null 2>&1; then
  echo "mise not found: https://mise.jdx.dev/getting-started.html" >&2
  exit 1
fi

if [ -e "$REPO_DIR/mise.ai.lock" ]; then
  echo "refusing to refresh: mise.ai.lock must not exist because the AI profile is rolling" >&2
  exit 1
fi

cd "$REPO_DIR"
MISE_CONFIG_DIR="$LOCK_CONFIG_DIR" MISE_ENV='' \
  mise lock --platform "$LOCK_PLATFORMS"

for profile in workstation java go python node cloud arch; do
  MISE_CONFIG_DIR="$LOCK_CONFIG_DIR" MISE_ENV="$profile" \
    mise lock --platform "$LOCK_PLATFORMS"
done

chmod 644 mise.lock mise.workstation.lock mise.java.lock mise.go.lock \
  mise.python.lock mise.node.lock mise.cloud.lock mise.arch.lock

echo "Stable lockfiles refreshed for: $LOCK_PLATFORMS"
echo "Review the lockfile diff and run the full validation suite before committing."
