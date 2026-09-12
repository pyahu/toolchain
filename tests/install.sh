#!/usr/bin/env sh
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_file_contains() {
  file="$1"
  expected="$2"
  [ -f "$file" ] || fail "expected file: $file"
  grep -Fqx "$expected" "$file" || fail "expected '$expected' in $file"
}

assert_link() {
  link="$1"
  target="$2"
  [ -L "$link" ] || fail "expected symlink: $link"
  [ "$(readlink "$link")" = "$target" ] || fail "unexpected target for $link"
}

assert_missing() {
  [ ! -e "$1" ] && [ ! -L "$1" ] || fail "expected missing path: $1"
}

run_installer() {
  test_home="$1"
  shift
  HOME="$test_home" XDG_CONFIG_HOME="$test_home/xdg" MISE_CONFIG_DIR='' \
    "$REPO_DIR/install.sh" "$@"
}

echo "test: XDG install preserves global config and is idempotent"
xdg_home="$TEST_ROOT/xdg-home"
config_dir="$xdg_home/xdg/mise"
mkdir -p "$config_dir"
printf '%s\n' '[env]' 'EXISTING_CONFIG = "yes"' > "$config_dir/config.toml"
run_installer "$xdg_home" java cloud > "$TEST_ROOT/first-install.out"
assert_file_contains "$config_dir/config.toml" 'EXISTING_CONFIG = "yes"'
assert_link "$config_dir/conf.d/pyahu-toolchain.toml" "$REPO_DIR/mise.toml"
assert_link "$config_dir/config.java.toml" "$REPO_DIR/mise.java.toml"
assert_link "$config_dir/config.cloud.toml" "$REPO_DIR/mise.cloud.toml"
assert_missing "$config_dir/bin/kubectl-ctx"
run_installer "$xdg_home" java cloud > "$TEST_ROOT/second-install.out"
grep -Fq 'already linked' "$TEST_ROOT/second-install.out" || fail "expected idempotent output"

echo "test: mise loads the installed base and cloud profile"
loaded_configs=$(
  cd "$TEST_ROOT"
  HOME="$xdg_home" XDG_CONFIG_HOME="$xdg_home/xdg" MISE_CONFIG_DIR='' \
    MISE_ENV=cloud mise config
)
printf '%s\n' "$loaded_configs" | grep -Fq 'conf.d/pyahu-toolchain.toml' || \
  fail "mise did not load the installed base config"
printf '%s\n' "$loaded_configs" | grep -Fq 'config.cloud.toml' || \
  fail "mise did not load the installed cloud profile"
grep -Fq '{{ config_source | canonicalize | dirname }}/bin' "$REPO_DIR/mise.cloud.toml" || \
  fail "cloud profile does not resolve shims relative to its source"

echo "test: dry-run has no filesystem effects"
dry_home="$TEST_ROOT/dry-home"
run_installer "$dry_home" --dry-run java > "$TEST_ROOT/dry-run.out"
assert_missing "$dry_home/xdg/mise"
grep -Fq 'Dry run complete; nothing was changed.' "$TEST_ROOT/dry-run.out" || \
  fail "dry-run summary missing"

echo "test: MISE_CONFIG_DIR takes precedence over XDG_CONFIG_HOME"
override_home="$TEST_ROOT/override-home"
override_dir="$TEST_ROOT/explicit-mise-config"
HOME="$override_home" XDG_CONFIG_HOME="$override_home/xdg" MISE_CONFIG_DIR="$override_dir" \
  "$REPO_DIR/install.sh" java > "$TEST_ROOT/override.out"
assert_link "$override_dir/conf.d/pyahu-toolchain.toml" "$REPO_DIR/mise.toml"
assert_link "$override_dir/config.java.toml" "$REPO_DIR/mise.java.toml"
assert_missing "$override_home/xdg/mise"

echo "test: unknown profiles abort before creating files"
unknown_home="$TEST_ROOT/unknown-home"
if run_installer "$unknown_home" java not-a-profile > "$TEST_ROOT/unknown.out" 2>&1; then
  fail "unknown profile should fail"
fi
assert_missing "$unknown_home/xdg/mise"

echo "test: unrelated symlinks are refused and can be backed up explicitly"
conflict_home="$TEST_ROOT/conflict-home"
conflict_dir="$conflict_home/xdg/mise"
unrelated="$TEST_ROOT/unrelated.toml"
mkdir -p "$conflict_dir/conf.d"
printf '%s\n' 'unrelated config' > "$unrelated"
ln -s "$unrelated" "$conflict_dir/conf.d/pyahu-toolchain.toml"
printf '%s\n' 'older backup' > "$conflict_dir/conf.d/pyahu-toolchain.toml.bak"
if run_installer "$conflict_home" java > "$TEST_ROOT/conflict.out" 2>&1; then
  fail "unrelated symlink should be refused"
fi
assert_link "$conflict_dir/conf.d/pyahu-toolchain.toml" "$unrelated"
assert_missing "$conflict_dir/config.java.toml"
run_installer "$conflict_home" --force java > "$TEST_ROOT/force.out"
assert_link "$conflict_dir/conf.d/pyahu-toolchain.toml" "$REPO_DIR/mise.toml"
assert_link "$conflict_dir/conf.d/pyahu-toolchain.toml.bak.1" "$unrelated"

echo "test: uninstall removes owned links and restores backups"
PATH=/usr/bin:/bin HOME="$conflict_home" XDG_CONFIG_HOME="$conflict_home/xdg" MISE_CONFIG_DIR='' \
  "$REPO_DIR/install.sh" --uninstall > "$TEST_ROOT/uninstall.out"
assert_link "$conflict_dir/conf.d/pyahu-toolchain.toml" "$unrelated"
assert_missing "$conflict_dir/conf.d/pyahu-toolchain.toml.bak.1"
assert_file_contains "$conflict_dir/conf.d/pyahu-toolchain.toml.bak" 'older backup'
assert_missing "$conflict_dir/config.java.toml"

echo "test: legacy links are migrated without losing the original config"
legacy_home="$TEST_ROOT/legacy-home"
legacy_dir="$legacy_home/xdg/mise"
mkdir -p "$legacy_dir/bin"
printf '%s\n' 'original config' > "$legacy_dir/config.toml.bak"
ln -s "$REPO_DIR/mise.toml" "$legacy_dir/config.toml"
ln -s "$REPO_DIR/bin/kubectl-ctx" "$legacy_dir/bin/kubectl-ctx"
ln -s "$REPO_DIR/bin/kubectl-ns" "$legacy_dir/bin/kubectl-ns"
run_installer "$legacy_home" cloud > "$TEST_ROOT/legacy.out"
assert_file_contains "$legacy_dir/config.toml" 'original config'
assert_missing "$legacy_dir/config.toml.bak"
assert_missing "$legacy_dir/bin/kubectl-ctx"
assert_missing "$legacy_dir/bin/kubectl-ns"
assert_link "$legacy_dir/conf.d/pyahu-toolchain.toml" "$REPO_DIR/mise.toml"

echo "All installer tests passed."
