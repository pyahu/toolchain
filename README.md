# Pyahu Toolchain

[![CI](https://github.com/pyahu/toolchain/actions/workflows/ci.yml/badge.svg)](https://github.com/pyahu/toolchain/actions/workflows/ci.yml)

The certified developer toolchain for [Pyahu Community](https://pyahu.io), managed by
[mise](https://mise.jdx.dev).

A curated, composable set of CLI tools defined as mise configs. No development container and no
language-specific version-manager stack. A small cross-stack baseline stays out of your way;
workflow profiles add only the toolchains you choose. Committed lockfiles keep stable profiles on
the same resolved versions across supported machines.

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

**Base** (`mise.toml`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| ripgrep | fast grep (`rg`) | 15 |
| fd | fast `find` | 10 |
| jq | JSON processor | 1.8 |
| yq | YAML processor | 4 |

**Terminal workstation** (`mise.workstation.toml`, `MISE_ENV=workstation`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| starship | shell prompt | 1.26 |
| fzf | fuzzy finder | 0.74 |
| zoxide | smarter `cd` | 0.10 |
| bat | `cat` with syntax highlighting | 0.26 |
| eza | modern `ls` | 0.23 |
| dust | disk usage | 1 |
| glow | markdown in the terminal | 3 |
| yazi | terminal file manager | 26 |
| httpie | HTTP client (`http`) | 3.2.4 |
| github-cli | GitHub CLI (`gh`) | 2 |
| glab | GitLab CLI | 1 |
| linear-cli | Linear issue tracker CLI (`linear`) | 2.5.0 |
| delta | better git diffs | 0.19 |
| lazygit | git TUI | 0.64 |
| lazydocker | docker TUI | 0.25 |
| mprocs | run/monitor multiple processes | 0.9 |
| tmux | terminal multiplexer | 3 |
| neovim | editor | 0.12 |

**Java & Kotlin** (`mise.java.toml`, `MISE_ENV=java`), replaces SDKMAN

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| java | Temurin JDK | 25 |
| maven | build tool | 3 |
| gradle | build tool | 9 |
| kotlin | Kotlin compiler | 2 |

**Go** (`mise.go.toml`, `MISE_ENV=go`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| go | Go toolchain | 1.27 |
| golangci-lint | linter | 2 |
| dlv | debugger | 1.27 |
| air | live reload | 1 |
| ko | container images for Go | 0.19 |

**Python** (`mise.python.toml`, `MISE_ENV=python`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| uv | package & venv manager | 0.12 |
| ruff | linter & formatter | 0.16 |
| ipython | REPL | 9.16.1 |

**Node & frontend** (`mise.node.toml`, `MISE_ENV=node`), for Next.js, Vue, and general TypeScript
work

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| node | JS runtime (Active LTS) | 24 |
| pnpm | package manager | 11 |
| yarn | package manager | 4 |
| bun | JS runtime & bundler | 1.4 |

**Cloud, Kubernetes & GitOps** (`mise.cloud.toml`, `MISE_ENV=cloud`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| kubectl | Kubernetes CLI | 1.36 |
| kubectx | switch Kubernetes contexts, also `kubectl ctx` | 0.11 |
| kubens | switch Kubernetes namespaces, also `kubectl ns` | 0.11 |
| k9s | Kubernetes TUI | 0.51 |
| kind | local Kubernetes clusters | 0.32 |
| k3d | local Kubernetes clusters (k3s in Docker) | 5.9 |
| helm | Kubernetes package manager | 4 |
| telepresence | local-to-cluster dev | 2 |
| kustomize | Kubernetes config overlays | 5 |
| argocd | GitOps CLI (ArgoCD) | 3 |
| flux2 | GitOps CLI (Flux) | 2 |
| sops | secrets encryption | 3 |
| age | encryption tool | 1 |
| awscli | AWS CLI | 2 |
| doctl | DigitalOcean CLI | 1 |
| hcloud | Hetzner Cloud CLI | 1 |
| oci-cli | Oracle Cloud CLI (`oci`) | 3.91.0 |
| terraform | infrastructure as code | 1.15 |
| grpcurl | gRPC client | 1.9 |
| pgcli | Postgres CLI | 4.5.0 |
| mycli | MySQL CLI | 2.15.0 |
| pyahu | Pyahu CLI — local dev stack on k3d (`pyahu up`) | 0.8.0 |

**AI** (`mise.ai.toml`, `MISE_ENV=ai`), deliberately unpinned since these ship fixes weekly

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| claude-code | Anthropic Claude Code | latest |
| codex | OpenAI Codex CLI | latest |
| opencode | OpenCode | latest |
| ollama | local model runtime, `ollama serve` + `ollama run` | latest |
| kimi-code | Kimi Code CLI, needs Node, stack `MISE_ENV=node,ai` | latest |
| pi-coding-agent | Pi coding agent (`pi`), needs Node, stack `MISE_ENV=node,ai` | latest |

Not installable by mise: `obsidian` (Obsidian CLI, the vault from the terminal — useful to give an
agent a place to read and write notes). It ships inside the Obsidian desktop app since 1.12, so
mise can't manage it: install Obsidian 1.12.7+ with the official installer, enable
Settings → General → "Command line interface", and register it on your `PATH` when prompted. It
talks to the running app over IPC, so Obsidian has to be open.

**Architecture** (`mise.arch.toml`, `MISE_ENV=arch`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| d2 | diagrams-as-code | 0.7 |

Not in the mise registry: `structurizr-cli` (C4 models) and `plantuml`. Install them with your OS
package manager if you need them.

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

---

## Why mise

mise keeps developer CLIs native on your `PATH`, pinned by small TOML files in git. No rebuilding
a container image for every tool bump, no IDE cut off from your toolchain. Unlike per-language
version managers (asdf, nvm, pyenv, rbenv, SDKMAN), it's one tool and one config format instead of
one per language. Containers still earn their keep for isolated services and OS-level deps.

---

## License

MIT. See [LICENSE](LICENSE).
