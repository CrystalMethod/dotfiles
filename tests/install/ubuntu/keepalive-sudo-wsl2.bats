#!/usr/bin/env bats

# @file tests/install/ubuntu/keepalive-sudo-wsl2.bats
# @brief Tests for the WSL2-aware sudo keepalive logic in setup.sh.
#
# keepalive_sudo_linux() (setup.sh) is WSL2-aware:
#   1. Dry-run guard: returns early without calling sudo.
#   2. WSL2 + no TTY: skips the interactive `sudo -v` password prompt (prints a
#      notice) so it does not hang in non-interactive scenarios.
#   3. WSL2 + TTY: behaves as before (sudo -v prompt).
#   4. Native Linux: behavior is byte-for-byte unchanged (sudo -v prompt).
#   The keep-alive loop (`sudo -n true` / `sleep 60` / `kill -0 $$`) is
#   preserved in all cases.
#
# FR-003 / SC-005: The Linux sudo keepalive SHALL behave correctly in WSL2
#   environments, including non-interactive scenarios, without hanging or
#   failing. FR-006: WSL2 support SHALL NOT change native Linux behavior.
#
# NOTE: setup.sh defines its own `run` function, which clobbers Bats' `run`
# helper. These tests therefore invoke the functions directly and capture
# output/exit status explicitly instead of using Bats' `run`.

bats_require_minimum_version 1.5.0

readonly SETUP_PATH="./setup.sh"

function setup() {
    # setup.sh unconditionally runs `main "$@"` at the end of the file, which
    # would execute the real setup (sudo, chezmoi download, etc.). To test the
    # function in isolation we stub main() to a no-op and mark it readonly so
    # setup.sh cannot redefine it. setup.sh also sets `set -e`; the readonly
    # redefinition error would otherwise abort the source, so we re-apply
    # `set +e` on ERR for the duration of the source.
    main() { :; }
    readonly -f main 2> /dev/null
    trap 'set +e' ERR
    source "${SETUP_PATH}" 2> /dev/null
    trap - ERR

    # Log of every `sudo` invocation made by the function under test.
    SUDO_LOG="${BATS_TEST_TMPDIR}/sudo.log"
    : > "${SUDO_LOG}"
}

# Test 1 — Dry-run guard: keepalive_sudo_linux() must return early without
#   calling sudo at all (FR-003: no hang/failure; the dry-run contract).
@test "[ubuntu] keepalive_sudo_linux returns early in dry-run without calling sudo" {
    is_dry_run() { return 0; }
    sudo() {
        echo "$*" >> "${SUDO_LOG}"
        return 0
    }

    output="$(keepalive_sudo_linux 2>&1)"
    status=$?

    [ "${status}" -eq 0 ]
    [ "${output}" = "[dry-run] Would keep sudo alive (sudo -v / sudo keep-alive loop)." ]
    # sudo must never be invoked in dry-run mode.
    [ ! -s "${SUDO_LOG}" ]
}

# Test 2 — WSL2 + no TTY: the interactive `sudo -v` prompt must be skipped and
#   the non-interactive notice printed, without hanging (FR-003 / SC-005).
@test "[ubuntu] keepalive_sudo_linux skips sudo -v prompt in WSL2 non-interactive" {
    is_wsl2() { return 0; }
    is_tty() { return 1; }
    # Bats runs tests with errexit; the real `[[ "${DRY_RUN}" == true ]]`-based
    # is_dry_run returning 1 (not dry-run) interacts badly with the background
    # keep-alive loop under bats. Overriding it to `return 1` is logically
    # identical (not dry-run) and keeps the test isolated from that quirk.
    is_dry_run() { return 1; }
    sudo() {
        echo "$*" >> "${SUDO_LOG}"
        return 0
    }

    keepalive_sudo_linux > "${BATS_TEST_TMPDIR}/out.txt" 2>&1
    status=$?
    output="$(cat "${BATS_TEST_TMPDIR}/out.txt")"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Non-interactive WSL2: skipping sudo password prompt." ]
    # The interactive sudo -v prompt must NOT be invoked.
    if [ -s "${SUDO_LOG}" ]; then
        ! grep -q -- '-v' "${SUDO_LOG}"
    fi

    # Terminate the background keep-alive loop.
    kill "$!" 2> /dev/null || true
}

# Test 3 — Native Linux: behavior is byte-for-byte unchanged, i.e. the
#   interactive `sudo -v` prompt is still invoked (FR-006).
@test "[ubuntu] keepalive_sudo_linux preserves native Linux sudo -v prompt" {
    is_wsl2() { return 1; }
    is_tty() { return 0; }
    is_dry_run() { return 1; }
    sudo() {
        echo "$*" >> "${SUDO_LOG}"
        return 0
    }

    keepalive_sudo_linux > "${BATS_TEST_TMPDIR}/out.txt" 2>&1
    status=$?
    output="$(cat "${BATS_TEST_TMPDIR}/out.txt")"

    [ "${status}" -eq 0 ]
    # Native Linux must invoke the interactive sudo -v prompt.
    grep -q -- '-v' "${SUDO_LOG}"
    [ "${output}" = 'Checking for `sudo` access which may request your password.' ]

    kill "$!" 2> /dev/null || true
}

# Test 4 — Keep-alive loop: the `sudo -n true` / `sleep 60` / `kill -0 $$`
#   pattern must be preserved (FR-003: keepalive continues to work).
@test "[ubuntu] keepalive_sudo_linux preserves the keep-alive loop" {
    grep -q 'sudo -n true' "${SETUP_PATH}"
    grep -q 'sleep 60' "${SETUP_PATH}"
    grep -q 'kill -0 "\$\$"' "${SETUP_PATH}"
}

# Test 5 — WSL2 + TTY: behaves as before, i.e. the interactive `sudo -v` prompt
#   is still invoked (FR-003 / FR-006: no behavior change when a TTY exists).
@test "[ubuntu] keepalive_sudo_linux prompts sudo -v in WSL2 with a TTY" {
    is_wsl2() { return 0; }
    is_tty() { return 0; }
    is_dry_run() { return 1; }
    sudo() {
        echo "$*" >> "${SUDO_LOG}"
        return 0
    }

    keepalive_sudo_linux > "${BATS_TEST_TMPDIR}/out.txt" 2>&1
    status=$?
    output="$(cat "${BATS_TEST_TMPDIR}/out.txt")"

    [ "${status}" -eq 0 ]
    grep -q -- '-v' "${SUDO_LOG}"
    [ "${output}" = 'Checking for `sudo` access which may request your password.' ]

    kill "$!" 2> /dev/null || true
}
