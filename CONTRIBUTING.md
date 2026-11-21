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
3. **Fits a profile.** A profile groups the tools of one workflow in its own `mise.<env>.toml` file. The base
   profile is deliberately minimal, so a new tool usually belongs in an existing profile, or in a new one if a
   whole workflow is missing.

Open the PR with the tool pinned to an exact reviewed release and add its display name, purpose, and
rationale to `catalog.toml`. Regenerate the public tables with `./scripts/catalog.py`. CI must pass
on Linux and macOS.

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

## Running the checks

Before submitting a change, run the same focused checks used by CI:

```sh
mise fmt --check
mise x ruff@0.14.5 -- ruff check scripts
mise x ruff@0.14.5 -- ruff format --check scripts
mise x shellcheck@0.11.0 -- shellcheck install.sh bin/* tests/*.sh scripts/*.sh
mise x actionlint@1.7.12 shellcheck@0.11.0 -- actionlint
./scripts/catalog.py --check
./scripts/docs-check.py
python3 scripts/test-catalog.py
./scripts/release-check.sh
./tests/install.sh
./tests/shims.sh
```

The GitHub Actions matrix then installs each profile on Linux, installs the complete catalog on
macOS, executes representative binaries, and exercises a clean global install/uninstall lifecycle
on both certified platforms.

## Publishing the website

The site at <https://toolchain.pyahu.io> is the `toolchain` Worker on Cloudflare. `wrangler.jsonc` declares
the custom domain and keeps `toolchain.terson.workers.dev` working for older links. Cloudflare Workers Builds
deploys every push to `main` with these settings:

| Setting | Value |
| --- | --- |
| Production branch | `main` |
| Build command | `cd website && npm ci && npm run build` |
| Deploy command | `npx wrangler deploy` |
| Root directory | empty |
| Build variable | `NODE_VERSION=24` |
| API token | a build token of its own, not shared with another Worker |

A failed build never reaches deploy and only shows up in the Worker's Deployments tab, so check it after a
change to the site. If the log says the build token was deleted or rolled, create a new token in Settings,
Builds, API token and retry the build.
