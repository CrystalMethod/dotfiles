## Purpose

- Cross-platform dotfiles managed with chezmoi (macOS, Linux, WSL2)
- Repo is the source of truth for shell config, tool pinning, and the
  bootstrap installer; `chezmoi apply` renders `home/` into `$HOME`

## Ownership

- Root owns: `setup.sh`, `Makefile`, `mise.toml`, `mise.ci.toml`,
  `.github/workflows/`, `renovate.json`, `.pre-commit-config.yaml`,
  `.textlintrc.json`, `.chezmoi*`,
  `README.md`, `key.txt.age`, `assets/` (README hero and screenshot assets)
- Child docs in the Child DOX Index own all remaining files

## Local Contracts

- `mise.toml` (repo root) pins project dev tools: bats, chezmoi, prek,
  shellcheck, shfmt, textlint. It does not apply to `$HOME`. CI installs it via
  `jdx/mise-action`; `mise.ci.toml` disables the `prek` and `textlint` tools in
  CI; the pre-commit textlint hook pins its own copy
- `home/dot_config/mise/config.toml` pins user-level tools applied to `$HOME`
- Keep repo dev tools out of the user-level config
- Renovate (`renovate.json`, managers: mise, pre-commit, github-actions)
  updates both mise files; patch updates automerge
- Never commit plaintext secrets

## Work Guidance

- Run `make setup` once to install project tools and the prek hooks
- Shell formatting: shfmt with `--indent 4 --space-redirects`
- Pre-commit runs textlint on Markdown prose
- Commit messages use conventional commits (`chore(scope): ...`)
- Change via branch and PR; do not commit directly to `main`

## Verification

- `make test` — bats suite: `tests/install/common`, `tests/templates`, and the
  `TARGET_OS` subtree (defaults to `macos`)
- `make lint` — shellcheck on `install/` and `scripts/`
- `make format` — shfmt diff check
- CI: `.github/workflows/ci.yml`

# DOX framework

- DOX is a performant AGENTS.md hierarchy installed here
- Agent must follow DOX instructions across any edits

## Core Contract

- AGENTS.md files are binding work contracts for their subtrees
- Work products, source materials, instructions, records, assets, and durable
  docs must stay understandable from the nearest applicable AGENTS.md plus every
  parent AGENTS.md above it

## Read Before Editing

1. Read the root AGENTS.md
2. Identify every file or folder you expect to touch
3. Walk from the repository root to each target path
4. Read every AGENTS.md found along each route
5. If a parent AGENTS.md lists a child AGENTS.md whose scope contains the path,
   read that child and continue from there
6. Use the nearest AGENTS.md as the local contract and parent docs for
   repo-wide rules
7. If docs conflict, the closer doc controls local work details, but no child
   doc may weaken DOX

Do not rely on memory. Re-read the applicable DOX chain in the current session
before editing.

## Update After Editing

Every meaningful change requires a DOX pass before you mark the task done.

Update the closest owning AGENTS.md when a change affects:

- Purpose, scope, ownership, or responsibilities
- Durable structure, contracts, workflows, or operating rules
- Required inputs, outputs, permissions, constraints, side effects, or
  artifacts
- User preferences about behavior, communication, process, organization, or
  quality
- AGENTS.md creation, deletion, move, rename, or index contents

Update parent docs when parent-level structure, ownership, workflow, or child
index changes. Update child docs when parent changes alter local rules. Remove
stale or contradictory text right away. Small edits that do not change behavior
or contracts may leave docs unchanged, but the DOX pass still must happen.

## Hierarchy

- Root AGENTS.md is the DOX rail: project-wide instructions, global
  preferences, durable workflow rules, and the top-level Child DOX Index
- Child AGENTS.md files own domain-specific instructions and their own Child
  DOX Index
- Each parent explains what its direct children cover and what stays owned by
  the parent
- The closer a doc is to the work, the more specific and practical it must be

## Child Doc Shape

- Create a child AGENTS.md when a folder becomes a durable boundary with its
  own purpose, rules, responsibilities, workflow, materials, or quality
  standards
- Work Guidance must reflect the current standards of the project or user
  instructions; if there are no specific standards or instructions yet, leave
  it empty
- Verification must reflect an existing check; if no verification framework
  exists yet, leave it empty and update it when one exists

Default section order:

- Purpose
- Ownership
- Local Contracts
- Work Guidance
- Verification
- Child DOX Index

## Style

- Keep docs concise, current, and operational
- Document stable contracts, not diary entries
- Put broad rules in parent docs and concrete details in child docs
- Prefer direct bullets with explicit names
- Do not duplicate rules across files unless each scope needs a local
  version
- Delete stale notes instead of explaining history
- Trim obvious statements, repeated rules, misplaced detail, and warnings for
  risks that no longer exist

## Closeout

1. Re-check changed paths against the DOX chain
2. Update nearest owning docs and any affected parents or children
3. Refresh every affected Child DOX Index
4. Remove stale or contradictory text
5. Run existing verification when relevant
6. Report any docs intentionally left unchanged and why

## User Preferences

When the user requests a durable behavior change, record it here or in the
relevant child AGENTS.md

## Child DOX Index

- `home/AGENTS.md` — chezmoi dotfile source tree: target configs, templates
  (`dot_config/`, `.chezmoitemplates/`), and per-OS `.chezmoiscripts/`.
- `install/AGENTS.md` — reusable install scripts shared per OS (`common/`,
  `macos/`, `ubuntu/`).
- `tests/AGENTS.md` — bats unit test suite for install scripts
  (`tests/install/`) and templates (`tests/templates/`).
- `scripts/AGENTS.md` — project tooling (`run_unit_test.sh`).

Root-owned (no child doc): `setup.sh` (bootstrap), `Makefile` (dev tasks),
`.github/workflows/` (CI), repo-level config (`.chezmoi*`, `renovate.json`,
`.pre-commit-config.yaml`, `.textlintrc.json`).
