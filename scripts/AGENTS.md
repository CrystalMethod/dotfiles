# DOX — scripts/ (project tooling)

## Purpose

The `scripts/` directory holds project-level developer tooling invoked from
the `Makefile` and CI.

## Ownership

- `scripts/run_unit_test.sh` — runs the bats unit test suite for a given
  `TARGET_OS` (defaults to `macos`).

## Local Contracts

- Scripts must pass `shellcheck -x` (included in `make lint`).
- Scripts should accept `TARGET_OS` via environment to select the OS test
  subset, matching `Makefile` and `.github/workflows/ci.yml`.

## Work Guidance

- Keep tooling thin and delegating; business logic belongs in `install/` or
  `home/` source, testable via `tests/`.

## Verification

- `shellcheck -x scripts/*.sh` via `make lint`.
- `shfmt --indent 4 --space-redirects --diff scripts` via `make format`.

## Child DOX Index

- No child AGENTS.md files at this level.
