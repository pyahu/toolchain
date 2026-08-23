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
eval "$(mise activate zsh)"   # add to ~/.zshrc — bash users: mise activate bash, in ~/.bashrc
```

OS-level tools this toolchain doesn't manage (install with your package manager): `git`, `zsh`,
`curl`, `docker`, a Nerd Font, `vim`, `btop`, `kcat` (`brew install btop kcat` /
`apt install btop kcat`).

Wire this repo into your machine — profiles: `java`, `go`, `python`, `node`, `cloud`, `ai`, `arch`
(pick `node` too if you want `ai`'s Kimi CLI):

```sh
git clone https://github.com/pyahu/toolchain.git ~/.config/pyahu-toolchain
cd ~/.config/pyahu-toolchain
./install.sh java go python node cloud ai   # pick the profiles you use
```

`install.sh` validates the profiles, then symlinks the base config to your mise global config and
each profile to a mise environment file — mise's own config resolution, nothing custom. It backs
up any real file already at a symlink target (`.bak`, `.bak.1`, ...), so it's safe to re-run.
Export the `MISE_ENV=...` line it prints in your current shell and add it to your shell rc, then
run `mise install`:

```sh
export MISE_ENV=java,go,python,node,cloud,ai
mise install
```

Later, `git pull` in that clone updates the config immediately; run `mise install` again to fetch
anything newly pinned. Anything this machine needs outside the curated set goes in
`~/.config/mise/config.local.toml`, which mise merges in automatically.

Working in someone else's repo instead? Drop the base config as a project file — mise merges it
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
| delta | better git diffs | 0.19 |
| lazygit | git TUI | 0.64 |
| lazydocker | docker TUI | 0.25 |
| mprocs | run/monitor multiple processes | 0.9 |
| neovim | editor | 0.12 |

**Java & Kotlin** (`mise.java.toml`, `MISE_ENV=java`): Temurin JDK 25, Maven 3, Gradle 9, Kotlin 2
(replaces SDKMAN)

**Go** (`mise.go.toml`, `MISE_ENV=go`): go 1.27, golangci-lint 2, delve (`dlv`), air, ko

**Python** (`mise.python.toml`, `MISE_ENV=python`): uv 0.12, ruff 0.16, ipython 9.16.1

**Node & frontend** (`mise.node.toml`, `MISE_ENV=node`): node 24 (LTS), pnpm 11, yarn 4, bun 1.4 —
for Next.js, Vue, and general TypeScript work

**Cloud, Kubernetes & GitOps** (`mise.cloud.toml`, `MISE_ENV=cloud`): kubectl 1.36, kubectx,
kubens, k9s, kind, helm 4, telepresence, kustomize 5, argocd 3, flux 2, sops, age, aws-cli 2,
doctl, terraform 1.15, grpcurl, pgcli, mycli

**AI** (`mise.ai.toml`, `MISE_ENV=ai`): claude-code, codex, opencode, kimi-code — deliberately
unpinned (these ship fixes weekly). kimi-code needs Node on `PATH`: activate it with
`MISE_ENV=node,ai`

**Architecture** (`mise.arch.toml`, `MISE_ENV=arch`): d2 for diagrams-as-code (structurizr-cli and
plantuml are not in the mise registry — `brew install` them if you need C4 models)

---

## Updating

```sh
mise outdated   # see what's behind
mise upgrade    # install the latest version within each pinned line
```

That doesn't change this repo's pins — pull for those (`git pull` in the clone, or re-curl the
project file). Moving a pin to a new stable line is a PR; see [Contributing](#contributing).

---

## Contributing

Want a tool added or a pin moved? See [CONTRIBUTING.md](CONTRIBUTING.md) — the short version:
tools must be in the mise registry, fit an overlay, and earn their place in a *curated* set.
Every PR is validated by CI on Linux and macOS.

---

## Why mise

mise keeps developer CLIs native on your `PATH`, pinned by small TOML files in git — no rebuilding
a container image for every tool bump, no IDE cut off from your toolchain. Unlike per-language
version managers (asdf, nvm, pyenv, rbenv, SDKMAN), it's one tool and one config format instead of
one per language. Containers still earn their keep for isolated services and OS-level deps.

---

## License

MIT. See [LICENSE](LICENSE).
