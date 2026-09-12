# Troubleshooting and rollback

## Establish the active configuration

Start with commands that expose state without changing it:

```sh
mise --version
mise doctor
mise config
printf '%s\n' "${MISE_ENV:-<not set>}"
mise ls --current
```

The supported baseline is recorded in the [support contract](support.md). `mise config` should show
`conf.d/pyahu-toolchain.toml` plus one `config.<profile>.toml` for each enabled profile. If a profile
is missing, export the comma-separated value printed by the installer and put the same line in your
shell startup file:

```sh
export MISE_ENV=workstation,node,cloud
mise install
```

Run `mise activate zsh` or `mise activate bash` in the appropriate shell startup file if installed
tools do not appear on `PATH`. `mise exec -- TOOL --version` is a useful activation-independent
check.

## Installer destinations and conflicts

The effective destination is `$MISE_CONFIG_DIR` when set, otherwise
`${XDG_CONFIG_HOME:-$HOME/.config}/mise`. Preview the exact paths before changing anything:

```sh
./install.sh --dry-run workstation node
```

The installer refuses an unrelated existing file or symlink. Move it yourself after inspecting it,
or use `--force` to preserve it beside the destination as `.bak` (then `.bak.1`, and so on). Never
delete an unfamiliar config merely to make installation pass.

## A tool fails to install

Confirm that the selected version and backend are the ones in this repository, then collect verbose
output locally without publishing tokens or credentials:

```sh
mise config
mise ls-remote TOOL
mise install --verbose TOOL@VERSION
```

Check the profile prerequisites, network access, proxy configuration, free disk space, and upstream
service status. For a stable project checkout, do not regenerate locks just to bypass a failure:

```sh
git status --short
git pull --ff-only
mise install --locked
```

A dirty or locally regenerated lockfile is no longer the reviewed release artifact. Restore it from
the selected Git commit before retrying.

## Common profile-specific cases

- `kimi` or `pi` is missing: enable both `node` and `ai`, then run plain `mise install` because AI is
  rolling.
- `kubectl ctx` or `kubectl ns` is missing: ensure `cloud` is active and confirm the repository's
  `bin` directory appears in `mise env --shell sh`.
- `kind`, `k3d`, or `pyahu up` cannot start a cluster: install and start a supported Docker engine.
- Ollama installs but cannot load a model: model storage and memory requirements are machine- and
  model-specific and are outside the certification contract.
- A project selects another tool version: inspect `mise config`; project configs normally take
  precedence over the global Pyahu selection.

## Roll back safely

For a versioned checkout, moving the checkout to an older release updates the existing installer
symlinks without replacing user configuration:

```sh
git fetch --tags
git switch --detach vX.Y.Z
mise install
```

Return to current releases with `git switch main && git pull --ff-only`. If only one tool is broken,
prefer reporting the failure and selecting a known-good release tag over editing a generated
lockfile locally.

To remove Pyahu Toolchain configuration entirely:

```sh
./install.sh --dry-run --uninstall
./install.sh --uninstall
```

Uninstall removes only symlinks owned by the current checkout and restores installer-created
backups. Downloaded tools remain in mise's cache but become inactive; remove a cached tool separately
with `mise uninstall TOOL@VERSION` only after verifying the exact target.
