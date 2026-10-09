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
- `home/dot_config/` — rendered app configs (`shell`, `git`, `mise`, `rbw`, etc.).
- `home/private_dot_ssh/` — SSH keys; private/encrypted files (`*.age`).

## Local Contracts

- Files under `home/` use chezmoi naming conventions (`.tmpl` for templates,
  `dot_`/`private_` prefixes, `.chezmoi*.tmpl` for source-level templates).
- Keep OS-specific logic in the per-OS `.chezmoiscripts/` subfolders, not in
  shared templates, unless the shared template branches on OS via Go templates.
- Never commit plaintext secrets. Sensitive files use age encryption
  (`*.age`). On CI (`--no-tty`), drop encrypted targets from chezmoi control
  because decryption needs a TTY.
- Declarative bootstrap and tool pinning live in `home/dot_config/mise/config.toml`.
- DOX docs are repo tooling, never applied to `$HOME`: `home/.chezmoiignore`
  ignores `**/AGENTS.md`.

## Work Guidance

- Verify template rendering before applying: `chezmoi execute-template`,
  `chezmoi cat`, or `chezmoi diff` (see root AGENTS.md / references).
- Adding a managed tool means pinning it in `mise` config and, when it is a
  runtime, documenting the tool in the README "Language runtimes" list.

## Verification

- Template tests: `bats tests/templates/*.bats`.
- Full suite: `TARGET_OS=macos ./scripts/run_unit_test.sh`.

## Child DOX Index

- `home/.chezmoiscripts/` — install-trigger scripts per OS (thin; covered here).
- `home/.chezmoitemplates/` — shared templates (thin; covered here).
- No child AGENTS.md files at this level; these folders are single-purpose
  collections, not independent work contracts.
