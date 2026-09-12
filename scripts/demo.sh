#!/usr/bin/env sh
# Safe terminal demo: all installer state is isolated in a temporary directory.
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEMO_ROOT="$(mktemp -d)"
DEMO_CONFIG="$DEMO_ROOT/mise"
DEMO_DATA="$DEMO_ROOT/data"
DEMO_CACHE="$DEMO_ROOT/cache"
trap 'rm -rf "$DEMO_ROOT"' EXIT HUP INT TERM

echo "== Pyahu Toolchain =="
mise --version
echo

echo "== Preview a base + Python setup =="
MISE_CONFIG_DIR="$DEMO_CONFIG" "$REPO_DIR/install.sh" --dry-run python
echo

echo "== Install isolated configuration links =="
MISE_CONFIG_DIR="$DEMO_CONFIG" "$REPO_DIR/install.sh" python
echo

echo "== Ask mise what it would install =="
(
  cd "$DEMO_ROOT"
  MISE_CONFIG_DIR="$DEMO_CONFIG" \
    MISE_DATA_DIR="$DEMO_DATA" \
    MISE_CACHE_DIR="$DEMO_CACHE" \
    MISE_ENV=python \
    mise install --dry-run 2>&1
)
echo

echo "== Remove only the isolated Pyahu links =="
MISE_CONFIG_DIR="$DEMO_CONFIG" "$REPO_DIR/install.sh" --uninstall
echo
echo "Demo complete. No user configuration was changed."
