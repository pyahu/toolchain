# Getting started

This guide installs Pyahu Toolchain as a global mise setup. It links configuration files into your
mise directory; it does not copy tools into the repository or replace your existing `config.toml`.

## Before you begin

You need:

- Linux x64 or macOS arm64 for the fully tested path;
- Git, curl, and a POSIX shell;
- [mise installed](https://mise.jdx.dev/getting-started.html).

Check mise before continuing:

```sh
mise --version
```

## 1. Download a stable release

Clone the current release into a directory you plan to keep. The installer creates links back to
this checkout.

```sh
git clone --branch v1.0.1 --depth 1 \
  https://github.com/pyahu/toolchain.git ~/.config/pyahu-toolchain
cd ~/.config/pyahu-toolchain
```

## 2. Choose profiles

The base tools are always included. Add only the profiles that match your work. A common web and
cloud setup is:

```sh
./install.sh --dry-run workstation node cloud
```

The dry-run prints every link without changing the filesystem. Read the [profile guide](profiles.md)
if you are unsure what to select.

## 3. Link the configuration

Run the same command without `--dry-run`:

```sh
./install.sh workstation node cloud
```

The command links the base config and the selected profile files. It also prints the `MISE_ENV`
value you need.

## 4. Install and verify tools

Use that value in the current shell, install the tools, and run a simple check:

```sh
export MISE_ENV=workstation,node,cloud
mise install
mise exec -- rg --version
mise exec -- node --version
mise exec -- kubectl version --client
```

If those commands work, the configuration and selected profiles are active.

## 5. Keep the setup across shells

Add mise activation and the same `MISE_ENV` value to your shell startup file. For zsh:

```sh
eval "$(mise activate zsh)"
export MISE_ENV=workstation,node,cloud
```

For Bash, use `mise activate bash` and your Bash startup file. Open a new shell and run
`mise ls --current` to confirm the result.

## Add or stop using a profile

To add Python later:

```sh
./install.sh python
export MISE_ENV=workstation,node,cloud,python
mise install
```

To stop using a profile, remove its name from `MISE_ENV`. The linked profile file can remain; mise
loads it only when selected.

## Update or roll back

Choose a release from the
[changelog](https://github.com/pyahu/toolchain/blob/main/CHANGELOG.md), then move the checkout to
that tag:

```sh
git fetch --tags
git switch --detach vX.Y.Z
mise install
```

Use the previous tag to roll back. See [Releases](releases.md) for archive downloads and the version
policy.

## Uninstall

Preview and remove the links:

```sh
./install.sh --dry-run --uninstall
./install.sh --uninstall
```

The command removes only links owned by this checkout and restores backups it created. It does not
delete downloaded tools from the mise cache.

Next: browse [common recipes](recipes.md) or keep [Troubleshooting](troubleshooting.md) nearby.
