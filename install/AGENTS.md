# DOX — install/ (reusable install scripts)

## Purpose

The `install/` directory holds reusable shell install scripts shared across
platforms. The `home/.chezmoiscripts/*` wrapper scripts and `setup.sh` invoke
them during bootstrap.

## Ownership

- `install/common/` — OS-agnostic install helpers (`brew.sh`, `mise.sh`,
  `misc.sh`, `wsl2.sh`).
- `install/macos/` — macOS-specific installers:
  - `install/macos/common/` — shared across Apple Silicon and Intel.
  - `install/macos/arm64/` — Apple Silicon.
- `install/ubuntu/` — Ubuntu/WSL2-specific installers (`common/`).

## Local Contracts

- Scripts must be POSIX-sh / bash and pass `shellcheck -x`.
- Failures must propagate: an aborted install (e.g. `install_mise || return 1`)
  aborts the setup instead of continuing with a missing tool.
- Scripts must be idempotent where reasonable (brew `install --force` for
  missing packages is intentional; see `install/common/brew.sh`).
- Guard interactive behavior (TTY prompts, sudo) behind a TTY/CI check so
  automated installs never hang.

## Work Guidance

- Keep shared logic in `common/`; add OS-specific behavior in the OS folder.
- Reference installers from the nearest owning `AGENTS.md` chain before editing.
- New install scripts need a matching bats test under `tests/install/`.

## Verification

- Lint: `make lint` (shellcheck across `install/{common,macos/common,ubuntu/common}`).
- Format: `make format` (shfmt, `--indent 4 --space-redirects`).
- Tests: `bats tests/install/...` for the affected OS subtree.

## Child DOX Index

- `install/common/` — shared helpers (thin; covered here).
- `install/macos/` — macOS installers (thin; covered here).
- `install/ubuntu/` — Ubuntu/WSL2 installers (thin; covered here).
- No child AGENTS.md files; these folders are closely coupled shared helpers.
