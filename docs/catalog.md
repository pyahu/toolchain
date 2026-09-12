# Tool catalog

This page lists every tool installed by the current configuration. Versions come directly from the
mise files; the page is regenerated from `catalog.toml` and checked in CI.

Use the [profile guide](profiles.md) if you want help choosing profiles or understanding why a tool
is included.

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
