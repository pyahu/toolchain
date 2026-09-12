# Frequently asked questions

## Do I need every tool?

No. The base has four tools, and every other profile is optional. Start with one language profile
and add more only when you need them.

## Will this replace my mise config?

No. The installer links the base into `conf.d` and adds selected environment files. It does not
replace your global `config.toml`. Run `./install.sh --dry-run` to see the exact paths first.

## Does it replace dev containers or dotfiles?

No. This project manages shared CLI versions. Containers still handle OS libraries, services, and
isolation. Dotfiles still handle personal shell, editor, and application preferences.

## Can a project use another version?

Yes. A repository's local `mise.toml` normally takes precedence over the global toolchain. That is
how projects keep their own runtime requirements.

## Why are AI tools not pinned?

Coding-agent CLIs change quickly and often need recent compatibility fixes. The AI profile follows
recent releases after a short delay and is tested for installation, but it is not reproducible in
the same way as stable profiles.

## Are all 67 tools security-audited?

No. Versions and installation behavior are reviewed and tested, but the project does not audit all
upstream source code or transitive dependencies. See [Platform support](support.md) for the exact
boundary and the [security policy](https://github.com/pyahu/toolchain/blob/main/SECURITY.md) for
private reports.

## Can I add private tools without changing the project?

Yes. Add them to `config.local.toml` in your mise config directory. The installer leaves that file
alone, and mise merges it with the shared configuration.

## Does it support Windows?

Not natively. The installer uses a POSIX shell and symlinks. WSL may work as a Linux environment,
but it is not part of the current CI matrix.

## How do I remove it?

Run `./install.sh --dry-run --uninstall`, inspect the output, then run
`./install.sh --uninstall`. Downloaded tools remain cached by mise until you remove them separately.

## Where should I ask for help?

Start with [Troubleshooting](troubleshooting.md). If the problem remains, open a
[question](https://github.com/pyahu/toolchain/issues/new?template=question.yml) or a
[bug report](https://github.com/pyahu/toolchain/issues/new?template=bug.yml).
