# Pyahu Toolchain

[![CI](https://github.com/pyahu/toolchain/actions/workflows/ci.yml/badge.svg)](https://github.com/pyahu/toolchain/actions/workflows/ci.yml)

The certified developer toolchain for [Pyahu Community](https://pyahu.io), managed by
[mise](https://mise.jdx.dev).

One pinned set of CLI tools defined as a mise config. No Docker image, no manual setup. Tools are
pinned per repo to the **same stable lines on every machine**, so your team's workstations stop
drifting apart.

## Install

```sh
curl https://mise.run | sh
eval "$(mise activate zsh)"   # add to ~/.zshrc. Bash users: mise activate bash, in ~/.bashrc
```

OS-level tools this toolchain doesn't manage (install with your package manager): `git`, `zsh`,
`curl`, `docker`, a Nerd Font, `vim`, `btop`, `kcat` (`brew install btop kcat` /
`apt install btop kcat`).

Wire this repo into your machine. Profiles: `java`, `go`, `python`, `node`, `cloud`, `ai`, `arch`
(pick `node` too if you want `ai`'s Kimi CLI or Pi):

```sh
git clone https://github.com/pyahu/toolchain.git ~/.config/pyahu-toolchain
cd ~/.config/pyahu-toolchain
./install.sh java go python node cloud ai   # pick the profiles you use
```

`install.sh` validates the profiles, then symlinks the base config to your mise global config and
each profile to a mise environment file. It's mise's own config resolution, nothing custom, and it
backs up any real file already at a symlink target (`.bak`, `.bak.1`, ...), so it's safe to re-run.
Export the `MISE_ENV=...` line it prints in your current shell and add it to your shell rc, then
run `mise install`:

```sh
export MISE_ENV=java,go,python,node,cloud,ai
mise install
```

Later, `git pull` in that clone updates the config immediately; run `mise install` again to fetch
anything newly pinned. Anything this machine needs outside the curated set goes in
`~/.config/mise/config.local.toml`, which mise merges in automatically.

Working in someone else's repo instead? Drop the base config as a project file. mise merges it
with your global config, and the closer file wins:

```sh
curl -fsSL -o mise.toml https://raw.githubusercontent.com/pyahu/toolchain/main/mise.toml
mise install
git add mise.toml && git commit -m "chore: pin toolchain with mise"
```

---

## What's in the box

Base is the minimal set (shell, unix utilities, git workflow, editor). Overlays stack on top via
`MISE_ENV`, e.g. `MISE_ENV=java,cloud,ai mise install`.

**Base** (`mise.toml`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| starship | shell prompt | 1.26 |
| fzf | fuzzy finder | 0.74 |
| zoxide | smarter `cd` | 0.10 |
| ripgrep | fast grep (`rg`) | 15 |
| fd | fast `find` | 10 |
| bat | `cat` with syntax highlighting | 0.26 |
| eza | modern `ls` | 0.23 |
| dust | disk usage | 1 |
| glow | markdown in the terminal | 3 |
| yazi | terminal file manager | 26 |
| jq | JSON processor | 1.8 |
| yq | YAML processor | 4 |
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

**AI** (`mise.ai.toml`, `MISE_ENV=ai`), deliberately unpinned since these ship fixes weekly

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| claude-code | Anthropic Claude Code | latest |
| codex | OpenAI Codex CLI | latest |
| opencode | OpenCode | latest |
| kimi-code | Kimi Code CLI, needs Node, stack `MISE_ENV=node,ai` | latest |
| pi-coding-agent | Pi coding agent (`pi`), needs Node, stack `MISE_ENV=node,ai` | latest |

**Architecture** (`mise.arch.toml`, `MISE_ENV=arch`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| d2 | diagrams-as-code | 0.7 |

Not in the mise registry: `structurizr-cli` (C4 models) and `plantuml`. Install them with your OS
package manager if you need them.

---

## Updating

```sh
mise outdated   # see what's behind
mise upgrade    # install the latest version within each pinned line
```

That doesn't change this repo's pins. Pull for those (`git pull` in the clone, or re-curl the
project file). Moving a pin to a new stable line is a PR; see [Contributing](#contributing).

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
