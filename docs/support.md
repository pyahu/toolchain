# Certification and support

Pyahu Toolchain uses **certified** in a narrow, testable sense. At every accepted commit on `main`:

- every stable tool has an exact reviewed version;
- stable lockfiles contain resolution data for Linux x64 and macOS arm64;
- each stable profile installs in strict locked mode on Linux, the complete stable stack does the
  same on macOS, and the rolling AI profile installs separately on both;
- a representative executable from every profile is invoked after installation;
- the global installer's XDG, conflict, dry-run, idempotency, migration, and uninstall behavior is
  tested;
- mise formatting, shell lint, workflow lint, Renovate validation, shim behavior, and generated
  documentation checks pass.

The [current CI result](https://github.com/pyahu/toolchain/actions/workflows/ci.yml) is the evidence
for that contract. A release is made only from a green `main` commit.

Certification does **not** mean that every command or combination of commands has been tested, that
upstream projects are vulnerability-free, or that the toolchain replaces application dependency
locks. npm, pipx, Go, and plugin-based installers may resolve transitive dependencies or execute
upstream installer code. A mise lockfile improves top-level artifact reproducibility where the
backend supports it; it is not an offline or fully hermetic build guarantee.

## Supported platforms

| Platform | Level | What is validated |
| -------- | ----- | ----------------- |
| Linux x64 (`ubuntu-latest`) | Certified | Every profile independently, strict stable locks, global installer, quality suite |
| macOS arm64 (`macos-latest`) | Certified | Complete stable and rolling stack, strict stable locks, representative binaries |
| Other glibc Linux x64 distributions | Best effort | Expected to work when profile OS prerequisites are available; not a release gate |
| Linux arm64 and macOS x64 | Community supported | Contributions welcome; lock artifacts and CI coverage are not currently promised |
| Windows | Unsupported | The POSIX-shell and symlink installer is not designed or tested for native Windows |

The exact OS image behind GitHub's `*-latest` label can change. Consult the green workflow linked
above for the commit you intend to use. The certification baseline uses mise `2026.9.5`; newer mise
versions are expected to remain compatible but become the baseline only after CI is deliberately
updated.

Only the latest Pyahu Toolchain release receives routine fixes. Older tags remain available for
rollback, but fixes are not normally backported.

## Stability contract

Stable profiles (`base`, `workstation`, `java`, `go`, `python`, `node`, `cloud`, and `arch`) use
exact versions. Their project lockfiles additionally record supported artifact URLs and checksums
when the backend provides them. Version changes pass review and the complete release gates.

The `ai` profile is a rolling compatibility channel. Its tools resolve `latest` after a 24-hour
release delay, it has no lockfile, and two clean installs on different days can select different
versions. The profile is installation-tested but intentionally offers no version-reproduction
guarantee. See the [update policy](updates.md) for cadence and emergency changes.

## Compatibility boundaries

- The installer requires Git, a POSIX shell, and mise. Tool downloads generally require HTTPS
  access to GitHub and the relevant language or vendor registries.
- Profile prerequisites are listed in the [profile guide](profiles.md). Docker, cluster access,
  cloud credentials, databases, fonts, and desktop applications are outside this repository.
- Configurations are additive mise environments. Project-level `mise.toml` files can override a
  global selection according to normal mise precedence.
- Global installation intentionally links configuration files but not repository lockfiles, so it
  does not take ownership of a user's global lock. Exact stable pins retain predictable versions.
- The toolchain does not configure shells, editors, Git credentials, Kubernetes contexts, cloud
  accounts, or the tools themselves.

For failure diagnosis and safe recovery, use the [troubleshooting and rollback guide](troubleshooting.md).
