# DOX — tests/ (bats unit test suite)

## Purpose

The `tests/` directory holds the [bats](https://bats-core.readthedocs.io/)
unit test suite for the install scripts and the chezmoi templates. It serves as
the primary regression guard for installer behavior and rendered template output.

## Ownership

- `tests/install/` — mirrors `install/` layout, per OS:
  - `tests/install/common/` — shared installer tests (`mise.bats`, `brew.bats`).
  - `tests/install/macos/` — macOS installer tests (`common/`, `arm64/`).
  - `tests/install/ubuntu/` — Ubuntu/WSL2 installer tests (`common/`, WSL2 suite).
- `tests/templates/` — template rendering tests (`dot_zprofile.bats`, `rbw.bats`).

## Local Contracts

- Each `.bats` file tests one `install/` or `home/` source file, generally
  matching by name.
- Tests are hermetic: they stub network calls and binaries (curl, mise) via
  TEMP dirs and a controlled `PATH`, never hitting the real network or host
  PATH. They must pass locally and in CI.
- Tests that assert against the real repo config (structural assertions)
  mirror `pinentry-wsl2.bats` / `system-select-wsl2.bats`.
- A test "claim" must actually exercise its subject: a test that passes even
  when the feature under test no longer exists is a defect, not a test (see
  the jdtls structural-test pattern).
- A bats test fails on the FIRST failed assertion; batch or refine assertions
  accordingly.

## Work Guidance

- When adding an installer, add its test in the matching `tests/install/` path.
- When adding a template, add/update its test under `tests/templates/`.
- Read the existing tests covering a behavior BEFORE editing that behavior.

## Verification

- Run a single file: `bats tests/install/common/mise.bats`.
- Full suite: `TARGET_OS=macos ./scripts/run_unit_test.sh` → 0 failures.
- New/changed tests must be green before the change is done.

## Child DOX Index

- `tests/install/` — installer tests (mirrors `install/`; covered here).
- `tests/templates/` — template rendering tests (covered here).
- No child AGENTS.md files; this is a single coherent test suite.
