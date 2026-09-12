# Contributing

Thanks for helping keep the Pyahu toolchain sharp. Two kinds of contributions are common:

## Proposing a new tool

"Certified" means curated: every tool here is one the community actually standardizes on, not a
collection of everything that exists. Before opening a PR, check that the tool:

1. **Solves a problem the current set doesn't** — or is clearly better than what it replaces
   (say which tool it replaces and why).
2. **Is in the [mise registry](https://mise.jdx.dev/registry.html)** (or installable via a mise
   backend like `pipx:`, `npm:`, `go:`). Tools mise can't manage go in the README's OS-level
   prerequisites instead.
3. **Fits an overlay.** Base is deliberately minimal — new tools usually belong in a
   `mise.<env>.toml` overlay, or a new overlay if a whole workflow is missing.

Open the PR with the tool pinned to an exact reviewed release and a one-line comment saying what it
does. CI must pass on Linux and macOS.

## Bumping a pin

Stable profiles use exact pins. Renovate normally opens the update PR after the seven-day release
quarantine; a maintainer may open one manually for an intentional or urgent update:

```sh
mise outdated              # compare pins with available releases
# edit the pin, then refresh and verify:
./scripts/update-locks.sh
mise install --locked
```

Mention anything that changed behavior (breaking flags, renamed commands) in the PR description so
downstream projects know what to expect. The `ai` overlay is deliberately unpinned and unlocked —
no bump PRs are needed there. See the [version and update policy](docs/updates.md) for the weekly
maintenance and emergency paths.
