# Choose profiles

Pyahu Toolchain starts small. The base gives every installation four common tools: `rg`, `fd`,
`jq`, and `yq`. Everything else is optional.

Profiles are additive. Pick the ones that match the work you do and combine them in `MISE_ENV`.

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

The [tool catalog](catalog.md) has the complete list and current versions.

## Common choices

| If you work on… | Start with… |
| --------------- | ----------- |
| A laptop or terminal-heavy workstation | `workstation` plus your language profiles |
| A Java or Kotlin service | `workstation,java` |
| A Go service | `workstation,go` |
| A Python project | `workstation,python` |
| A frontend or Node.js service | `workstation,node` |
| Kubernetes or cloud infrastructure | `workstation,cloud` |
| A Pyahu service | `workstation`, its language profile, and `cloud` |
| CI | Only the language and infrastructure profiles the job needs |
| Coding agents | `ai`; add `node` for Kimi and Pi |

Starting with fewer profiles keeps downloads and upgrades smaller. You can add another profile at
any time.

## Things worth knowing

### Workstation

This is the largest general-purpose profile. It adds shell navigation, readable file and Git views,
forge clients, terminal UIs, tmux, and Neovim. None of them replaces the standard Unix commands in
scripts. A Nerd Font is optional but improves some prompts and editor screens.

### Language profiles

The Java, Go, Python, and Node profiles provide language runtimes and common development tools.
Project-level mise files still take precedence, so a repository can select another runtime version
without changing your global setup.

The Node profile includes pnpm, Yarn, and Bun because real projects in the community use different
lockfiles. Use the package manager selected by each repository.

### Cloud

The cloud profile includes Kubernetes, GitOps, infrastructure, database, and cloud-provider CLIs.
Docker is needed only for local clusters such as kind, k3d, and `pyahu up`. The profile installs
clients; it does not create credentials, contexts, clusters, or cloud resources.

### AI

The AI profile is rolling: its tools follow recent upstream releases after a short delay. It is
tested for installation but does not promise the same version on two different days. There is no AI
lockfile. Ollama models also need their own disk space and memory.

### Architecture

The architecture profile currently contains D2 for diagrams as code. Structurizr CLI and PlantUML
remain OS-level prerequisites because there is no approved mise setup for both supported platforms.

## Enable profiles

The installer creates a mise environment file for each selected profile:

```sh
./install.sh workstation python cloud
export MISE_ENV=workstation,python,cloud
mise install
```

Keep the same `MISE_ENV` value in your shell startup file. See [Getting started](getting-started.md)
for the full setup.
