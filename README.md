# Pyahu Toolchain

[![CI](https://github.com/pyahu/toolchain/actions/workflows/ci.yml/badge.svg)](https://github.com/pyahu/toolchain/actions/workflows/ci.yml)

The certified developer toolchain for [Pyahu Community](https://pyahu.io), managed by
[mise](https://mise.jdx.dev).

One pinned set of CLI tools defined as a mise config. No Docker image, no manual setup. Tools are
pinned per repo and resolve to the **same versions on every machine**, so your team's workstations
stop drifting apart.

## Why mise (and not a Docker image)?

This toolchain used to ship as a Docker image. It worked, but a container isolates you from your
own machine: IDEs can't see the tools, credentials and SSH keys need forwarding, Docker-in-Docker
gets awkward, and every tool bump means rebuilding and re-pulling a multi-GB image. With mise the
tools are native binaries on your `PATH`, pinned by a small TOML file that lives in git — you get
the reproducibility of the image without the wall between you and your tools.

---

## Prerequisites

Install mise once (see the [mise install docs](https://mise.jdx.dev/getting-started.html)):

```sh
curl https://mise.run | sh
```

Then activate it in your shell (`~/.zshrc` / `~/.bashrc`):

```sh
eval "$(mise activate zsh)"   # or bash
```

OS-level tools mise does not manage (install with your package manager):
`git`, `zsh`, `curl`, `docker`, a Nerd Font, `vim`, the resource monitor `btop`, and the Kafka
client `kcat` (`brew install btop kcat` / `apt install btop kcat`).

---

## Quick start

```sh
# clone or copy the configs you want, then:
mise install                       # base toolchain (shell, utils, git, editor)
mise install -E java               # add the Java overlay
MISE_ENV=java,cloud mise install   # stack several overlays
```

`mise install` reads the config in the current directory (and parent directories), downloads the
pinned versions, and puts them on your `PATH`. Run `mise ls` to see what is active.

---

## Where to put the config

mise reads config from your **project** and from a **global** location, merging them (closer files
win). Pick what fits:

### Per project (recommended, committed with your repo)

Drop `mise.toml` in your project root. Everyone who clones the repo gets the same tools:

```sh
curl -o mise.toml https://raw.githubusercontent.com/pyahu/toolchain/main/mise.toml
git add mise.toml && git commit -m "chore: pin toolchain with mise"
```

mise also accepts `.mise.toml`, `mise/config.toml`, `.config/mise.toml`, or
`.config/mise/config.toml` in the project. Local, uncommitted overrides go in `mise.local.toml`.

### Global (all your projects)

Put the base config at `~/.config/mise/config.toml` to have these tools everywhere:

```sh
mkdir -p ~/.config/mise
curl -o ~/.config/mise/config.toml https://raw.githubusercontent.com/pyahu/toolchain/main/mise.toml
```

System-wide (all users) lives at `/etc/mise/config.toml`.

### Recommended: global base + per-project overlays

The two combine — mise merges the global config with whatever it finds in the project, and closer
files win. The setup we recommend: put the **base** config in `~/.config/mise/config.toml` so the
everyday tools follow you everywhere, and let each **project** commit its own `mise.toml` pinning
just what it needs (its language overlay, exact runtime versions). `cd` into the project and mise
gives you the union of both.

---

## Profiles (mise environments)

The base `mise.toml` is the minimal set. Language and cloud overlays stack on top via `MISE_ENV`,
which maps to the `mise.<env>.toml` files in this repo:

| Profile  | File               | Activate with                         |
| -------- | ------------------ | ------------------------------------- |
| base     | `mise.toml`        | `mise install`                        |
| java     | `mise.java.toml`   | `MISE_ENV=java mise install`          |
| go       | `mise.go.toml`     | `MISE_ENV=go mise install`            |
| python   | `mise.python.toml` | `MISE_ENV=python mise install`        |
| node     | `mise.node.toml`   | `MISE_ENV=node mise install`          |
| cloud    | `mise.cloud.toml`  | `MISE_ENV=cloud mise install`         |
| ai       | `mise.ai.toml`     | `MISE_ENV=ai mise install`            |
| arch     | `mise.arch.toml`   | `MISE_ENV=arch mise install`          |
| everything | all of the above | `MISE_ENV=java,go,python,node,cloud,ai,arch mise install` |

Copy the overlays you use next to your `mise.toml`. Set `MISE_ENV` in your shell to make a profile
sticky for a project (or use `mise.toml` + `mise install -E <env>`).

---

## What's in the box

**Base** (`mise.toml`)

| Tool | Purpose | Pin |
| ---- | ------- | --- |
| starship | shell prompt | 1.24 |
| fzf | fuzzy finder | 0.67 |
| zoxide | smarter `cd` | 0.9 |
| ripgrep | fast grep (`rg`) | 15 |
| fd | fast `find` | 10 |
| bat | `cat` with syntax highlighting | 0.26 |
| eza | modern `ls` | 0.23 |
| dust | disk usage | 1 |
| glow | markdown in the terminal | 2 |
| yazi | terminal file manager | 25 |
| jq | JSON processor | 1.8 |
| yq | YAML processor | 4 |
| httpie | HTTP client (`http`) | 3.2.4 |
| github-cli | GitHub CLI (`gh`) | 2 |
| delta | better git diffs | 0.18 |
| lazygit | git TUI | 0.58 |
| lazydocker | docker TUI | 0.24 |
| neovim | editor | 0.11 |

**Java & Kotlin** (`mise.java.toml`): Temurin JDK 25, Maven 3, Gradle 8, Kotlin 2 (replaces SDKMAN)

**Go** (`mise.go.toml`): go 1.24, golangci-lint 2, delve (`dlv`), air, ko

**Python** (`mise.python.toml`): uv 0.9, ruff 0.14, ipython 9.14.1

**Node & frontend** (`mise.node.toml`): node 24 (LTS), pnpm 11, yarn 4, bun 1.3 — for Next.js,
Vue, and general TypeScript work

**Cloud, Kubernetes & GitOps** (`mise.cloud.toml`): kubectl 1.35, kubectx, kubens, k9s, kind,
helm 4, telepresence, kustomize 5, argocd 3, flux 2, sops, age, aws-cli 2, doctl, terraform 1.14,
grpcurl, pgcli, mycli

**AI** (`mise.ai.toml`): claude-code, codex, opencode — deliberately unpinned (these ship fixes
weekly)

**Architecture** (`mise.arch.toml`): d2 for diagrams-as-code (structurizr-cli and plantuml are not
in the mise registry — `brew install` them if you need C4 models)

---

## Updating

Pins track current stable lines. To bump them:

```sh
mise outdated   # see what's behind
mise upgrade    # update within the pinned lines
```

---

## Contributing

Want a tool added or a pin moved? See [CONTRIBUTING.md](CONTRIBUTING.md) — the short version:
tools must be in the mise registry, fit an overlay, and earn their place in a *curated* set.
Every PR is validated by CI on Linux and macOS.

---

## License

MIT. See [LICENSE](LICENSE).
