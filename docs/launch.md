# Share Pyahu Toolchain

This page gives maintainers ready-to-use copy and a short demo. Keep the message concrete: what the
project installs, how profiles work, which platforms are tested, and where the limits are.

## One sentence

Pyahu Toolchain is a ready-to-use mise configuration with 67 developer CLI tools in 9 profiles. It
is tested on Linux x64 and macOS arm64.

## Short post

> Pyahu Toolchain 1.0 is available. It starts with four everyday CLI tools and lets you add terminal,
> Java, Go, Python, Node, cloud, AI, or architecture profiles through mise. Stable profiles use exact
> versions, and the installer can preview or remove its changes without replacing your existing mise
> config. Get started at https://toolchain.terson.workers.dev/

## Longer introduction

> Keeping a useful command-line setup aligned across languages and machines often means maintaining
> several version managers or copying a large personal config. Pyahu Toolchain takes a smaller
> approach: four base tools, optional profiles, and one mise workflow.
>
> The stable profiles use exact reviewed versions and are installed in CI on Linux x64 and macOS
> arm64. The installer adds separate config links, leaves an existing `config.toml` alone, supports a
> dry-run, and can uninstall its own links. The AI profile is clearly marked as rolling rather than
> presented as reproducible. Browse the profiles and try the versioned setup at
> https://toolchain.terson.workers.dev/

## Terminal walkthrough

From a release checkout:

```sh
./scripts/demo.sh
```

The demo uses a temporary mise configuration. It previews the base and Python profile, creates the
config links, asks mise what it would install, and removes the links again. It does not change the
user's mise configuration or download the catalog tools.

For a short recording:

1. Show the README header and the nine-profile table.
2. Run `./scripts/demo.sh` in a clean terminal.
3. Open the [profile guide](profiles.md) and [support page](support.md).
4. End on the documentation URL and feedback links.

## Facts you can quote

- 67 tools in the current catalog.
- Four tools in the always-active base.
- Nine profiles in total; eight stable and one rolling.
- Linux x64 and macOS arm64 are the certified CI platforms.
- Stable profiles use exact versions and committed project lockfiles.
- The installer supports dry-run, conflict detection, backups, and uninstall.
- Existing global `config.toml` files are not replaced.

## Avoid these claims

- Do not call every upstream tool or dependency audited.
- Do not claim full reproducibility for npm, pipx, Go, plugin installers, or the AI profile.
- Do not advertise native Windows support.
- Do not say the toolchain replaces containers, project dependency locks, or dotfiles.

The exact boundaries are in [Platform support](support.md).

## Links to share

- Documentation: <https://toolchain.terson.workers.dev/docs/>
- Stable release: <https://github.com/pyahu/toolchain/releases/latest>
- Repository: <https://github.com/pyahu/toolchain>
- Bug report: <https://github.com/pyahu/toolchain/issues/new?template=bug.yml>
- Tool proposal: <https://github.com/pyahu/toolchain/issues/new?template=tool-proposal.yml>
- Question: <https://github.com/pyahu/toolchain/issues/new?template=question.yml>
- Private security report: <https://github.com/pyahu/toolchain/security/advisories/new>
