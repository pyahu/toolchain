# Pyahu Toolchain

[![CI](https://github.com/pyahu/toolchain/actions/workflows/ci.yml/badge.svg)](https://github.com/pyahu/toolchain/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/pyahu/toolchain)](https://github.com/pyahu/toolchain/releases/latest)
[![License](https://img.shields.io/github/license/pyahu/toolchain)](LICENSE)

A ready-to-use [mise](https://mise.jdx.dev) setup for developers who work across languages and
cloud tools.

Start with four useful command-line tools, then add only the profiles you need. Stable tools use
reviewed versions, and the same setup is tested on Linux and macOS before each release.

<!-- catalog-summary:start -->
**Current catalog:** 67 tools across 9 profiles.
<!-- catalog-summary:end -->

## Why use it?

- **One tool manager:** mise installs the CLI tools for every profile.
- **Pick your stack:** Java, Go, Python, Node, cloud, AI, and terminal tools are optional.
- **Predictable versions:** stable profiles use exact pins and checked-in lockfiles.
- **Safe setup:** the installer does not replace your existing mise configuration.
- **Easy to leave:** preview every change and uninstall the links at any time.

This is a shared CLI baseline. It does not replace project dependency files, containers, dotfiles,
cloud credentials, or tool-specific configuration.

## Quick start

Install [mise](https://mise.jdx.dev/getting-started.html), then clone the current stable release:

```sh
git clone --branch v1.0.0 --depth 1 \
  https://github.com/pyahu/toolchain.git ~/.config/pyahu-toolchain
cd ~/.config/pyahu-toolchain
```

Choose a few profiles. This example adds terminal, Node, and cloud tools:

```sh
./install.sh workstation node cloud
export MISE_ENV=workstation,node,cloud
mise install
mise exec -- rg --version
```

Add the `MISE_ENV` line printed by the installer to your shell startup file. Follow the mise
[shell activation guide](https://mise.jdx.dev/getting-started.html#activate-mise) to make installed
tools available directly on `PATH`.

Want to see the changes first?

```sh
./install.sh --dry-run workstation node cloud
```

See [Getting started](docs/getting-started.md) for a guided setup, verification, and uninstall.

## Pick only what you need

The base profile is always active. Every other profile is optional and can be combined through
`MISE_ENV`.

| Profile | What it adds | Good starting point for |
| ------- | ------------ | ----------------------- |
| Base | `rg`, `fd`, `jq`, `yq` | Any developer or CI runner |
| `workstation` | Shell navigation, Git clients, TUIs, editor | Daily terminal work |
| `java` | Temurin, Maven, Gradle, Kotlin | JVM projects |
| `go` | Go, linting, debugging, reload, image builds | Go services and CLIs |
| `python` | uv, Ruff, IPython | Python projects and exploration |
| `node` | Node.js, pnpm, Yarn, Bun | JavaScript and TypeScript projects |
| `cloud` | Kubernetes, GitOps, cloud, IaC, database CLIs | Platform and cloud work |
| `ai` | Hosted and local coding agents | Optional AI-assisted workflows |
| `arch` | D2 | Diagrams as code |

Read the [profile guide](docs/profiles.md) for prerequisites and selection notes, or browse the
[complete tool catalog](docs/catalog.md).

## Stable and rolling profiles

Base, workstation, Java, Go, Python, Node, cloud, and architecture tools use exact versions. Their
lockfiles record Linux x64 and macOS arm64 artifacts when the mise backend provides that data.

The `ai` profile is different. Its tools follow recent upstream releases after a short delay, so
two installs on different days may select different versions. It has no lockfile and is kept
outside the stable reproducibility promise.

```sh
./install.sh node ai
export MISE_ENV=node,ai
mise install
```

Node is recommended with AI because Kimi and Pi use it.

## What the installer changes

`install.sh` adds symlinks inside the mise config directory, normally `~/.config/mise`. The base
goes into `conf.d`; selected profiles become `config.<profile>.toml` environment files.

It does not replace `config.toml`. It validates all destinations before writing, respects
`MISE_CONFIG_DIR` and `XDG_CONFIG_HOME`, and refuses unrelated files or links. Use `--force` only
after reviewing the backup behavior in [Getting started](docs/getting-started.md).

Remove links created by this checkout with:

```sh
./install.sh --dry-run --uninstall
./install.sh --uninstall
```

Downloaded tools remain in the mise cache but become inactive.

## Use the base in one project

If you only want the four base tools in a repository, copy both files from the same immutable tag:

```sh
curl -fsSL -o mise.toml https://raw.githubusercontent.com/pyahu/toolchain/v1.0.0/mise.toml
curl -fsSL -o mise.lock https://raw.githubusercontent.com/pyahu/toolchain/v1.0.0/mise.lock
mise install --locked
```

Commit both files to the project. Its local mise configuration can override your global setup.

## Support

Releases are tested on Linux x64 and macOS arm64. Other platforms have different support levels;
Windows is not currently supported. The [support page](docs/support.md) explains exactly what the
CI checks and where the guarantee stops.

If something fails, start with [Troubleshooting](docs/troubleshooting.md). You can also
[report a bug](https://github.com/pyahu/toolchain/issues/new?template=bug.yml),
[suggest a tool](https://github.com/pyahu/toolchain/issues/new?template=tool-proposal.yml), or
[ask a question](https://github.com/pyahu/toolchain/issues/new?template=question.yml).

## Documentation

- [Getting started](docs/getting-started.md)
- [Profiles and prerequisites](docs/profiles.md)
- [Complete tool catalog](docs/catalog.md)
- [Common recipes](docs/recipes.md)
- [Frequently asked questions](docs/faq.md)
- [Troubleshooting and rollback](docs/troubleshooting.md)
- [Releases and upgrades](docs/releases.md)
- [Version and update policy](docs/updates.md)
- [Certification and platform support](docs/support.md)

## Contributing

Contributions are welcome when a tool solves a real gap and fits a clear profile. Read
[CONTRIBUTING.md](CONTRIBUTING.md) before proposing additions or version changes.

The project uses the [MIT License](LICENSE), follows the [Code of Conduct](CODE_OF_CONDUCT.md), and
accepts private security reports through [GitHub Security
Advisories](https://github.com/pyahu/toolchain/security/advisories/new).
