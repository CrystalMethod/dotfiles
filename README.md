# `crystalmethod/dotfiles`

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/). The
repository is the source of truth for shell configuration, tool version
pinning, and the bootstrap installer. `chezmoi apply` renders and installs the
target files into `$HOME`.

## Features

- **Cross-platform by default** — macOS (Apple Silicon and Intel), Linux, and
  WSL2 share the same chezmoi source while installing OS-specific packages.
- **Homebrew everywhere** — Homebrew installs system packages on macOS and
  Linux/WSL2, with an architecture-aware `brew shellenv` in the login profile.
- **mise-managed tools** — The mise config pins tool versions and
  auto-installs them after every `chezmoi apply`.
- **Encrypted secrets** — `age`-encrypted files (separate from the public
  source) for sensitive configuration.

## Repository layout

| Path | Purpose |
| --- | --- |
| `home/` | Chezmoi source tree (`.chezmoi.yaml.tmpl`, `dot_zprofile.tmpl`, `dot_zshrc.tmpl`, `dot_config/`) |
| `home/.chezmoiscripts/` | `run_once_*` / `run_after_*` scripts that install tools and dependencies per OS |
| `home/.chezmoitemplates/` | Cross-platform templates (e.g. the rbw config with `pinentry` selection) |
| `install/` | Reusable install scripts, shared per OS: `common/`, `macos/`, `ubuntu/` |
| `scripts/` | Project tooling, e.g. `run_unit_test.sh` |
| `tests/` | [Bats](https://bats-core.readthedocs.io/)-based unit tests for the install scripts and templates |
| `setup.sh` | One-shot bootstrap installer |
| `Makefile` | Dev tasks: `make test`, `make lint`, `make format` |

## Setup / install flow

There are two ways to install the dotfiles: the automated bootstrap
(`setup.sh`) or the manual chezmoi flow.

### Automated bootstrap (`setup.sh`)

`setup.sh` installs the system prerequisites first and then applies the
dotfiles with chezmoi:

1. **Detects the OS** (Darwin or Linux) and validates the run mode.
2. **Keeps sudo alive** — via the macOS Keychain on Darwin, via `sudo -v` on
   Linux. Skipped when running non-interactively (e.g. CI).
3. **Bootstraps Homebrew** — system-wide under `sudo` in privileged mode, or
   into `~/.homebrew` in user mode.
4. **Runs chezmoi** — downloads the `chezmoi` binary, runs `chezmoi init` from
   this repository, then `chezmoi apply`.

Run modes:

- `privileged` (default): installs Homebrew system-wide with `sudo`
  (`/opt/homebrew` on Apple Silicon, `/usr/local` on Intel).
- `user`: installs Homebrew in user space (`~/.homebrew`) without `sudo`.

```sh
# Interactive, privileged install
curl -fsSL https://raw.githubusercontent.com/crystalmethod/dotfiles/main/setup.sh | bash

# User-space install (no sudo)
curl -fsSL https://raw.githubusercontent.com/crystalmethod/dotfiles/main/setup.sh \
  | bash -s -- --mode user

# See what would happen without executing anything
curl -fsSL https://raw.githubusercontent.com/crystalmethod/dotfiles/main/setup.sh \
  | bash -s -- --dry-run
```

### Manual

```sh
# 1. Install chezmoi, e.g. via Homebrew
brew install chezmoi

# 2. Init from this repository and apply
chezmoi init https://github.com/crystalmethod/dotfiles
chezmoi apply
```

Every `chezmoi apply` re-runs the `run_after_*` scripts, which re-align
mise-managed tools with the pinned versions in the mise config.

### What the install scripts provide

The `run_*` chezmoi scripts reference the `install/` scripts shared across
platforms:

- `install/common/brew.sh` — `install_brew_packages`: installs missing
  Homebrew packages with `brew install --force` (not a no-op in CI).
- `install/common/mise.sh` — `ensure_mise_min_version` / `install_mise`:
  installs or updates the standalone `mise` binary and runs `mise install`.
- `install/macos/common/command_line_tool.sh` — triggers the Xcode Command
  Line Tools installer with a TTY guard.
- `install/macos/common/dependencies.sh`, `install/ubuntu/common/dependencies.sh`
  — essential Homebrew packages per OS.
- `install/macos/common/misc.sh`, `install/ubuntu/common/misc.sh` — optional
  Homebrew packages (e.g. `rbw`).

## Platform support

| Platform | Homebrew location | Notable setup |
| --- | --- | --- |
| macOS (arm64) | `/opt/homebrew` | Rosetta installed on Apple Silicon; Xcode Command Line Tools |
| macOS (x86_64 / Intel) | `/usr/local` | Xcode Command Line Tools |
| Linux (Ubuntu/WSL2) | `~/.linuxbrew` or `/home/linuxbrew/.linuxbrew` | Shared brew packages |
| Windows (native) | — | Planned as a stub; WSL2 is already covered by the Linux scripts |

## Cross-platform behavior

### Homebrew on Linux/WSL2 (`.zprofile`)

The login profile template (`dot_zprofile.tmpl`) adds a Linux branch that
evaluates Homebrew's shell environment so brew-managed binaries (e.g. `eza`,
`fd`, `bat`) appear in the login-shell PATH on Linux/WSL2:

- Prefers `/home/linuxbrew/.linuxbrew/bin/brew` when present.
- Falls back to `~/.linuxbrew/bin/brew` (`${HOME}/.linuxbrew/bin/brew`).
- `stat` checks guard both paths so the scripts ignore a missing Homebrew.

### Cross-platform `rbw` pinentry

The shared `rbw` config template selects the GUI `pinentry` by default (macOS),
and on Linux/WSL2 picks the most appropriate TUI pinentry:

1. `pinentry-curses` (`/usr/bin/pinentry-curses`)
2. `pinentry-tty` (`/usr/bin/pinentry-tty`)

This keeps `rbw` unlock working non-interactively on Linux/WSL2, where the
macOS `pinentry` default is not available.

### `mise` install failure propagation

`ensure_mise_min_version` now propagates failures from `install_mise`
(`install_mise || return 1`). A failed or interrupted mise install aborts the
setup instead of continuing with a missing or outdated mise.

### Xcode Command Line Tools TTY guard

The Xcode CLT installer blocks on user input when stdin is a TTY. In
non-interactive environments (CI, SSH, automated installs) it prints a note and
returns instead of hanging on the `read` prompt.

### Homebrew install in CI

`install_brew_packages` skipped the actual install in CI with a
no-op `brew info`. It now runs `brew install --force` for missing packages
unconditionally, installing brew packages both locally and in CI.

## Development

```sh
make test     # Run the Bats unit tests (targets macOS by default)
make lint     # Run shellcheck on the install/ and scripts/ sources
make format   # Check shell formatting with shfmt (diff only)
```

`textlint` checks Markdown prose via pre-commit
(`.pre-commit-config.yaml`).
