#!/usr/bin/env sh
# Pyahu Toolchain installer.
#
# Wires this repo into mise's own config resolution instead of inventing a new
# mechanism: the base config becomes your mise global config, and each profile
# you pass becomes a mise environment file, picked up automatically whenever
# MISE_ENV includes that profile.
#
# Usage:
#   ./install.sh                       # base only
#   ./install.sh java go cloud ai      # base + these profiles
#
# Safe to re-run: it only touches the symlinks it manages, and backs up any
# real file it would overwrite.
set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
MISE_CONFIG_DIR="${MISE_CONFIG_DIR:-$HOME/.config/mise}"

if ! command -v mise >/dev/null 2>&1; then
  echo "mise not found. Install it first: curl https://mise.run | sh" >&2
  exit 1
fi

mkdir -p "$MISE_CONFIG_DIR"

link() {
  src="$1"
  dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "backed up existing $dest -> $dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "linked $dest -> $src"
}

link "$REPO_DIR/mise.toml" "$MISE_CONFIG_DIR/config.toml"

for profile in "$@"; do
  overlay="$REPO_DIR/mise.$profile.toml"
  if [ ! -f "$overlay" ]; then
    echo "no such profile: $profile (looked for $overlay)" >&2
    exit 1
  fi
  link "$overlay" "$MISE_CONFIG_DIR/config.$profile.toml"
done

echo
if [ "$#" -gt 0 ]; then
  joined=$(IFS=,; echo "$*")
  echo "Add this to your shell rc to make the profiles sticky:"
  echo "  export MISE_ENV=$joined"
  echo
fi
echo "Tools this machine needs that aren't part of the curated set go in:"
echo "  $MISE_CONFIG_DIR/config.local.toml"
echo "(mise merges it automatically; it's outside this repo so it's never committed here)"
echo
echo "Run 'mise install' to fetch everything."
