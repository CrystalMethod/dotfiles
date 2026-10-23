# DOX — home/ (chezmoi dotfile source tree)

## Purpose

The `home/` directory is the chezmoi source tree: the target dotfiles,
their templates, and per-OS install scripts that chezmoi renders and applies
into `$HOME` on `chezmoi apply`.

## Ownership

- All dotfile/configuration source and templates live under `home/`.
- `home/.chezmoiscripts/` — `run_once_*` / `run_after_*` scripts executed by
  chezmoi during apply, grouped per OS (`common/`, `linux/`, `macos/`).
- `home/.chezmoitemplates/` — cross-platform templates (e.g. the rbw config).
- `home/dot_config/` — rendered app configs (`exact_shell`, `ghostty`, `git`, `mise`, `rbw`, `fnox`, `television`).
- `home/private_dot_ssh/` — SSH keys; private/encrypted files (`*.age`).
- `home/private_dot_local/share/fonts/` — age-encrypted Linux fonts
  (`encrypted_*.ttf.age`), decrypted to `~/.local/share/fonts/`.
- `home/Library/` — macOS app configs and bundled fonts (`Application
  Support/rbw`, `Fonts/MonoLisa/encrypted_*.ttf.age` → `~/Library/Fonts/`).

## Local Contracts

- Files under `home/` use chezmoi naming conventions (`.tmpl` for templates,
  `dot_`/`private_` prefixes, `.chezmoi*.tmpl` for source-level templates).
- Keep OS-specific logic in the per-OS `.chezmoiscripts/` subfolders, not in
  shared templates, unless the shared template branches on OS via Go templates.
- Never commit plaintext secrets. Sensitive files use age encryption
  (`*.age`). On CI (`--no-tty`), drop encrypted targets from chezmoi control
  because decryption needs a TTY.
- Bundled fonts ship as age-encrypted sources per platform, each mapping
  directly to the platform font directory: macOS `home/Library/Fonts/`
  → `~/Library/Fonts/`, Linux `home/private_dot_local/share/fonts/` →
  `~/.local/share/fonts/`. Encrypted files need the `encrypted_` prefix
  (`encrypted_*.ttf.age`); without it chezmoi copies the ciphertext verbatim
  and macOS never registers the font. `home/.chezmoiignore` hides the
  irrelevant half per OS. The Linux `run_after_30-install-fonts` hook refreshes
  `fc-cache`.
- Declarative bootstrap and tool pinning live in `home/dot_config/mise/config.toml`.
- Linux privileged setup installs Homebrew at `/home/linuxbrew/.linuxbrew`;
  user mode uses `~/.homebrew`.
- DOX docs are repo tooling, never applied to `$HOME`: `home/.chezmoiignore`
  ignores `**/AGENTS.md`.

## Work Guidance

- Verify template rendering before applying: `chezmoi execute-template`,
  `chezmoi cat`, or `chezmoi diff` (see root AGENTS.md / references).
- Pin each managed tool in `mise` config. For runtimes,
  runtime, documenting the tool in the README "Language runtimes" list.

## Verification

- Template tests: `bats -r tests/templates/` (also run by `make test`).
- Full suite: `TARGET_OS=macos ./scripts/run_unit_test.sh`.

## Child DOX Index

- `home/.chezmoiscripts/` — install-trigger scripts per OS (thin; covered here).
- `home/.chezmoitemplates/` — shared templates (thin; covered here).
- No child AGENTS.md files at this level; these folders are single-purpose
  collections, not independent work contracts.
