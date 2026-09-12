# Security policy

## Supported versions

Security fixes are applied to the latest published release and `main`. Older tags remain available
for reproducibility and rollback but do not normally receive backports. The rolling `ai` profile
tracks upstream releases under the separate policy documented in [docs/updates.md](docs/updates.md).

## Report a vulnerability privately

Do not open a public issue for a suspected vulnerability, compromised artifact, malicious upstream
release, credential exposure, or installer behavior that could overwrite user data.

Use [GitHub private vulnerability reporting](https://github.com/pyahu/toolchain/security/advisories/new).
Include:

- the affected commit, tag, profile, tool, and platform;
- a minimal reproduction or evidence, without real credentials;
- the impact and whether exploitation is known to be active;
- any safe version or mitigation you have already verified;
- a private way to coordinate if your GitHub account is not sufficient.

The maintainer aims to acknowledge reports within three business days and provide an initial
assessment within seven business days. Remediation timing depends on severity and upstream
availability. Coordinated disclosure will be agreed with the reporter; please allow time for a fix
and release before publishing details.

The project will credit reporters who want attribution. It will not request exploit development,
access to unrelated systems, or destruction of data as part of validation.
