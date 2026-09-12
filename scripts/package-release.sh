#!/usr/bin/env sh
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="$(sed -n '1p' "$REPO_DIR/VERSION")"
TAG="v$VERSION"
OUTPUT_DIR="${1:-$REPO_DIR/dist}"
ARCHIVE="$OUTPUT_DIR/pyahu-toolchain-$VERSION.tar.gz"
CHECKSUM="$ARCHIVE.sha256"

git -C "$REPO_DIR" rev-parse --verify "$TAG^{commit}" >/dev/null 2>&1 || {
  echo "release tag does not exist: $TAG" >&2
  exit 1
}
[ ! -e "$ARCHIVE" ] && [ ! -e "$CHECKSUM" ] || {
  echo "refusing to replace an existing release artifact in $OUTPUT_DIR" >&2
  exit 1
}

mkdir -p "$OUTPUT_DIR"
git -C "$REPO_DIR" archive --format=tar.gz \
  --prefix="pyahu-toolchain-$VERSION/" --output="$ARCHIVE" "$TAG"
(
  cd "$OUTPUT_DIR"
  shasum -a 256 "$(basename "$ARCHIVE")" > "$(basename "$CHECKSUM")"
  shasum -a 256 -c "$(basename "$CHECKSUM")"
)
tar -tzf "$ARCHIVE" >/dev/null

echo "Created $ARCHIVE"
echo "Created $CHECKSUM"
