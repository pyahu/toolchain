# Version and update policy

Pyahu Toolchain separates global installation from project-level verification. Stable profile TOMLs
use exact versions, so the non-invasive global installer cannot unexpectedly upgrade a user's tools
or compete with a lockfile owned by their global mise configuration. Committed project lockfiles add
the artifact URLs and checksums exposed by mise for the supported platforms.

## Stability channels

| Channel | Profiles | Resolution guarantee |
| ------- | -------- | -------------------- |
| Stable | Base, `workstation`, `java`, `go`, `python`, `node`, `cloud`, `arch` | Exact TOML pins plus committed lockfiles for Linux x64 and macOS arm64 |
| Rolling | `ai` | Latest eligible release at install time; intentionally has no lockfile |

Renovate waits seven days before proposing stable updates. Exact pins bypass mise's release-age
filtering, so maintainers must also check release dates during manual updates. The rolling AI profile
uses a 24-hour mise delay: agent CLIs need timely compatibility fixes, but a brand-new publication
still receives a short quarantine window.

Lockfiles improve reproducibility and supply-chain verification where a mise backend exposes
artifact URLs and checksums. Backends such as npm, pipx, and Go can still resolve transitive
dependencies during installation; their behavior is not made fully offline or hermetic by a mise
lockfile.

## Routine updates

Renovate checks on Monday mornings, groups stable pin changes, waits seven days before proposing
eligible releases, and performs weekly mise lockfile maintenance. Every update must pass the Linux
profile matrix and the complete macOS installation before merge.

After changing an exact pin, maintainers refresh its artifacts locally:

```sh
./scripts/update-locks.sh
git diff -- mise.lock 'mise.*.lock'
```

The script deliberately refuses to run if `mise.ai.lock` exists. Override the target platforms for
an isolated compatibility investigation with `MISE_LOCK_PLATFORMS`, but release lockfiles must cover
`linux-x64,macos-arm64`.

## Moving a stable line

Every stable version change is reviewed as an intentional change:

1. Read upstream release notes and identify renamed or removed commands.
2. Change the exact pin in the owning `mise*.toml` file.
3. Run `./scripts/update-locks.sh`.
4. Run the local checks and verify a clean installation.
5. Include user-visible behavior changes in the pull request and changelog.

Routine patch releases normally arrive through the weekly Renovate run.

## Emergency security updates

For an actively exploited vulnerability or compromised release, do not wait for the weekly window:

1. Pin a reviewed safe version exactly in the affected profile.
2. Refresh the lockfiles and inspect changed URLs, checksums, and provenance fields.
3. Run the complete CI matrix.
4. Merge and publish a patch release with an explicit security note.

If no safe version exists, remove or disable the affected tool and document the temporary break in
the same patch release. Do not silently point an existing lock at a different artifact.
