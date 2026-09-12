# Profile guide

Pyahu Toolchain separates universal command-line primitives from opinionated workflow choices.
The base config is always active after installation; every other profile is opt-in through
`MISE_ENV`. Profiles are additive and may be combined in any order because they do not declare
conflicting versions of the same tool.

## Profile map

<!-- profile-map:start -->
| Profile | Intended user | Adds | Suggested profiles | Prerequisites |
| ------- | ------------- | ---- | ------------------ | ------------- |
| Base | Any developer or automation runner | Search and JSON/YAML processing | — | None beyond mise |
| `workstation` | Developers who want the full Pyahu terminal experience | Shell navigation, readable output, collaboration clients, TUIs, tmux, Neovim | — | Git; Nerd Font recommended for the best prompt/editor rendering |
| `java` | JVM application developers | Temurin, Maven, Gradle, Kotlin | — | `kcat` remains an optional OS package for Kafka work |
| `go` | Go service and CLI developers | Go, linting, debugging, reload, image builds | — | Docker only when publishing images with `ko` |
| `python` | Python application and data developers | uv, Ruff, IPython | — | None |
| `node` | TypeScript, Next.js, and Vue developers | Node and package managers used by supported repositories | — | None |
| `cloud` | Platform engineers and contributors running the Pyahu local stack | Kubernetes, local clusters, GitOps, encryption, cloud providers, IaC, database clients, Pyahu CLI | — | Docker for kind, k3d, and `pyahu up`; `kcat` is an optional OS package |
| `ai` | Developers using local or hosted coding agents | Agent CLIs and Ollama | `node` | Add `node` for Kimi and Pi; sufficient RAM and storage for local Ollama models |
| `arch` | Software architects and developers maintaining diagrams as code | D2 | — | Structurizr CLI and PlantUML remain optional OS packages |
<!-- profile-map:end -->

Common combinations:

- General application development: `workstation` plus one or more language profiles.
- Pyahu service development: `workstation`, the service language, and `cloud`.
- Agent-assisted development: add `ai`; also add `node` when using Kimi or Pi.
- CI: select only the language and infrastructure profiles required by the repository.

## Why each tool is included

<!-- rationale:start -->
### Base

| Tool | Selection rationale |
| ---- | ------------------- |
| ripgrep | Fast, predictable source-tree search used by humans, scripts, editors, and agents. |
| fd | Provides readable file discovery while preserving `find` for portable scripts. |
| jq | The standard automation primitive for inspecting and transforming JSON. |
| yq | Gives YAML workflows the same query and transformation capability as jq. |

### Terminal workstation

| Tool | Selection rationale |
| ---- | ------------------- |
| starship | Supplies one cross-shell prompt configuration instead of shell-specific prompt frameworks. |
| fzf | Powers interactive selection in the shell and integrates with many other terminal tools. |
| zoxide | Makes frequent directory navigation faster without replacing normal `cd`. |
| bat | Improves interactive file reading with syntax and Git context while leaving `cat` available. |
| eza | Adds human-friendly directory and Git views while leaving portable `ls` scripts untouched. |
| dust | Makes interactive disk-usage investigation easier than raw `du` output. |
| glow | Renders repository Markdown without leaving the terminal. |
| yazi | Provides fast visual file navigation for terminal-first workflows. |
| HTTPie | Offers a readable interactive HTTP client; curl remains the portable bootstrap dependency. |
| GitHub CLI | Supports repositories, pull requests, releases, and Actions hosted on GitHub. |
| GitLab CLI | Is retained alongside GitHub CLI because the community works with both forges. |
| Linear CLI | Connects issue workflows to the terminal and automation agents. |
| delta | Improves Git diff readability and integrates with standard Git commands. |
| lazygit | Provides an optional visual Git workflow without replacing the Git CLI. |
| lazydocker | Provides an optional visual view of local Docker workloads. |
| mprocs | Runs and monitors several local development processes in one terminal. |
| tmux | Keeps long-running terminal workspaces persistent and remotely accessible. |
| Neovim | Defines the community's optional terminal editor without imposing it in the base profile. |

### Java and Kotlin

| Tool | Selection rationale |
| ---- | ------------------- |
| Temurin JDK | Uses a widely deployed OpenJDK distribution with an LTS line. |
| Maven | Supports Maven-based Spring Boot and other JVM repositories. |
| Gradle | Supports Gradle-based Java and Kotlin repositories. |
| Kotlin | Makes the standalone compiler and REPL available outside Gradle builds. |

