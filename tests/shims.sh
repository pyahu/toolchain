#!/usr/bin/env sh
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM
FAKE_BIN="$TEST_ROOT/bin"
SHIM_LOG="$TEST_ROOT/shims.log"
export SHIM_LOG

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

mkdir -p "$FAKE_BIN"
for command_name in kubectx kubens; do
  # The single-quoted expressions belong to the generated fake executable.
  # shellcheck disable=SC2016
  printf '%s\n' \
    '#!/usr/bin/env sh' \
    'if [ "${1:-}" = --fail ]; then exit 23; fi' \
    'printf "%s:%s\n" "${0##*/}" "$*" >> "$SHIM_LOG"' \
    > "$FAKE_BIN/$command_name"
  chmod +x "$FAKE_BIN/$command_name"
done

PATH="$FAKE_BIN:/usr/bin:/bin" "$REPO_DIR/bin/kubectl-ctx" alpha "two words"
PATH="$FAKE_BIN:/usr/bin:/bin" "$REPO_DIR/bin/kubectl-ns" beta "three words"

grep -Fqx 'kubectx:alpha two words' "$SHIM_LOG" || fail "kubectl-ctx did not forward arguments"
grep -Fqx 'kubens:beta three words' "$SHIM_LOG" || fail "kubectl-ns did not forward arguments"

if PATH="$FAKE_BIN:/usr/bin:/bin" "$REPO_DIR/bin/kubectl-ctx" --fail; then
  fail "kubectl-ctx did not forward the wrapped command's failure"
else
  status=$?
  [ "$status" -eq 23 ] || fail "kubectl-ctx returned $status instead of 23"
fi

echo "All shim tests passed."
