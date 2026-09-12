# One setup for your everyday CLI tools

Pyahu Toolchain is a ready-to-use mise configuration for developers who move between languages,
cloud platforms, and terminal workflows.

[Get started](getting-started.md){ .md-button .md-button--primary }
[Browse profiles](profiles.md){ .md-button }

## Start small

Every setup begins with `rg`, `fd`, `jq`, and `yq`. Add Java, Go, Python, Node, cloud, AI,
architecture, or workstation tools only when you need them.

```sh
./install.sh workstation node cloud
export MISE_ENV=workstation,node,cloud
mise install
```

## What you can rely on

- Stable profiles use exact reviewed versions.
- Linux x64 and macOS arm64 installations run in CI.
- The installer previews changes and leaves your existing `config.toml` alone.
- Project-level mise files can still select different versions.
- The AI profile is clearly separated as a rolling channel.

Read [Platform support](support.md) for the exact test boundary.

## Find what you need

| Goal | Page |
| ---- | ---- |
| Install for the first time | [Getting started](getting-started.md) |
| Choose a useful combination | [Profiles](profiles.md) and [recipes](recipes.md) |
| Find a tool or version | [Tool catalog](catalog.md) |
| Fix an install or PATH problem | [Troubleshooting](troubleshooting.md) |
| Understand updates and locks | [Update policy](updates.md) |

The source, releases, and issue tracker are on
[GitHub](https://github.com/pyahu/toolchain).
