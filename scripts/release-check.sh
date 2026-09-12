#!/usr/bin/env sh
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="$(sed -n '1p' "$REPO_DIR/VERSION")"
TAG="v$VERSION"

printf '%s\n' "$VERSION" | grep -Eq \
  '^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$' || {
  echo "VERSION is not a semantic version: $VERSION" >&2
  exit 1
}

grep -Fq "## [$VERSION]" "$REPO_DIR/CHANGELOG.md" || {
  echo "CHANGELOG.md has no release heading for $VERSION" >&2
  exit 1
}
grep -Fq "$TAG" "$REPO_DIR/README.md" || {
  echo "README.md has no versioned installation example for $TAG" >&2
  exit 1
}

for profile in base workstation java go python node cloud arch; do
  if [ "$profile" = base ]; then
    lock="$REPO_DIR/mise.lock"
  else
    lock="$REPO_DIR/mise.$profile.lock"
  fi
  [ -f "$lock" ] || {
    echo "missing stable lockfile: $lock" >&2
    exit 1
  }
  grep -Fq 'linux-x64' "$lock" || {
    echo "missing linux-x64 resolution in $lock" >&2
    exit 1
  }
  grep -Fq 'macos-arm64' "$lock" || {
    echo "missing macos-arm64 resolution in $lock" >&2
    exit 1
  }
done

if [ -e "$REPO_DIR/mise.ai.lock" ]; then
  echo "mise.ai.lock must not exist: AI is a rolling profile" >&2
  exit 1
fi

cd "$REPO_DIR"
./scripts/catalog.py --check
mise fmt --check
git diff --check
echo "Release metadata is consistent for $TAG."
