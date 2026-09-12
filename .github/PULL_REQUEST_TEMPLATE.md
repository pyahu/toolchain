## What and why

Describe the user problem, the chosen change, and any intentional overlap or compatibility impact.

## Validation

- [ ] I ran `mise fmt --check`.
- [ ] I ran the relevant installer, shim, or catalog tests.
- [ ] I ran `./scripts/catalog.py` after changing profiles or tool metadata.
- [ ] I refreshed stable lockfiles after changing a stable pin.
- [ ] I documented user-visible behavior, prerequisites, support, or rollback changes.
- [ ] I removed secrets and sensitive output from logs and fixtures.

Mark genuinely inapplicable items as `N/A` and explain why. The full CI matrix remains required.
