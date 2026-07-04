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

Open the PR with the tool pinned to its current stable line and a one-line comment saying what it
does. CI must pass on Linux and macOS.

## Bumping a pin

Pins track current stable lines (e.g. `"1.24"`, `"2"`), so most updates flow automatically via
`mise upgrade` and don't need a PR. Open a PR only to move a pin to a **new stable line** (new
major, or new minor for 0.x tools):

```sh
mise outdated        # see what moved
# edit the pin, then verify locally:
mise install
```

Mention anything that changed behavior (breaking flags, renamed commands) in the PR description so
downstream projects know what to expect. The `ai` overlay is deliberately unpinned — no bump PRs
needed there.
