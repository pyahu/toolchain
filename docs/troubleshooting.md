# Troubleshooting

Start with read-only commands. They usually show whether the problem is mise activation, a missing
profile, or a project override:

```sh
mise --version
mise doctor
mise config
printf '%s\n' "${MISE_ENV:-<not set>}"
mise ls --current
```

## An installed tool is not on `PATH`

Check that mise is activated in your shell startup file. For zsh, the line is:

```sh
eval "$(mise activate zsh)"
```

Use `bash` instead of `zsh` when needed. Restart the shell, or test without activation:

```sh
mise exec -- rg --version
```

## A profile is missing

`mise config` should list `conf.d/pyahu-toolchain.toml` and one `config.<profile>.toml` file for
each installed profile. `MISE_ENV` must also contain the profile name:

```sh
export MISE_ENV=workstation,node,cloud
mise install
```

Kimi and Pi need both `node` and `ai`. The AI profile is rolling, so install it without `--locked`.

## The installer reports a conflict

Preview the exact destination first:

```sh
./install.sh --dry-run workstation node
```

The destination is `$MISE_CONFIG_DIR` when set. Otherwise it is
`${XDG_CONFIG_HOME:-$HOME/.config}/mise`.

The installer will not replace an unrelated file or symlink. Inspect and move it yourself, or use
`--force` to preserve it beside the destination as `.bak`, `.bak.1`, and so on. Do not delete a
configuration you do not recognize just to make installation pass.

## A tool fails to install

Check the profile prerequisites, network or proxy access, free disk space, and the upstream service.
Then inspect the selected backend and retry with useful diagnostics:

```sh
mise config
mise ls-remote TOOL
mise install --verbose TOOL@VERSION
```

For a stable project checkout, keep the reviewed lockfile intact:

```sh
git status --short
git pull --ff-only
mise install --locked
```

Do not regenerate a release lockfile merely to bypass a failed download.

## The wrong version is active

Run `mise config` from the directory where the problem happens. A project-level `mise.toml` normally
wins over the global Pyahu setup. That is expected and lets each repository choose its own runtime.

## Cloud or local-model tools fail after installation

- kind, k3d, and `pyahu up` need a running Docker engine.
- Kubernetes and cloud CLIs need credentials and contexts configured outside this project.
- Ollama model requirements depend on the model and machine; installing the CLI does not download a
  model.
- `kubectl ctx` and `kubectl ns` need the `cloud` profile and the repository `bin` directory in the
  mise environment.

## Roll back

Switch a versioned checkout to an older release. Existing installer links follow the checkout:

```sh
git fetch --tags
git switch --detach vX.Y.Z
mise install
```

Prefer a known-good tag over editing a generated lockfile.

## Uninstall

Preview first, then remove only links owned by this checkout:

```sh
./install.sh --dry-run --uninstall
./install.sh --uninstall
```

Backups created by the installer are restored. Downloaded tools stay in the mise cache but are no
longer active.
