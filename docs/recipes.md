# Common recipes

Run these examples from the Pyahu Toolchain checkout. Replace the profile list with the one that
fits your work.

## Minimal command-line base

Install only `rg`, `fd`, `jq`, and `yq`:

```sh
./install.sh
MISE_ENV='' mise install
```

This is a useful baseline for CI runners and small server environments.

## Terminal plus one language

For a Python workstation:

```sh
./install.sh workstation python
export MISE_ENV=workstation,python
mise install
```

Replace `python` with `java`, `go`, or `node`. You can list more than one for polyglot work.

## Cloud development

Combine the terminal tools, your service language, and the cloud profile:

```sh
./install.sh workstation go cloud
export MISE_ENV=workstation,go,cloud
mise install
```

Docker is required only when you use local clusters or image-building commands. Cloud credentials
and Kubernetes contexts remain your responsibility.

## Coding agents

Install the rolling AI profile with Node support for Kimi and Pi:

```sh
./install.sh node ai
export MISE_ENV=node,ai
mise install
```

AI tools resolve recent versions and are not covered by stable lockfiles. Review their own privacy,
authentication, and billing settings before use.

## Base tools in one repository

Copy the base config and lock from one release tag:

```sh
PYAHU_TOOLCHAIN_VERSION=v1.0.1
PYAHU_TOOLCHAIN_RAW="https://raw.githubusercontent.com/pyahu/toolchain/$PYAHU_TOOLCHAIN_VERSION"
curl -fsSL -o mise.toml "$PYAHU_TOOLCHAIN_RAW/mise.toml"
curl -fsSL -o mise.lock "$PYAHU_TOOLCHAIN_RAW/mise.lock"
mise install --locked
```

Commit both files so collaborators and CI use the same input.

## Keep private additions separate

Put machine-specific tools in `config.local.toml` inside your mise config directory, usually
`~/.config/mise/config.local.toml`. The installer never writes that file. This keeps personal tools
out of the shared catalog and avoids a local fork.

## Check what is active

```sh
mise config
mise ls --current
mise exec -- rg --version
```

If the result is unexpected, see [Troubleshooting](troubleshooting.md).
