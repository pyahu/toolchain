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

# Validate every profile up front so a typo never leaves a half-applied install.
for profile in "$@"; do
  overlay="$REPO_DIR/mise.$profile.toml"
  if [ ! -f "$overlay" ]; then
    echo "no such profile: $profile (looked for $overlay)" >&2
    exit 1
  fi
done

link() {
  src="$1"
  dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    backup="$dest.bak"
    n=1
    while [ -e "$backup" ]; do
      backup="$dest.bak.$n"
      n=$((n + 1))
    done
    mv "$dest" "$backup"
    echo "backed up existing $dest -> $backup"
  fi
  rm -f "$dest"
  ln -s "$src" "$dest"
  echo "linked $dest -> $src"
}

link "$REPO_DIR/mise.toml" "$MISE_CONFIG_DIR/config.toml"

cloud_installed=0
for profile in "$@"; do
  link "$REPO_DIR/mise.$profile.toml" "$MISE_CONFIG_DIR/config.$profile.toml"

  # The cloud overlay puts $MISE_CONFIG_DIR/bin on PATH for these kubectl plugin
  # shims, so `kubectl ctx` / `kubectl ns` work without a second package manager.
  if [ "$profile" = cloud ]; then
    cloud_installed=1
    mkdir -p "$MISE_CONFIG_DIR/bin"
    link "$REPO_DIR/bin/kubectl-ctx" "$MISE_CONFIG_DIR/bin/kubectl-ctx"
    link "$REPO_DIR/bin/kubectl-ns" "$MISE_CONFIG_DIR/bin/kubectl-ns"
  fi
done

# mise.cloud.toml can only name one path, so it uses mise's default config dir.
if [ "$cloud_installed" = 1 ] && [ "$MISE_CONFIG_DIR" != "$HOME/.config/mise" ]; then
  echo
  echo "note: the cloud overlay adds \$HOME/.config/mise/bin to PATH, but your"
  echo "MISE_CONFIG_DIR is $MISE_CONFIG_DIR — add $MISE_CONFIG_DIR/bin to PATH"
  echo "yourself for 'kubectl ctx' and 'kubectl ns' to resolve."
fi

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
