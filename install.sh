#!/usr/bin/env sh
# Pyahu Toolchain installer.
#
# Installs the base config as a mise conf.d fragment and optional profiles as
# mise environment files. Existing user configuration is left in place.
#
# Usage:
#   ./install.sh [--dry-run] [--force] [profile ...]
#   ./install.sh --uninstall [--dry-run]
set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="${MISE_CONFIG_DIR:-$DEFAULT_CONFIG_HOME/mise}"
DRY_RUN=0
FORCE=0
UNINSTALL=0

usage() {
  cat <<'EOF'
Usage:
  ./install.sh [--dry-run] [--force] [profile ...]
  ./install.sh --uninstall [--dry-run]

Options:
  --dry-run    Print the changes without applying them.
  --force      Back up and replace conflicting Pyahu destinations.
  --uninstall  Remove links owned by this checkout and restore backups.
  -h, --help   Show this help.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --uninstall)
      UNINSTALL=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [ "$UNINSTALL" = 1 ] && [ "$FORCE" = 1 ]; then
  echo "--force cannot be combined with --uninstall" >&2
  exit 1
fi

if [ "$UNINSTALL" = 1 ] && [ "$#" -gt 0 ]; then
  echo "--uninstall does not accept profiles; it removes every link owned by this checkout" >&2
  exit 1
fi

is_path() {
  [ -e "$1" ] || [ -L "$1" ]
}

is_managed_link() {
  [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]
}

next_backup() {
  candidate="$1.bak"
  number=1
  while is_path "$candidate"; do
    candidate="$1.bak.$number"
    number=$((number + 1))
  done
  printf '%s\n' "$candidate"
}

check_destination() {
  src="$1"
  dest="$2"

  if ! is_path "$dest" || is_managed_link "$src" "$dest" || [ "$FORCE" = 1 ]; then
    return 0
  fi

  echo "refusing to replace existing path: $dest" >&2
  if [ -L "$dest" ]; then
    echo "it is a symlink to: $(readlink "$dest")" >&2
  fi
  echo "move it yourself or re-run with --force to back it up first" >&2
  return 1
}

install_link() {
  src="$1"
  dest="$2"

  if is_managed_link "$src" "$dest"; then
    echo "already linked $dest -> $src"
    return
  fi

  if is_path "$dest"; then
    backup="$(next_backup "$dest")"
    if [ "$DRY_RUN" = 1 ]; then
      echo "would back up $dest -> $backup"
    else
      mv "$dest" "$backup"
      echo "backed up $dest -> $backup"
    fi
  fi

  if [ "$DRY_RUN" = 1 ]; then
    echo "would link $dest -> $src"
  else
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "linked $dest -> $src"
  fi
}

restore_backup() {
  dest="$1"
  backup="$dest.bak"

  if ! is_path "$backup"; then
    return
  fi

  number=1
  while is_path "$dest.bak.$number"; do
    backup="$dest.bak.$number"
    number=$((number + 1))
  done

  if [ "$DRY_RUN" = 1 ]; then
    echo "would restore $backup -> $dest"
  else
    mv "$backup" "$dest"
    echo "restored $backup -> $dest"
  fi
}

remove_managed_link() {
  src="$1"
  dest="$2"

  if ! is_managed_link "$src" "$dest"; then
    if is_path "$dest"; then
      echo "left unrelated path untouched: $dest"
    fi
    return
  fi

  if [ "$DRY_RUN" = 1 ]; then
    echo "would remove $dest"
  else
    rm "$dest"
    echo "removed $dest"
  fi
  restore_backup "$dest"
}

remove_empty_dir() {
  dir="$1"
  [ -d "$dir" ] || return 0

  if [ "$DRY_RUN" = 1 ]; then
    if [ -z "$(find "$dir" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
      echo "would remove empty directory $dir"
    fi
  else
    rmdir "$dir" 2>/dev/null || true
  fi
}

uninstall() {
  remove_managed_link "$REPO_DIR/mise.toml" "$CONFIG_DIR/conf.d/pyahu-toolchain.toml"

  for overlay in "$REPO_DIR"/mise.*.toml; do
    [ -f "$overlay" ] || continue
    profile=${overlay##*/mise.}
    profile=${profile%.toml}
    remove_managed_link "$overlay" "$CONFIG_DIR/config.$profile.toml"
  done

  # Clean up destinations used by installer versions before the conf.d layout.
  remove_managed_link "$REPO_DIR/mise.toml" "$CONFIG_DIR/config.toml"
  remove_managed_link "$REPO_DIR/bin/kubectl-ctx" "$CONFIG_DIR/bin/kubectl-ctx"
  remove_managed_link "$REPO_DIR/bin/kubectl-ns" "$CONFIG_DIR/bin/kubectl-ns"
  remove_empty_dir "$CONFIG_DIR/conf.d"
  remove_empty_dir "$CONFIG_DIR/bin"

  echo
  if [ "$DRY_RUN" = 1 ]; then
    echo "Dry run complete; nothing was changed."
  else
    echo "Pyahu Toolchain links owned by this checkout were removed."
  fi
}

if [ "$UNINSTALL" = 1 ]; then
  uninstall
  exit 0
fi

if ! command -v mise >/dev/null 2>&1; then
  echo "mise not found. Install it first: https://mise.jdx.dev/getting-started.html" >&2
  exit 1
fi

# Validate every profile and destination before applying any change, so an
# error cannot leave a partially installed configuration.
for profile in "$@"; do
  overlay="$REPO_DIR/mise.$profile.toml"
  if [ ! -f "$overlay" ]; then
    echo "no such profile: $profile (looked for $overlay)" >&2
    exit 1
  fi
done

check_destination "$REPO_DIR/mise.toml" "$CONFIG_DIR/conf.d/pyahu-toolchain.toml"
for profile in "$@"; do
  check_destination "$REPO_DIR/mise.$profile.toml" "$CONFIG_DIR/config.$profile.toml"
done

install_link "$REPO_DIR/mise.toml" "$CONFIG_DIR/conf.d/pyahu-toolchain.toml"
for profile in "$@"; do
  install_link "$REPO_DIR/mise.$profile.toml" "$CONFIG_DIR/config.$profile.toml"
done

# Migrate links created by older releases only when they point into this exact
# checkout. Any displaced config is restored from the original .bak file.
remove_managed_link "$REPO_DIR/mise.toml" "$CONFIG_DIR/config.toml"
remove_managed_link "$REPO_DIR/bin/kubectl-ctx" "$CONFIG_DIR/bin/kubectl-ctx"
remove_managed_link "$REPO_DIR/bin/kubectl-ns" "$CONFIG_DIR/bin/kubectl-ns"
remove_empty_dir "$CONFIG_DIR/bin"

echo
if [ "$#" -gt 0 ]; then
  joined=$(IFS=,; echo "$*")
  echo "Add this to your shell rc to make the profiles sticky:"
  echo "  export MISE_ENV=$joined"
  echo
fi
echo "Tools this machine needs that are not part of the curated set go in:"
echo "  $CONFIG_DIR/config.local.toml"
echo "(mise merges it automatically; it is outside this repo and is never committed here)"
echo
if [ "$DRY_RUN" = 1 ]; then
  echo "Dry run complete; nothing was changed."
else
  echo "Run 'mise install' to fetch everything."
fi
