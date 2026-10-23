# `crystalmethod/dotfiles`

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/). The
repository is the source of truth for shell configuration, tool version
pinning, and the bootstrap installer. `chezmoi apply` renders and installs the
target files into `$HOME`.

## 📦 Features

| Feature | What it gives you | Deep dive |
| --- | --- | --- |
| 🍎🐧 **Cross-platform by default** | Shared source, OS-specific installs | [Details](#install-scripts) |
| ⚡ **mise-managed tools** | Versions pinned, installed on apply | [Details](#install-scripts) |
| 🔐 **Encrypted secrets** | Secrets stay out of the public repo | [Details](#cross-platform-behavior) |
| 🎨 **Bundled paid fonts** | MonoLisa shipped age-encrypted | [Details](#bundled-fonts) |
| 🍺 **Homebrew everywhere** | macOS/Linux/WSL2, arch-aware PATH | [Details](#cross-platform-behavior) |

> [!NOTE]
> Secrets are age-encrypted; `chezmoi apply` decrypts them only with your age key.

## Repository layout

```text
.
├── home/
│   ├── .chezmoi.yaml.tmpl              # chezmoi config template
│   ├── .chezmoitemplates/              # cross-platform templates (e.g. rbw)
│   ├── .chezmoiscripts/                # run_once_* and run_after_* install scripts
│   ├── dot_config/                     # tool configs (~/.config)
│   ├── dot_zprofile.tmpl               # login shell template
│   ├── dot_zshrc.tmpl                  # interactive shell template
│   ├── Library/Fonts/                  # macOS fonts (ignored off macOS via .chezmoiignore)
│   └── private_dot_local/share/fonts/  # Linux fonts (run_after_30-install-fonts)
├── install/
│   ├── common/                         # shared installers (brew, mise, fonts)
│   ├── macos/                          # macOS-specific scripts (deps, clt)
│   └── ubuntu/                         # Ubuntu/WSL2 scripts (deps)
├── scripts/                            # project tooling (run_unit_test.sh)
├── tests/                              # Bats unit tests for install scripts and templates
├── setup.sh                            # one-shot bootstrap installer
└── Makefile                            # dev tasks (make test, lint, format)
```

> [!WARNING]
> This is someone's personal setup. Prefer `chezmoi init` with your own repo over blindly applying this one.

## 🚀 Quick Start

Install via the automated bootstrap (`setup.sh`) or manually with chezmoi.

**🚀 Privileged (default)**

```bash
# Interactive, privileged install
curl -fsSL https://raw.githubusercontent.com/crystalmethod/dotfiles/main/setup.sh | bash
```

**👤 User-space (no sudo)**

```bash
# User-space install (no sudo)
curl -fsSL https://raw.githubusercontent.com/crystalmethod/dotfiles/main/setup.sh \
  | bash -s -- --mode user
```

**🔍 Dry-run**

```bash
# See what would happen without executing anything
curl -fsSL https://raw.githubusercontent.com/crystalmethod/dotfiles/main/setup.sh \
  | bash -s -- --dry-run
```

**Manual**

```bash
# 1. Install chezmoi, e.g. via Homebrew
brew install chezmoi

# 2. Init from this repository and apply
chezmoi init https://github.com/crystalmethod/dotfiles
chezmoi apply
```

The automated bootstrap (`setup.sh`) performs the following steps:

1. **Detects the OS** (Darwin or Linux) and validates the run mode.
2. **Keeps sudo alive** — via the macOS Keychain on Darwin, via `sudo -v` on
   Linux. Skipped when running non-interactively (e.g. CI).
3. **Bootstraps Homebrew** — system-wide under `sudo` in privileged mode, or
   into `~/.homebrew` in user mode. Linux privileged mode installs its apt
   prerequisites and uses `/home/linuxbrew/.linuxbrew`.
4. **Runs chezmoi** — downloads the `chezmoi` binary, runs `chezmoi init` from
   this repository, then `chezmoi apply`.

Run modes:

- `privileged` (default): installs Homebrew system-wide with `sudo`
  (`/opt/homebrew` on Apple Silicon, `/usr/local` on Intel, or
  `/home/linuxbrew/.linuxbrew` on Linux). Linux mode installs `build-essential`,
  `procps`, `curl`, `file`, and `git` with apt first.
- `user`: installs Homebrew in user space (`~/.homebrew`) without `sudo`.
  On Linux, install `build-essential`, `procps`, `curl`, and `git` first.
  Custom-prefix installs may build formulae from source instead of using bottles.

Every `chezmoi apply` re-runs the `run_after_*` scripts, which re-align
mise-managed tools with the pinned versions in the mise config.

<details>
<summary>📦 Install scripts</summary>

### Install scripts

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
- `install/common/misc.sh`, `install/macos/common/misc.sh` — optional
  Homebrew packages (`ghostty`, `rbw`, `tmux` on all platforms, extras for macOS).
- `install/common/fonts.sh` — refreshes the fontconfig cache for the bundled
  fonts on Linux/WSL2 (see "Bundled paid fonts" below).

### Language runtimes

```toml
# Language runtimes
java = "temurin-25"
http:jdtls = {
  version = "1.58.0"
  url = "https://download.eclipse.org/jdtls/milestones/1.58.0/jdt-language-server-1.58.0-202604151538.tar.gz"
  sha256 = "2a5bbe55ec91b4325392050dc422cead3220a2459b3766be35e1fff45b4a50d9"
}
node = "lts"
```

</details>

<details>
<summary>🎨 Bundled fonts</summary>

### Bundled fonts

> [!TIP]
> Encrypt each font with the repo recipient into BOTH platform directories.

Homebrew and mise cannot install commercial fonts such as MonoLisa, so the
repository carries them as `age`-encrypted sources. Chezmoi decrypts a source
file when its name starts with `encrypted_`, so each font source uses
`encrypted_<name>.ttf.age` and maps to `<name>.ttf` in the platform font
directory on apply (no copying):

- **macOS** — `home/Library/Fonts/MonoLisa/encrypted_*.ttf.age` →
  `~/Library/Fonts/MonoLisa/*.ttf` (CoreText picks these up automatically).
- **Linux/WSL2** — `home/private_dot_local/share/fonts/MonoLisa/encrypted_*.ttf.age`
  → `~/.local/share/fonts/MonoLisa/*.ttf` (the fontconfig directory). A
  `run_after_30-install-fonts` hook runs `fc-cache -f` so fontconfig picks
  them up.
- **Windows (native)** — not yet supported; planned as a stub (WSL2 lateral
  access does not expose fonts to native Windows applications such as WezTerm).

OS-conditional rules in `home/.chezmoiignore` hide the cross-platform halves:
`Library/Fonts` off macOS, `.local/share/fonts` on macOS.

To add or update a bundled font, encrypt its `.ttf`/`.otf` files with the repo
recipient into **both** platform directories. Keep the `encrypted_` prefix;
without it chezmoi copies the ciphertext verbatim:

```sh
age -r <RECIPIENT> -o home/Library/Fonts/MonoLisa/encrypted_MonoLisa-Regular.ttf.age \
  MonoLisa-Regular.ttf
age -r <RECIPIENT> -o home/private_dot_local/share/fonts/MonoLisa/encrypted_MonoLisa-Regular.ttf.age \
  MonoLisa-Regular.ttf
```

Verify the mapping and decryption with `chezmoi target-path` (must end in
`.ttf`) and `chezmoi cat ~/Library/Fonts/MonoLisa/MonoLisa-Regular.ttf`.

</details>

## Platform support

| Platform | Homebrew location | Notable setup |
| --- | --- | --- |
| 🍎 macOS (arm64) | `/opt/homebrew` | Rosetta installed on Apple Silicon; Xcode Command Line Tools |
| 🍎 macOS (x86_64 / Intel) | `/usr/local` | Xcode Command Line Tools |
| 🐧 Linux (Ubuntu/WSL2) | `~/.linuxbrew` or `/home/linuxbrew/.linuxbrew` | Shared brew packages |
| 🪟 Windows (native) | — | Planned as a stub; WSL2 is already covered by the Linux scripts |

> [!CAUTION]
> Native Windows is not yet supported; WSL2 lateral access does not expose fonts to native Windows apps.

<details>
<summary>🔗 Cross-platform behavior</summary>

### Cross-platform behavior

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

This keeps `rbw` unlock working in a terminal on Linux/WSL2, where the macOS
GUI `pinentry` default is not available.

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

</details>

<details>
<summary>🧪 Development</summary>

### Development

```sh
make test     # Run the Bats unit tests (targets macOS by default)
make lint     # Run shellcheck on the install/ and scripts/ sources
make format   # Check shell formatting with shfmt (diff only)
```

`textlint` checks Markdown prose via pre-commit
(`.pre-commit-config.yaml`).

</details>