Maven and Gradle overlap intentionally: both build systems exist in supported JVM repositories.

### Go

| Tool | Selection rationale |
| ---- | ------------------- |
| Go | Provides the compiler, standard tooling, and module workflow. |
| golangci-lint | Standardizes a broad, fast lint suite behind one command. |
| Delve | Provides the debugger used by editors and command-line sessions. |
| Air | Supplies the common edit/rebuild/restart loop for local services. |
| ko | Builds minimal container images directly from Go packages without a Dockerfile. |

### Python

| Tool | Selection rationale |
| ---- | ------------------- |
| uv | Consolidates Python installation, environments, dependencies, and tool execution. |
| Ruff | Consolidates fast linting and formatting for supported Python repositories. |
| IPython | Provides a productive exploratory REPL without affecting application dependencies. |

### Node and frontend

| Tool | Selection rationale |
| ---- | ------------------- |
| Node.js | Supplies the active LTS runtime used by supported frontend and TypeScript projects. |
| pnpm | Is the default efficient package manager for current Pyahu JavaScript repositories. |
| Yarn | Preserves compatibility with supported repositories whose lockfile and plugins require Yarn. |
| Bun | Supports repositories and experiments that use Bun as a runtime or bundler. |

The package managers intentionally coexist because a repository's committed lockfile determines which one is used.

### Cloud, Kubernetes, and GitOps

| Tool | Selection rationale |
| ---- | ------------------- |
| kubectl | Is the canonical Kubernetes API command-line client. |
| kubectx | Makes explicit context switching safer and faster. |
| kubens | Makes namespace switching visible and ergonomic. |
| k9s | Provides an operational Kubernetes view for interactive diagnosis. |
| kind | Creates disposable upstream-Kubernetes clusters suited to conformance and integration tests. |
| k3d | Runs lightweight k3s clusters and is the local substrate used by Pyahu CLI. |
| Helm | Installs and packages the charts used by supported platform workloads. |
| Telepresence | Connects local processes to cluster networks for development and debugging. |
| Kustomize | Builds environment-specific Kubernetes manifests without a template language. |
| Argo CD CLI | Supports teams and clusters standardized on Argo CD. |
| Flux CLI | Supports teams and clusters standardized on Flux. |
| SOPS | Encrypts structured secrets while keeping encrypted files reviewable in Git. |
| age | Supplies the small encryption primitive used by SOPS and local workflows. |
| AWS CLI | Supports workloads and infrastructure hosted on AWS. |
| doctl | Supports workloads and infrastructure hosted on DigitalOcean. |
| hcloud | Supports workloads and infrastructure hosted on Hetzner Cloud. |
| Terraform | Provides the established IaC workflow used by current infrastructure repositories. |
| OCI CLI | Supports workloads and infrastructure hosted on Oracle Cloud. |
| grpcurl | Makes gRPC APIs inspectable and scriptable during development and incidents. |
| pgcli | Provides completion and readable output for PostgreSQL-compatible databases. |
| mycli | Provides the equivalent interactive workflow for MySQL-compatible databases. |
| Pyahu CLI | Recreates the community's declared local application stack on k3d. |

kind and k3d serve different local-cluster workflows; Argo CD and Flux cover different managed clusters; the database clients target different protocols. Provider CLIs reflect the infrastructure currently operated by Pyahu contributors.

### AI

| Tool | Selection rationale |
| ---- | ------------------- |
| Claude Code | Supports Anthropic-based agent workflows used by community contributors. |
| Codex CLI | Supports OpenAI-based agent workflows used by community contributors. |
| OpenCode | Provides an open, provider-flexible terminal agent. |
| Ollama | Runs local models when source code or experiments should remain on the workstation. |
| Kimi Code | Adds the Kimi coding workflow used for long-context or alternative-model evaluation. |
| Pi coding agent | Adds a small extensible agent for scripted and experimental workflows. |

These agents coexist as an evaluation bench rather than a single-vendor default. This profile intentionally follows its separately documented rolling update contract.

### Architecture

| Tool | Selection rationale |
| ---- | ------------------- |
| D2 | Produces reviewable diagrams from text with a small standalone CLI. |

Structurizr CLI and PlantUML are documented but not declared because they lack an approved mise entry that works across every supported platform.
<!-- rationale:end -->
