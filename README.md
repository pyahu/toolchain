# Pyahu Toolchain

[![CI](https://github.com/pyahu/toolchain/actions/workflows/ci.yml/badge.svg)](https://github.com/pyahu/toolchain/actions/workflows/ci.yml)

The certified developer toolchain for [Pyahu Community](https://pyahu.io), managed by
[mise](https://mise.jdx.dev).

A curated, composable set of CLI tools defined as mise configs. No development container and no
language-specific version-manager stack. A small cross-stack baseline stays out of your way;
workflow profiles add only the toolchains you choose. Committed lockfiles keep stable profiles on
the same resolved versions across supported machines.

“Certified” means the declared versions install and representative commands run through a defined
release gate on Linux x64 and macOS arm64. Read the [certification and support
contract](docs/support.md) for the precise guarantee, exclusions, and platform matrix; use the
[troubleshooting guide](docs/troubleshooting.md) for diagnosis and rollback.

## Install

```sh
curl https://mise.run | sh
eval "$(mise activate zsh)"   # add to ~/.zshrc. Bash users: mise activate bash, in ~/.bashrc
```

The installer needs `git`, `curl`, and a POSIX shell. Individual profiles can have additional
prerequisites; see the [Profile guide](docs/profiles.md).

Wire this repo into your machine. Profiles: `workstation`, `java`, `go`, `python`, `node`, `cloud`,
`ai`, `arch` (pick `node` too if you want `ai`'s Kimi CLI or Pi):

```sh
git clone https://github.com/pyahu/toolchain.git ~/.config/pyahu-toolchain
cd ~/.config/pyahu-toolchain
./install.sh workstation java go python node cloud   # pick the profiles you use
```

`install.sh` validates every destination first, then adds the base config as an isolated mise
`conf.d` fragment and each profile as a mise environment file. Your existing global `config.toml`
is never replaced. The installer respects `MISE_CONFIG_DIR` and `XDG_CONFIG_HOME`, refuses to
replace unrelated files or symlinks, and is safe to re-run. Export the `MISE_ENV=...` line it
prints in your current shell and add it to your shell rc, then run `mise install`:

```sh
export MISE_ENV=workstation,java,go,python,node,cloud
mise install
```

Global profile files use exact versions and intentionally do not install a global lockfile, which
could collide with locks owned by the user's own mise configuration. The committed locks are for
project checkouts and CI, where `mise install --locked` verifies the resolved artifacts.

The `ai` profile is deliberately rolling and has no lockfile. Add it with `./install.sh ai`, include
`ai` in `MISE_ENV`, and use plain `mise install` when you want those fast-moving tools.

Preview the filesystem changes with `./install.sh --dry-run java go`. If a destination reserved by
this toolchain already exists, move it yourself or pass `--force` to preserve it as `.bak` before
linking. `./install.sh --uninstall` removes only links that point into the current checkout and
restores backups created by the installer. Re-running the installer also migrates links created by
older releases: it restores the original global config from `.bak` and moves the base toolchain to
its isolated `conf.d` fragment.

Later, `git pull` in that clone updates the config immediately; run `mise install` again to fetch
anything newly pinned. Anything this machine needs outside the curated set goes in the mise config
directory's `config.local.toml` (usually `~/.config/mise/config.local.toml`), which mise merges in
automatically.

Working in someone else's repo instead? Drop the base config as a project file. mise merges it
with your global config, and the closer file wins:

```sh
curl -fsSL -o mise.toml https://raw.githubusercontent.com/pyahu/toolchain/main/mise.toml
curl -fsSL -o mise.lock https://raw.githubusercontent.com/pyahu/toolchain/main/mise.lock
mise install --locked
git add mise.toml mise.lock && git commit -m "chore: pin toolchain with mise"
```

---

## What's in the box

Base is a four-tool, non-opinionated foundation. Overlays stack on top via `MISE_ENV`, e.g.
`MISE_ENV=workstation,java,cloud mise install`. See the [Profile guide](docs/profiles.md) for the
audience, dependencies, and selection rationale behind every profile.
The tables below are generated from `catalog.toml` and the live mise configurations; CI rejects
stale names, purposes, dependencies, or versions.

<!-- catalog:start -->
**Base** (`mise.toml`, always active)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| ripgrep | fast grep (`rg`) | 15.2.0 |
| fd | fast `find` | 10.5.0 |
| jq | JSON processor | 1.8.2 |
| yq | YAML processor | 4.53.6 |

**Terminal workstation** (`mise.workstation.toml`, `MISE_ENV=workstation`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| starship | shell prompt | 1.26.0 |
| fzf | fuzzy finder | 0.74.3 |
| zoxide | smarter `cd` | 0.10.0 |
| bat | `cat` with syntax highlighting | 0.26.1 |
| eza | modern `ls` | 0.23.5 |
| dust | disk usage | 1.2.5 |
| glow | Markdown in the terminal | 3.0.0 |
| yazi | terminal file manager | 26.9.1 |
| HTTPie | HTTP client (`http`) | 3.2.4 |
| GitHub CLI | GitHub CLI (`gh`) | 2.100.0 |
| GitLab CLI | GitLab CLI (`glab`) | 1.116.0 |
| Linear CLI | Linear issue tracker CLI (`linear`) | 2.6.0 |
| delta | better Git diffs | 0.19.2 |
| lazygit | Git TUI | 0.65.0 |
| lazydocker | Docker TUI | 0.25.2 |
| mprocs | run and monitor multiple processes | 0.9.6 |
| tmux | terminal multiplexer | 3.7c |
| Neovim | terminal editor | 0.12.5 |

**Java and Kotlin** (`mise.java.toml`, `MISE_ENV=java`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| Temurin JDK | OpenJDK distribution | temurin-25.0.4+101.0.LTS |
| Maven | JVM build tool | 3.9.16 |
| Gradle | JVM build tool | 9.7.1 |
| Kotlin | Kotlin compiler and REPL | 2.4.10 |

**Go** (`mise.go.toml`, `MISE_ENV=go`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| Go | Go toolchain | 1.27.1 |
| golangci-lint | Go linter runner | 2.13.2 |
| Delve | Go debugger (`dlv`) | 1.27.1 |
| Air | Go live reload | 1.67.4 |
| ko | container images for Go | 0.19.1 |

**Python** (`mise.python.toml`, `MISE_ENV=python`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| uv | Python package and environment manager | 0.12.10 |
| Ruff | Python linter and formatter | 0.16.6 |
| IPython | Python REPL | 9.17.1 |

**Node and frontend** (`mise.node.toml`, `MISE_ENV=node`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| Node.js | JavaScript runtime | 24.20.0 |
| pnpm | JavaScript package manager | 11.25.0 |
| Yarn | JavaScript package manager | 4.18.0 |
| Bun | JavaScript runtime and bundler | 1.4.2 |

**Cloud, Kubernetes, and GitOps** (`mise.cloud.toml`, `MISE_ENV=cloud`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| kubectl | Kubernetes CLI | 1.37.0 |
| kubectx | switch Kubernetes contexts; also `kubectl ctx` | 0.11.0 |
| kubens | switch Kubernetes namespaces; also `kubectl ns` | 0.11.0 |
| k9s | Kubernetes TUI | 0.51.0 |
| kind | upstream Kubernetes clusters in Docker | 0.33.0 |
| k3d | k3s clusters in Docker | 5.9.0 |
| Helm | Kubernetes package manager | 4.2.4 |
| Telepresence | local-to-cluster development | 2.31.2 |
| Kustomize | Kubernetes configuration overlays | 5.8.1 |
| Argo CD CLI | Argo CD GitOps client | 3.5.2 |
| Flux CLI | Flux GitOps client | 2.9.5 |
| SOPS | structured secrets encryption | 3.13.3 |
| age | encryption tool | 1.3.2 |
| AWS CLI | AWS cloud client | 2.36.44 |
| doctl | DigitalOcean cloud client | 1.168.0 |
| hcloud | Hetzner Cloud client | 1.67.0 |
| Terraform | infrastructure as code | 1.16.2 |
| OCI CLI | Oracle Cloud client (`oci`) | 3.92.1 |
| grpcurl | gRPC client | 1.9.4 |
| pgcli | PostgreSQL interactive client | 4.6.0 |
| mycli | MySQL interactive client | 2.23.0 |
| Pyahu CLI | local development stack (`pyahu up`) | 0.10.1 |

**AI** (`mise.ai.toml`, `MISE_ENV=ai`, rolling)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| Claude Code | Anthropic coding agent | latest |
| Codex CLI | OpenAI coding agent | latest |
| OpenCode | provider-flexible coding agent | latest |
| Ollama | local model runtime | latest |
| Kimi Code | coding agent (`kimi`); add `node` | latest |
| Pi coding agent | extensible coding agent (`pi`); add `node` | latest |

**Architecture** (`mise.arch.toml`, `MISE_ENV=arch`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| D2 | diagrams as code | v0.9.0 |
<!-- catalog:end -->

---

## Updating

```sh
mise outdated   # compare the exact stable pins with available releases
```

Stable versions move only through reviewed changes. Renovate proposes exact pin updates after a
seven-day waiting period and refreshes locks weekly; maintainers can run
`./scripts/update-locks.sh` after editing a pin. Pull those updates with `git pull` in the clone, or
re-download both the project TOML and lockfile. See the [version and update
policy](docs/updates.md) for the rolling AI exception and emergency security updates.

---

## Contributing

Want a tool added or a pin moved? See [CONTRIBUTING.md](CONTRIBUTING.md). The short version:
tools must be in the mise registry, fit an overlay, and earn their place in a *curated* set.
Every PR is validated by CI on Linux and macOS.

Participation is governed by the [Code of Conduct](CODE_OF_CONDUCT.md). See
[MAINTAINERS.md](MAINTAINERS.md) for ownership and response targets, and report vulnerabilities
privately according to [SECURITY.md](SECURITY.md).

---

## Why mise

Pyahu Toolchain keeps developer CLIs native on `PATH` while sharing reviewed versions across
repositories and machines. It complements, rather than eliminates, the other common approaches:

| Approach | Best at | Trade-off relative to Pyahu Toolchain |
| -------- | ------- | ------------------------------------- |
| Pyahu Toolchain + mise | One composable, cross-language CLI baseline | Does not isolate the host OS or application services |
| Personal dotfiles | Individual shell and application preferences | Usually person-specific; Pyahu supplies a shared, tested catalog without owning dotfiles |
| Dev containers | Reproducible OS libraries, services, and isolation | Image rebuilds and editor/container integration add weight; use them when OS isolation matters |
| asdf | Extensible multi-language version management | Similar plugin model; this project standardizes on mise's TOML environments, locks, and task-free native workflow |
| Language-specific managers | Deep ecosystem-native behavior | Multiple managers and config formats are needed for a polyglot stack |

Containers still earn their place for isolated services and OS-level dependencies. Dotfiles remain
the right home for personal preferences. This repository owns only the shared CLI contract.

---

## License

MIT. See [LICENSE](LICENSE).
