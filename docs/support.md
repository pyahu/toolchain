# Platform support

“Certified” has a narrow meaning here: the project runs a defined set of automated checks on every
accepted change. It is a test level, not a promise that upstream tools have no bugs.

## What CI checks

- Every stable profile installs from exact versions and lock data.
- Every profile runs at least one representative command.
- A complete install runs on Linux x64 and macOS arm64.
- The installer is tested for dry-run, repeat runs, conflicts, backups, migration, and uninstall.
- Configuration, scripts, workflows, generated pages, and documentation examples pass their
  linters and consistency checks.

The [current CI workflow](https://github.com/pyahu/toolchain/actions/workflows/ci.yml) shows the
result for `main`. Releases are created only from a green commit.

## Supported platforms

| Platform | Support | What to expect |
| -------- | ------- | -------------- |
| Linux x64 | Certified | Every profile and the full installer lifecycle run in CI |
| macOS arm64 | Certified | The complete stable and rolling setup runs in CI |
| Other glibc Linux x64 distributions | Best effort | Usually works when OS prerequisites are present |
| Linux arm64 and macOS x64 | Community supported | No committed lock or CI guarantee yet |
| Windows | Unsupported | The installer depends on a POSIX shell and symlinks |

CI currently uses mise `2026.9.5`. A newer mise release may work, but it becomes part of the tested
baseline only when the workflow is updated.

## Stable versus rolling

Base, workstation, Java, Go, Python, Node, cloud, and architecture tools have exact versions.
Lockfiles record artifact URLs and checksums when the backend exposes them.

The AI profile follows recent releases and has no lockfile. It is tested separately for
installation, but its resolved versions can change. See the [update policy](updates.md).

## What is outside the guarantee

- Not every command or combination of tools is tested.
- A lockfile does not make npm, pipx, Go, or plugin installers fully offline or hermetic.
- The project does not configure shells, editors, Git, cloud accounts, clusters, or databases.
- Docker, credentials, fonts, desktop apps, and profile-specific OS packages are not installed.
- Project-level `mise.toml` files can override the global versions.
- Older releases remain available for rollback but do not normally receive fixes.

For setup problems, use [Troubleshooting](troubleshooting.md). Report suspected supply-chain or
installer vulnerabilities through the private process in the
[security policy](https://github.com/pyahu/toolchain/blob/main/SECURITY.md).
