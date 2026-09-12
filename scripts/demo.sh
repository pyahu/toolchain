#!/usr/bin/env sh
# Safe terminal demo: all installer state is isolated in a temporary directory.
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEMO_ROOT="$(mktemp -d)"
DEMO_CONFIG="$DEMO_ROOT/mise"
trap 'rm -rf "$DEMO_ROOT"' EXIT HUP INT TERM

echo "== Pyahu Toolchain =="
mise --version
echo

echo "== Preview a workstation + Node + cloud setup =="
MISE_CONFIG_DIR="$DEMO_CONFIG" "$REPO_DIR/install.sh" --dry-run workstation node cloud
echo

echo "== Install isolated configuration links =="
MISE_CONFIG_DIR="$DEMO_CONFIG" "$REPO_DIR/install.sh" workstation node cloud
echo

echo "== Ask mise what it would install =="
(
  cd "$DEMO_ROOT"
  MISE_CONFIG_DIR="$DEMO_CONFIG" MISE_ENV=workstation,node,cloud mise install --dry-run
)
echo

echo "== Remove only the isolated Pyahu links =="
MISE_CONFIG_DIR="$DEMO_CONFIG" "$REPO_DIR/install.sh" --uninstall
echo
echo "Demo complete. No user configuration was changed."
