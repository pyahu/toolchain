# Changelog

All notable changes to Pyahu Toolchain are documented here. The project follows [Semantic
Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0-rc.1] - 2026-09-12

### Added

- Nine composable profiles containing 67 curated developer tools.
- Stable lockfiles for Linux x64 and macOS arm64, with a separately documented rolling AI channel.
- Generated tool catalog and profile selection guide.
- Linux and macOS installation gates, executable smoke tests, and installer/shim test suites.
- Certification, support, troubleshooting, governance, and security policies.

### Changed

- Reduced the universal base to four cross-stack primitives and moved terminal preferences into the
  optional `workstation` profile.
- Made global installation additive, XDG-aware, idempotent, conflict-safe, and reversible.
- Pinned stable tools exactly and adopted a seven-day update quarantine.

### Security

- Pinned workflow actions to reviewed commit SHAs and enabled private vulnerability reporting.
- Added strict lock installation where backend artifact metadata supports it.

[Unreleased]: https://github.com/pyahu/toolchain/compare/v1.0.0-rc.1...HEAD
[1.0.0-rc.1]: https://github.com/pyahu/toolchain/releases/tag/v1.0.0-rc.1
