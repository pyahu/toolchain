# Tool catalog

This page lists every tool installed by the current configuration. On GitHub, version links point
to the exact pins in the mise files; the website renders their current values during each build.
Tool metadata comes from `catalog.toml` and is checked in CI.

Use the [profile guide](profiles.md) if you want help choosing profiles or understanding why a tool
is included.

<!-- catalog:start -->
**Base** (`mise.toml`, always active)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| ripgrep | fast grep (`rg`) | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.toml) |
| fd | fast `find` | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.toml) |
| jq | JSON processor | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.toml) |
| yq | YAML processor | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.toml) |

**Terminal workstation** (`mise.workstation.toml`, `MISE_ENV=workstation`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| starship | shell prompt | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| fzf | fuzzy finder | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| zoxide | smarter `cd` | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| bat | `cat` with syntax highlighting | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| eza | modern `ls` | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| dust | disk usage | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| glow | Markdown in the terminal | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| yazi | terminal file manager | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| HTTPie | HTTP client (`http`) | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| GitHub CLI | GitHub CLI (`gh`) | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| GitLab CLI | GitLab CLI (`glab`) | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| Linear CLI | Linear issue tracker CLI (`linear`) | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| delta | better Git diffs | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| lazygit | Git TUI | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| lazydocker | Docker TUI | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| mprocs | run and monitor multiple processes | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| tmux | terminal multiplexer | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |
| Neovim | terminal editor | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.workstation.toml) |

**Java and Kotlin** (`mise.java.toml`, `MISE_ENV=java`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| Temurin JDK | OpenJDK distribution | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.java.toml) |
| Maven | JVM build tool | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.java.toml) |
| Gradle | JVM build tool | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.java.toml) |
| Kotlin | Kotlin compiler and REPL | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.java.toml) |

**Go** (`mise.go.toml`, `MISE_ENV=go`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| Go | Go toolchain | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.go.toml) |
| golangci-lint | Go linter runner | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.go.toml) |
| Delve | Go debugger (`dlv`) | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.go.toml) |
| Air | Go live reload | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.go.toml) |
| ko | container images for Go | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.go.toml) |

**Python** (`mise.python.toml`, `MISE_ENV=python`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| uv | Python package and environment manager | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.python.toml) |
| Ruff | Python linter and formatter | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.python.toml) |
| IPython | Python REPL | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.python.toml) |

**Node and frontend** (`mise.node.toml`, `MISE_ENV=node`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| Node.js | JavaScript runtime | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.node.toml) |
| pnpm | JavaScript package manager | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.node.toml) |
| Yarn | JavaScript package manager | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.node.toml) |
| Bun | JavaScript runtime and bundler | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.node.toml) |

**Cloud, Kubernetes, and GitOps** (`mise.cloud.toml`, `MISE_ENV=cloud`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| kubectl | Kubernetes CLI | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| kubectx | switch Kubernetes contexts; also `kubectl ctx` | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| kubens | switch Kubernetes namespaces; also `kubectl ns` | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| k9s | Kubernetes TUI | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| kind | upstream Kubernetes clusters in Docker | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| k3d | k3s clusters in Docker | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| Helm | Kubernetes package manager | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| Telepresence | local-to-cluster development | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| Kustomize | Kubernetes configuration overlays | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| Argo CD CLI | Argo CD GitOps client | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| Flux CLI | Flux GitOps client | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| SOPS | structured secrets encryption | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| age | encryption tool | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| AWS CLI | AWS cloud client | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| doctl | DigitalOcean cloud client | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| hcloud | Hetzner Cloud client | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| Terraform | infrastructure as code | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| OCI CLI | Oracle Cloud client (`oci`) | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| grpcurl | gRPC client | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| pgcli | PostgreSQL interactive client | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| mycli | MySQL interactive client | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |
| Pyahu CLI | local development stack (`pyahu up`) | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.cloud.toml) |

**AI** (`mise.ai.toml`, `MISE_ENV=ai`, rolling)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| Claude Code | Anthropic coding agent | [latest](https://github.com/pyahu/toolchain/blob/main/mise.ai.toml) |
| Codex CLI | OpenAI coding agent | [latest](https://github.com/pyahu/toolchain/blob/main/mise.ai.toml) |
| OpenCode | provider-flexible coding agent | [latest](https://github.com/pyahu/toolchain/blob/main/mise.ai.toml) |
| Ollama | local model runtime | [latest](https://github.com/pyahu/toolchain/blob/main/mise.ai.toml) |
| Kimi Code | coding agent (`kimi`); add `node` | [latest](https://github.com/pyahu/toolchain/blob/main/mise.ai.toml) |
| Pi coding agent | extensible coding agent (`pi`); add `node` | [latest](https://github.com/pyahu/toolchain/blob/main/mise.ai.toml) |

**Architecture** (`mise.arch.toml`, `MISE_ENV=arch`)

| Tool | Purpose | Version |
| ---- | ------- | ------- |
| D2 | diagrams as code | [Exact pin](https://github.com/pyahu/toolchain/blob/main/mise.arch.toml) |
<!-- catalog:end -->
