# Pyahu Toolchain 1.0 launch kit

## Announcement

**Pyahu Toolchain 1.0 is available.** It is a curated catalog of 67 developer CLI tools managed by
mise and organized into nine composable profiles. Start with four universal search/data primitives,
then opt into workstation, Java, Go, Python, Node, cloud, AI, or architecture workflows.

Stable profiles use exact reviewed versions and checked-in Linux x64/macOS arm64 lock data. Every
release gate installs the profiles, runs representative binaries on both certified platforms, and
checks the safe, XDG-aware installer. The AI profile is explicitly rolling and isolated from that
reproducibility promise.

Try the immutable `v1.0.0` release, read the [support contract](support.md), and tell us where the
catalog fits—or does not fit—your workflow:

- [Report a reproducible bug](https://github.com/pyahu/toolchain/issues/new?template=bug.yml)
- [Propose a tool or profile change](https://github.com/pyahu/toolchain/issues/new?template=tool-proposal.yml)
- [Ask a usage question](https://github.com/pyahu/toolchain/issues/new?template=question.yml)
- [Report a vulnerability privately](https://github.com/pyahu/toolchain/security/advisories/new)

Repository and release: <https://github.com/pyahu/toolchain> ·
<https://github.com/pyahu/toolchain/releases/tag/v1.0.0>

## Terminal demo

From a release checkout, run:

```sh
./scripts/demo.sh
```

The demo prints the mise version, previews the selected profiles, links them into an isolated
temporary configuration, shows the exact tools mise would install, and uninstalls the links. It does
not download the catalog or touch the user's mise configuration, so it is suitable for a live demo
or terminal recording.

A short presentation flow:

1. Show the four-tool base and profile map in the README.
2. Run `./scripts/demo.sh` and point out the dry-run and isolated destination.
3. Show a stable lockfile entry with its platform URL/checksum and contrast `mise.ai.toml`.
4. Open the green CI run and the certification contract.
5. End on the three public feedback forms and private security channel.

## Suggested release post

> Pyahu Toolchain 1.0 turns mise into a curated, composable developer workstation contract: 67
> tools, nine opt-in profiles, exact stable pins, cross-platform locks, and tested Linux/macOS
> installs. It stays native on your PATH, preserves your existing mise config, and can be previewed
> or uninstalled safely. Try a versioned release and help us improve the catalog through structured
> bug reports and tool proposals.
