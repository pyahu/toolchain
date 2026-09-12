# Releases and distribution

Pyahu Toolchain uses Semantic Versioning for the behavior of this repository as a product. Upstream
tool versions have their own version schemes; a pin change is classified by its effect on this
toolchain's users.

## Versioning policy

- **Patch** releases contain compatible exact-pin updates, fixes, documentation, and security
  remediations that do not require a user migration.
- **Minor** releases add profiles, tools, optional installer capabilities, or supported platforms
  without removing an existing supported workflow.
- **Major** releases may remove or rename a profile/tool, move a tool so an existing `MISE_ENV` no
  longer supplies it, change installer destinations or flags incompatibly, drop a certified
  platform, move a stable profile to rolling, or adopt an upstream breaking release that requires
  user action.
- Prereleases use SemVer identifiers such as `-rc.1`. They pass the same automated gates, but exist
  to gather installation feedback before the final release and may still change incompatibly.

Only the latest release receives routine fixes. A security issue can justify an exceptional
backport when upgrading immediately would create greater risk.

## Install an immutable version

The recommended distribution is a Git checkout at a release tag. Keep the directory: the installer
creates symlinks to files inside it.

```sh
PYAHU_TOOLCHAIN_VERSION=v1.0.1
git clone --branch "$PYAHU_TOOLCHAIN_VERSION" --depth 1 \
  https://github.com/pyahu/toolchain.git ~/.config/pyahu-toolchain
cd ~/.config/pyahu-toolchain
./install.sh workstation node cloud
```

Release pages also provide a project-owned tar archive and SHA-256 file. Verify and extract it, then
run the same installer from the extracted directory:

```sh
shasum -a 256 -c pyahu-toolchain-1.0.1.tar.gz.sha256
tar -xzf pyahu-toolchain-1.0.1.tar.gz
```

For a project that only needs the base, download both files from the same immutable tag:

```sh
PYAHU_TOOLCHAIN_VERSION=v1.0.1
PYAHU_TOOLCHAIN_RAW="https://raw.githubusercontent.com/pyahu/toolchain/$PYAHU_TOOLCHAIN_VERSION"
curl -fsSL -o mise.toml "$PYAHU_TOOLCHAIN_RAW/mise.toml"
curl -fsSL -o mise.lock "$PYAHU_TOOLCHAIN_RAW/mise.lock"
mise install --locked
```

URLs under `main` are intentionally not recommended for stable consumption because their contents
change without the consumer selecting a new version.

## Upgrade or roll back

Inspect the [changelog](https://github.com/pyahu/toolchain/blob/main/CHANGELOG.md) and select a
release. In a versioned checkout:

```sh
git fetch --tags
git switch --detach vX.Y.Z
mise install
```

The existing configuration symlinks follow the files in that checkout. Re-run `install.sh` only to
enable a newly selected profile. Rollback uses the same command with the previous tag. Review the
[troubleshooting guide](troubleshooting.md) before uninstalling or removing cached tool versions.

## Maintainer release process

1. Ensure the milestone is complete and `main` is clean, synchronized, and green.
2. Choose the SemVer version, update `VERSION`, move changelog entries out of `Unreleased`, and
   update versioned examples.
3. Run `./scripts/release-check.sh`, commit, push, and wait for the exact commit's CI run.
4. Create and push an annotated `v<version>` tag at that commit.
5. Run `./scripts/package-release.sh <empty-output-directory>` and verify its checksum locally.
6. Create the GitHub release from the tag, attach the tar archive and checksum, and mark SemVer
   prereleases appropriately.
7. Download the published assets, verify the checksum and archive contents again, then test the
   documented install command.
8. Publish release notes and close the milestone only after verification succeeds.

Never move or replace a published tag or asset. Correct a bad release with a new patch or
prerelease identifier and explain the superseded version in the changelog.
